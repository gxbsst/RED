class ERP::Item < ActiveRecord::Base
	set_table_name "erp_items"

	# ==================================================================
	# = Build xml method(request_xml) need the following constant data =
	# ==================================================================
	XSI              = "http://www.w3.org/2001/XMLSchema-instance"
	XSD              = "http://www.w3.org/2001/XMLSchema"
	SOAP12           = "http://www.w3.org/2003/05/soap-envelope"
	FIND_LIST_XMLNS  = "http://schemas.microsoft.com/dynamics/2006/02/documents/Inventory"
	QUERY_LIST_XMLNS = "http://schemas.microsoft.com/dynamics/2006/02/documents/QueryCriteria"
	DATA_SOURCE_NAME = "InventTable"
	FIELD_NAME       = "ItemId"
	OPERATOR         = "GreaterOrEqual"
	VALUE            = 0

	class << self
		# =================================================
		# = generate the xml for request to axobj.red.com =
		# =================================================
		def request_xml
			doc = Builder::XmlMarkup.new(:target => "", :indent => 2)
			doc.instruct!
			doc.soap12:Envelope, "xmlns:xsi" => XSI,  "xmlns:xsd" => XSD, "xmlns:soap12" => SOAP12 do

				doc.soap12 :Body do
					doc.findListInventory :xmlns => FIND_LIST_XMLNS do

						doc.DocumentContext do
							doc.MessageId( UUID.random_create.to_s )
							doc.SourceEndpointUser( AppConfig.SOAP_USER )
							doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
							doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
						end

						doc.QueryCriteria :xmlns => QUERY_LIST_XMLNS do
							doc.QueryCriteriaElement do
								doc.DataSourceName( DATA_SOURCE_NAME )
								doc.FieldName( FIELD_NAME )
								doc.Operator( OPERATOR )
								doc.Value( VALUE )
							end
						end

					end
				end

			end
		end

		# =================================================
		# =  get inventories response from axobj.red.com  =
		# =================================================
		def get_axobj_response
			response = ERP::ERPAgent.post( :url => AppConfig.SOAP_IN_SERV,:body => request_xml )

			if response.blank?
				sleep(5)
				response = ERP::ERPAgent.post( :url => AppConfig.SOAP_IN_SERV,:body => request_xml )
			end

			if response.blank?
				sleep(5)
				response = ERP::ERPAgent.post( :url => AppConfig.SOAP_IN_SERV,:body => request_xml )
			end

			if response.blank?
				sleep(20)
				response = ERP::ERPAgent.post( :url => AppConfig.SOAP_IN_SERV,:body => request_xml )
			end

			return response
		end

		# =================================================
		# = get all inventories from remote axobj.red.com =
		# =================================================
		def get_remote_inventories
			( Hpricot.XML(get_axobj_response.body)/:InventTable ).inject([]) do |items,item|
				if (item/:ItemDangerousGood).inner_text == "Yes"
					dangerous = 1
				end 
				items << self.new({ 
					:item_id            => (item/:ItemId).inner_text,
					:name               => (item/:ItemName).inner_text,
					:quantity           => (item/:ItemAvailability).inner_text.to_i,
					:group_id           => (item/:ItemGroupId).inner_text,
					:dim_group_id       => (item/:DimGroupId).inner_text,
					:model_group_id     => (item/:ModelGroupId).inner_text,
					:price              => (item/:ItemPrice).inner_text.to_f,
					:percent_deposit    => (item/:PctDeposit).inner_text.to_f,
					:amount_deposit     => (item/:AmtDeposit).inner_text.to_f,
					:shipping_points    => (item/:ShippingPoints).inner_text.to_f,
					:dangerous          => dangerous
					})
				end if get_axobj_response
			end

			# ========================================================
			# = update inventories data to local database erp::erp_items =
			# ========================================================
			def update_remote_inventories_to_erp_items( remote_inventories )
				ActiveRecord::Base.connection.execute "TRUNCATE #{table_name}"
				remote_inventories.each {|item| item.save}
			end

			# ==============================================================================
			# = get removed or added items between local inventories and axobj inventories =
			# ==============================================================================
			def get_removed_or_new_added_items_to_axobj( remote_inventories )
				local_inventories = ERP::Item.find :all 
				unless local_inventories.blank?
					remote_item_ids, local_item_ids = remote_inventories.map(&:item_id).compact, local_inventories.map(&:item_id).compact
					# Mark ERP Items as new added 
					@added_items = remote_inventories.select{|item| local_item_ids.uninclude?(item.item_id)}
					# Mark ERP Items as deleted 
					@removed_items = local_inventories.select{|item| remote_item_ids.uninclude?(item.item_id)}
					return { :removed_items => @removed_items, :new_items => @added_items }  
				end
			end

			# =================================================
			# = update products accord with axobj inventories =
			# =================================================    
			def update_products( varies )
				local_inventories = ERP::Item.find :all
				unless local_inventories.blank?
					varies_mail_report = {}

					# Handle changed item ...
					varies_mail_report.merge!( :changed_items =>  handle_changed_items )

					# Handle removed item ...
					unless varies[:removed_items].blank?
						erp_product_items = Product.find(:all).map(&:erp_product_item).delete_if{|i| i.blank?}
						varies_mail_report.merge!( :removed_items => ( varies[:removed_items].select{|item| erp_product_items.include?(item.item_id)} ) )
					end

					# Handle new item ...
					unless varies[:new_items].blank?
						add_items = handle_new_items( get_finished_goods( varies[:new_items] ) )
						unless add_items.blank?
							varies_mail_report.merge!(:new_items => add_items)
							add_items.each {|item| item.save if ( item.erp_product_item.match(/^[0-9\-\.]+\w/) )}
						end
					end

					return varies_mail_report
				end
			end

			# =====================================
			# = get finished goods from erp itmes =
			# =====================================
			def get_finished_goods(items)
				items.map(&:group_id).uniq.select{|item| item.match(/-FG$/) }.compact.map do |group_id|
					self.find(:all, :conditions => ["group_id = ?", group_id])
				end.flatten.compact
			end

			# ==============================================================================
			# = Handle new item ... if new finish good in axobj will be update to products =
			# ==============================================================================
			def handle_new_items( new_fg )
				add_items = []
				new_fg.each do |item|
					deposit_value = (item.amount_deposit.zero? ) ? (item.percent_deposit.to_i >= 100 ? 0 : item.percent_deposit * 0.01 * item.price ) : (item.amount_deposit)
					unless Product.find_by_erp_product_item( item.item_id )
						add_items << Product.new({
							:erp_product_item => item.item_id,
							:name             => item.name,
							:quantity         => item.quantity,
							:price            => item.price,
							:deposit          => deposit_value,
							:shipping_points  => item.shipping_points,
							:date_available   => Date.today.to_s,
							:group_id         => item.group_id,
							:description      => "",
							:product_status   => "Uninitialized"
							})
						end
					end.delete_if{ |item| item.blank? }
					return add_items
				end

				# =========================================================================
				# = Handle changed items when products attributes be changed in erp items =
				# =========================================================================
				def handle_changed_items
					products = Product.find :all
					changed_items = []
					products.each do |product|
						erp_item = self.find(:all, :conditions => ["item_id = ?", product.erp_product_item]) unless product.erp_product_item.blank?
						erp_item.each do |item|
							original_attr ,current_attr = {}, {}
							deposit_value = (item.amount_deposit.zero? ) ? (item.percent_deposit.to_i >= 100 ? 0 : item.percent_deposit * 0.01 * item.price ) : (item.amount_deposit) 
							if product.quantity != item.quantity
								product.quantity  = ( item.quantity.to_i < 0 ) ? 0 : item.quantity
								product.save
							end

							if product.group_id != item.group_id
								product.group_id = item.group_id
								product.save  
							end

							if product.shipping_points != item.shipping_points
								original_attr.merge!( :shipping_points => product.shipping_points )
								current_attr.merge!( :shipping_points => item.shipping_points )
							end

							if product.name != item.name
								original_attr.merge!( :name => product.name )
								current_attr.merge!( :name => item.name )
							end

							if product.price != item.price
								original_attr.merge!( :price => product.price )
								current_attr.merge!( :price => item.price )
							end

							if product.deposit != deposit_value
								original_attr.merge!( :deposit => product.deposit )
								current_attr.merge!( :deposit  =>  deposit_value )
							end

							changed_items << { :item => item, :original=> original_attr, :current => current_attr } 
						end unless erp_item.blank?

					end
					return changed_items 
				end

				# ==================================================
				# = sync data among axobj , erp items and products =
				# ==================================================
				def sync_erp_item_and_products
					begin
						remote_inventories = get_remote_inventories
						update_remote_inventories_to_erp_items( remote_inventories )

						varies_data =  update_products( get_removed_or_new_added_items_to_axobj(remote_inventories) )
						connection.execute "TRUNCATE sync_ax_products"  if remote_inventories
						unless varies_data[:new_items].blank?
							varies_data[:new_items].each do |item|
								if ( item.erp_product_item.match(/^[0-9]{6}([\w\-\.]+)?$/) )
									sap = SyncAxProduct.new(:product_id       => Product.find_by_erp_product_item(item.erp_product_item).id,
									:erp_product_item => item.erp_product_item,
									:name             => item.name,
									:price            => item.price,
									:quantity         => item.quantity,
									:deposit          => item.deposit,
									:shipping_points  => item.shipping_points,
									:group_id         => item.group_id,
									:product_status   => item.product_status,
									:status           => "new_items"
									)
									sap.save
								end
							end
						end

						unless varies_data[:removed_items].blank?
							varies_data[:removed_items].each do |item|
								Product.find_all_by_erp_product_item(item.item_id).each do |product|  
									sap = SyncAxProduct.new(:product_id       =>  product.id,
									:erp_product_item => item.item_id,
									:name             => item.name,
									:price            => item.price,
									:dim_group_id     => item.dim_group_id,
									:model_group_id   => item.model_group_id ,
									:group_id         => item.group_id,
									:percent_deposit  => item.percent_deposit,
									:amount_deposit   => item.amount_deposit,
									:shipping_points  => item.shipping_points,  
									:status           => "removed_items"
									)
									sap.save                       
								end
							end
						end

						unless varies_data[:changed_items].blank?
							varies_data[:changed_items].each do |item|
								Product.find_all_by_erp_product_item(item[:item].item_id).each do |product| 
									sap = SyncAxProduct.new(:product_id             => product.id,
									:erp_product_item       => item[:item].item_id,
									:name_local             => item[:original][:name],
									:name_ax                => item[:current][:name],
									:price_local            => item[:original][:price],
									:price_ax               => item[:current][:price],
									:deposit_local          => item[:original][:deposit],
									:deposit_ax             => item[:current][:deposit],
									:shipping_points_local  => item[:original][:shipping_points],
									:shipping_points_ax     => item[:current][:shipping_points],
									:status                 => "changed_items"
									)
									sap.save
								end                         
							end
						end

						OrdersMailer.deliver_sync_products_and_erp_items
					rescue => e
						message = "Failed to sync erp items and products description.<br/> <p style = 'color:red'> #{e.message} </p>"
						OrdersMailer.deliver_sync_products_failed_mail( message )
					end
				end

			end

			module Custom
				def uninclude?( item )
					! include?( item )
				end
			end
			Array.send :include, Custom

		end
