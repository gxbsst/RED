class MailTaskJuneRedOneDeliveryLastCallQueue < ActiveRecord::Base
  include MailTask::General

  belongs_to :mail_task
  # has_many :mail_task_apr_ready_to_ship_queue_line_items, :dependent => :destroy

  # Delivery_range_begin = 1501 
  # Delivery_range_end   = 1750
  # 
  # DISCOUNT_PRE_CEMERA               = 0
  # SHIPPING_CHARGE_PRE_CEMERA_IN_US  = 185.29
  # SHIPPING_CHARGE_PRE_CEMERA_OUT_US = 598.49

  # Class methods begin here.
  class << self
    # [
    #      "TRUNCATE #{table_name}",
    #      "TRUNCATE #{line_items_table_name}"
    #    ].each do |statement|
    #      ActiveRecord::Base.connection.execute(statement)
    #    end
    def init_queues
      begin_time = Time.now

      # Cleanup all exists records.
      # self.destroy_all
      # Cleanup all exists records.
      [
        "TRUNCATE #{table_name}"
        ].each do |statement|
          connection.execute(statement)
        end
        # Update AxAccount assign_to (#1001 - #1250)
        [
          ['36', 'CU 0100221', 'Deena Sheldon', 'deenasheldon@mac.com'],
          ['59', 'CU 0100543', 'Marker Karahadian', 'marker@plus8digital.com'],
          ['77', 'CU 0100507', 'Linda C Rheinstein', 'ifont4u@aol.com'],
          ['95', 'CU 0100163', 'Craig Simon', 'CAsimo@mac.com'],
          ['111', 'CU 0100518', 'Manuel Soares', 'np62qb@yahoo.com'],
          ['130', 'CU 0100025', 'Alex Wengert', 'awengert@ottonemenz.com'],
          ['139', 'CU 0100532', 'Mark C. Williams', 'williams@tvmCApital.com'],
          ['140', 'CU 0100293', 'Gavin Stokes', 'gavin@getambitious.com'],
          ['151', 'CU 0100759', 'Shafquat Chuadhary', 'schaudhary@eliteny.com'],
          ['156', 'CU 0100091', 'Brad Batchelor', 'drbatch007@mac.com'],
          ['159', 'CU 0100089', 'Bob Zahn', 'bz4fam@aol.com'],
          ['168', 'CU 0100108', 'Bruce Jaffe', 'brucejaffe@earthlink.net'],
          ['174', 'CU 0100237', 'Donny Jung', 'donnyjung@gmail.com'],
          ['176', 'CU 0100127', 'Chris Donoyan', 'chris@homerunmedia.com'],
          ['189', 'CU 0100084', 'Bjorn Blixt', 'blixt@blixt.dk'],
          ['196', 'CU 0100766', 'Shivam Parikh', 'shivam@shivamparikh.com'],
          ['205', 'CU 0100187', 'Danys Bruyere', 'danys@tsf.fr'],
          ['207', 'CU 0100537', 'Mark Simon', 'simon.m@comCAst.net'],
          ['208', 'CU 0100779', 'Stephen Michael Bier', 'stevetr1@aol.com'],
          ['215', 'CU 0100469', 'Kenji Kato', 'bughunter@mac.com'],
          ['217', 'CU 0100321', 'Greg Voevodsky', 'gvoevodsky@aol.com'],
          ['218', 'CU 0100326', 'Guy Jaconelli', 'rent@videoevolution.tv'],
          ['220', 'CU 0100430', 'John O’Quigley', 'john@motionfx.co.uk'],
          ['223', 'CU 0100102', 'Brian Chumney', 'bchumney@pixsystem.com'],
          # ['234', 'CU 0102221', 'Blaine Golden', ''],
          ['241', 'CU 0100568', 'Michael Andre', 'twomadrussians@hotmail.com'],
          ['244', 'CU 0100651', 'Peter Ahjohn', 'besherrim@aol.com'],
          ['249', 'CU 0100542', 'Mark Vanderploeg', 'pretopostmedia@yahoo.com'],
          ['251', 'CU 0100825', 'Tom Tcimpidis', 'tgt@akamail.com'],
          ['259', 'CU 0100017', 'Albert Cheng', 'acheng@linkline.com'],
          ['262', 'CU 0100027', 'Alexander Korobko', 'i@russianhour.tv'],
          ['269', 'CU 0100837', 'Vance Colvig', 'airservice@sbcglobal.net'],
          ['292', 'CU 0100105', 'Brian Nokell', 'brian@silverdalemedia.com'],
          ['298', 'CU 0100390', 'Jeffrey Taylor', 'jt@taylorstudios.us'],
          ['308', 'CU 0100167', 'Cyrus Hogg', 'cy@karbonarc.com'],
          ['311', 'CU 0100459', 'Karl Brandstater', 'karl@storyhaus.com'],
          ['313', 'CU 0100437', 'John Walsh', 'smilingdog@telus.net'],
          ['315', 'CU 0100138', 'Christian Malone', 'christian.malone@one8six.com'],
          ['320', 'CU 0100708', 'Robert Benderson', 'Bob@cmifilms.com'],
          ['334', 'CU 0100374', 'James Thomas', 'gforce63@comCAst.net'],
          ['337', 'CU 0100481', 'Kirk Kellier', 'sirkirk01@yahoo.com'],
          ['342', 'CU 0100491', 'Lance Frank', 'lancefrank@gmail.com'],
          ['347', 'CU 0100122', 'Charles H. Ferguson', 'amarrs@cferguson.com'],
          ['358', 'CU 0100533', 'Mark Hassenger', 'markhassenger@yahoo.com'],
          ['361', 'CU 0100570', 'Michael Blair', 'mike@mikeblair.com'],
          ['368', 'CU 0100066', 'Barend Onneweer', 'barend@raamw3rk.net'],
          ['395', 'CU 0100509', 'Lorenzo LopezRocha', 'lopezRocha@cox.net'],
          ['397', 'CU 0100068', 'Beatrice Palicka', 'bpalicka@mac.com'],
          ['402', 'CU 0100672', 'Quinn Reimann', 'quinn_reimann@bluewin.ch'],
          ['416', 'CU 0100333', 'Harry Skopas', 'harry@charlex.com'],
          ['425', 'CU 0100696', 'Richard J.H. Wood', 'rich@united.co.nz'],
          ['433', 'CU 0100270', 'Fernando Hashiba', 'fhashiba@gmail.com'],
          ['443', 'CU 0100747', 'Scott Olson', 'scot@rhonda.com'],
          ['446', 'CU 0100700', 'Richard Weinberg', 'weinberg@cinema.usc.edu'],
          ['454', 'CU 0100525', 'Marcus Lundahl', 'marcus@badhotell.com'],
          ['457', 'CU 0100031', 'Ali Berreqia', 'aberreqia@spaarx.com'],
          ['459', 'CU 0100816', 'Toby Marsden', 'toby@toby.org.uk'],
          ['460', 'CU 0100099', 'Brett Halle', 'brett@comet.com'],
          ['471', 'CU 0100074', 'Benjamin Rowland', 'browland770@yahoo.com'],
          ['473', 'CU 0100033', 'Anders Granqvist', 'anders@good.se'],
          ['480', 'CU 0100600', 'Mick Tinbergen', 'm.tinbergen@deebmedia.com'],
          ['487', 'CU 0102107', 'Emmanuel Decarpentrie', 'edecarpe@gmail.com'],
          ['491', 'CU 0100338', 'Heon Irving', 'unusualsuspectsltd@hotmail.co.uk'],
          ['495', 'CU 0100050', 'Andy Cummings', 'andrew@ahc.tv']          
        ].each do |i|
          # item = AxAccount.find(:first, :conditions => ['email = ?' ,i[4]])
          # unless item
            MailTaskJuneRedOneDeliveryLastCallQueue.create(:email_address     => i[3], :first_name => i[2], :ax_account_number => i[1], :sid => self.sid_generator) 
          # end
        end
          
          # accounts = AxAccount.find(:all, :conditions => ['country_region_id = ? or country_region_id =  ? or country_region_id =  ? ', 'CN', 'TW', 'HK'])

            # get all redone that serial number in the range.
            # line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0])
            # delivered = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical = ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0]).map(&:sales_item_reservation_number)
            # losted = (Delivery_range_begin..Delivery_range_end).map{|i|i.to_s} - line_items.map(&:sales_item_reservation_number) - delivered

            # get unique orders which include all lien_items
            # orders = line_items.map(&:ax_order).uniq.compact.select do |order|
            #   if message = order.prepare_delivery_validation
            #     open("#{RAILS_ROOT}/log/invalid_orders.log", "a+") { |file| file << "#{message}\n" }
            #     false
            #   else
            #     true
            #   end
            # end

            # collect all accounts which orders belongs to
            # accounts = orders.map(&:ax_account).uniq

            # create mail queues
             # accounts.each { |account| self.create_queue(account) }
          #Don't send email to the someone
          # ['dbworld@hotmail.com', 'D.frenken@excelite.de', 'biaofan@sina.com', 'ricopedra@mac.com', 'chonglee1978@163.com', 'sureshdagur@hotmail.com', 'zac@aspeninnovation.com', 'ryan@red.com', 'carew@gol.com', 'laurent@redeastpictures.com'].each do |email|
            # MailTaskMayRedChina.find(:first, :conditions => ['email_address = ?', email]).destroy
          # end
            # 
            # puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
            # puts %(Delivered Redone serial number: [#{delivered.join(",")}].)
            # puts %(Lost Redone serial number: [#{losted.join(",")}].)
            # puts %(Amount: #{line_items.size} line_items include redone body.)
            # puts %(Amount: #{orders.size} valid and unique orders.)
            # puts %(Amount: #{accounts.size} valid and unique accounts.)
            # puts %(Amount: #{self.count} records in Mail Queue.)
            # puts %(Missing Staff assign to: #{missing_assign_to_list.join(", ")})
            # puts %(Use #{Time.now - begin_time} seconds.)
          end

          def create_queue(account)
            queue = self.new(
            :email_address           => account.email,
            :full_name               => (account.cust_first_name +  '&nbsp;' +account.cust_last_name),
            :city                    => account.city,
            :sid                     => self.sid_generator
            )

            # # get all order line items which blongs to account.
            #       line_items = []
            #       account.ax_orders.map(&:ax_order_line_items).flatten.each do |line_item|
            #         # Validation for line item has record in products table.
            #         if message = line_item.prepare_delivery_validation
            #           open("#{RAILS_ROOT}/log/invalid_order_line_items.log", "a+") do |file|
            #             file << "#{message}\n"
            #           end
            #           next
            #         end
            #         
            #         line_items << line_items_obj.new(
            #           :ax_order_number               => line_item.ax_order_number,
            #           :confirmed_lv                  => line_item.confirmed_lv,
            #           :delivered_in_total            => line_item.delivered_in_total,
            #           :invoiced_in_total             => line_item.invoiced_in_total,
            #           :item_id                       => line_item.item_id,
            #           :item_name                     => line_item.item_name,
            #           :remain_sales_physical         => line_item.remain_sales_physical,
            #           :sales_item_reservation_number => line_item.sales_item_reservation_number,
            #           :sales_qty                     => line_item.sales_qty,
            #           :sales_unit                    => line_item.sales_unit,
            #           :price                         => line_item.price
            #         )
            #       end
            #       
            #       eval("queue.#{line_items_table_name} = line_items")

            queue.save
          end

          def missing_assign_to_list
            find(:all).select{|queue| queue.assign_to.blank? || AppConfig.CUSTOMER_STAFF[queue.assign_to].nil? }.map(&:ax_account_number)
          end

          def line_items_table_name
            "#{table_name.singularize}_line_items"
          end

          def line_items_obj
            ActiveRecord::Base.const_get(line_items_table_name.classify)
          end
        end

        # Instance methods begin here.
        def line_items
          @line_items ||= self.send(self.class.line_items_table_name)
        end
          def name
            "#{self.first_name.capitalize}"
           # first_name =  AxAccount.find(:first, :conditions => ['ax_account_number = ?', self.ax_account_number]).cust_first_name
           #     last_name =  AxAccount.find(:first, :conditions => ['ax_account_number = ?', self.ax_account_number]).cust_last_name
           #     "#{first_name} #{last_name}"
           # self.full_name
          end
        def deliverable_redone
          line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number IN (?)', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)], :order => 'sales_item_reservation_number ASC')
        end

        def deliverable_redone_complete?
          deliverable_redone.map(&:remain_sales_physical).inject(&:+) <= 0
        end

        def deliverable_redone_quantity
          deliverable_redone.size
        end

        def deliverable_redone_unit_price
          17500.0
        end

        def deliverable_redone_subtotal
          deliverable_redone_quantity * deliverable_redone_unit_price
        end

        def undeliverable_redone
          line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number NOT IN (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0], :order => 'sales_item_reservation_number ASC')
        end

        def deliverable_assembly_list
          list = []
          line_items.find(:all, :conditions => ['item_id <> ?', '101001'], :order => 'item_id ASC').each do |line_item|
            # Skip line_item which has already delivered.
            next if line_item.remain_sales_physical <= 0

            item = list.find{|i| i.item_id == line_item.item_id}
            if item
              item.remain_sales_physical += line_item.remain_sales_physical
            else
              list << line_item
            end
          end
          return list
        end

        def deliverable_assembly
          @deliverable_assembly_list ||= deliverable_assembly_list
        end

        def deliverable_assembly_subtotal
          return 0.0 if deliverable_assembly.empty?
          deliverable_assembly.map{ |item| item.price * item.remain_sales_physical }.inject(&:+)
        end

        def complete_subtotal
          deliverable_redone_subtotal + deliverable_assembly_subtotal
        end

        def deposits
          account_balance.nil? ? 0.0 : account_balance
        end

        def available_credits
          deliverable_redone_quantity * DISCOUNT_PRE_CEMERA
        end

        def credits
          case
          when deliverable_assembly_subtotal == 0 then 0.0
          when available_credits >= deliverable_assembly_subtotal then deliverable_assembly_subtotal
          else
            available_credits
          end
        end

        def all_credited?
          available_credits == credits
        end

        def shipping_charges
          if self.delivery_country_region_id == "US"
            deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_IN_US
          else
            deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_OUT_US
          end
        end

        def sales_tax_state_name
          if self.delivery_country_region_id == "US"
            case self.delivery_state
            when "WA" then return "Washington"
            when "CA" then return "California"
            end
          end

          return ""
        end

        def sales_tax
          tax = 0.0
          if self.delivery_country_region_id == "US"
            case self.delivery_state
            when "WA" then tax = 9.50
            when "CA" then tax = 8.85
            end
          end

          (complete_subtotal - credits) * (tax * 0.01)
        end

        def total_due
          # complete_subtotal - deposits - credits + shipping_charges + sales_tax
          self.prepayments_due
        end

        def bill_to_name
          self.name
        end

        def bill_to_address
          case
          when !self.invoice_address.blank? then self.invoice_address
          when !self.address.blank? then self.address
          end
        end

        def ship_to_name
          case
          when !self.contact_person_name.blank? then self.contact_person_name
          when !self.name.blank? then self.name
          end
        end

        def ship_to_address
          case
          when !self.delivery_address.blank? then self.delivery_address
          end
        end

        def staff_email_address
          email_address = AppConfig.CUSTOMER_STAFF[assign_to]
          email_address ? email_address : "sales@red.com"
        end

        def staff_name_with_email_address
          # if AppConfig.CUSTOMER_STAFF[assign_to]
          #       "#{assign_to} <#{AppConfig.CUSTOMER_STAFF[assign_to]}>"
          #     else
          #       "RED <sales@red.com>"
          #     end
          "RED <orders@red.com>"
        end
        #需要修改 
        def send_mail
          subject = "RED ONE Delivery Last Call"
          super({:subject => subject, :from => '"RED" <orders@red.com>'})
        end
      end
