class MailTaskJulyRedOneDeliveryLastCallQueue < ActiveRecord::Base
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
    #         "TRUNCATE mail_task_july_red_one_delivery_last_call_queues",
    #         # "TRUNCATE #{line_items_table_name}"
    #       ].each do |statement|
    #         connection.execute(statement)
    #       end
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
          ['CU 0100036', 'Andre', 'Mortimer', 'eqnz@xtra.co.nz'],
          ['CU 0100065', 'Balnes', 'Thomas', '  ill@margotfilms.com'],
          ['CU 0100083', 'Birgit', 'Golds-Duarte', '  indiefilmmaker1@yahoo.com'],
          ['CU 0100259', 'Eric C.Y.', 'Young', '  ericyoungproductions@yahoo.co.uk'],
          ['CU 0100280', 'Francisco Outon', 'Arenaza', '  fouton@talentopost.com'],
          ['CU 0100309', 'Gonzalo', 'Mora', '  gonzalo.mora@fxstuntteam.com'],
          ['CU 0100360', 'Jag', 'Sandhu', '  Jag@nlp.tv'],
          ['CU 0100366', 'James', 'Holloway', '  james_holloway@hotmail.com'],
          ['CU 0100396', 'Jerzy', 'Jalocha', '  jalocha@vtr.net'],
          ['CU 0100484', 'Kosyrev', 'Mikhail', '  m-film@yandex.ru'],
          ['CU 0100498', 'Lee', 'Pattinson', '  CAtsndogs@netspeed.com.au'],
          ['CU 0100518', 'Manuel', 'Soares', '  np62qb@yahoo.com'],
          ['CU 0100541', 'Mark Van', 'Aller', '  markvanaller@planet.nl'],
          ['CU 0100667', 'Picha', 'Srisansanee', '  thepicha@gmail.com'],
          ['CU 0100674', 'Ralph', 'Brown', '  ralph.brown@sympatico.CA'],
          ['CU 0100720', 'Rodrigo', 'Lizana', '  rlizana@pixine.cl'],
          ['CU 0100726', 'Ronald', 'Shavchook', '  rbshav@telusplanet.net'],
          ['CU 0100800', 'Thomas', 'Bourke', '  albanydigitalfilms@xtra.co.nz'],
          ['CU 0100819', 'Tom', 'Bridges', '  tom@split-image.co.uk'],
          ['CU 0100075', 'Berger', 'Florian', '  office@kubefilm.com'],
          ['CU 0100011', 'Adam', 'Jeal', '  binaryfilm01@yahoo.co.uk'],
          ['CU 0100140', 'Christian', 'Schrills', '  c@schrills.de'],
          ['CU 0100336', 'Henry', 'Chung', '  magicmtp@netvigator.com'],
          ['CU 0100346', '', 'HUYS', '  jmh@3xplus.com'],
          ['CU 0100351', 'ian', 'Lowrey', '  greattoe@bigpond.net.au'],
          ['CU 0100376', 'Jan-Hilmar', 'Petersen', '  jan-hilmar@web.de'],
          ['CU 0100526', 'Marius', 'Luessi', '  mals@fjordland.com'],
          ['CU 0100645', 'Paul', 'Leeming', '  mindmeld@visceralpsyche.com'],
          ['CU 0100836', 'ULF', 'MELLANDER', '  tricam@telia.com'],
          ['CU 0100853', 'William F.', 'Reid', '  william.reid7@sympatico.CA'],
          ['CU 0100178', 'Dana', 'Morrow', '  danaraymorrow@cox.net'],
          ['CU 0100238', 'Doran', 'Duffin', '  doran@postinteractions.com'],
          ['CU 0100444', 'Jose Miguel Lomena', 'Aguera', '  jose@loasur.com'],
          ['CU 0100522', 'Marc', 'Miller', '  vidkid1@tell-my-story.com'],
          ['CU 0100555', 'Marty', 'Oppenheimer', '  marty@oppenheimerCAmera.com'],
          ['CU 0100582', 'Michael J.', 'Asquith', '  michaelasquith@gmail.com'],
          ['CU 0100639', 'Patrik', 'Forsberg', '  patrik@forsberg.se'],
          ['CU 0100840', 'Vince', 'Pace', '  vpace@pacehd.com'],
          ['CU 0100191', 'Daryl W.', 'Dumala', '  pulsepoint@mac.com'],
          ['CU 0100214', 'David', 'Shorey', '  hollywoodcolor@gmail.com'],
          ['CU 0100323', 'Gregory', 'Leno', '  gleno@aracnet.com'],
          ['CU 0100446', 'Joshua', 'Reis', '  jreis@jrlab.us'],
          ['CU 0100584', 'Michael', 'Kovalenko', '  mk@partspermillion.tv'],
          ['CU 0100655', 'Peter', 'Kullmann', '  peter.kullmann@kubefilm.com'],
          ['CU 0100670', 'Piotr', 'Motykiewicz', '  contact@ntrfilms.com'],
          ['CU 0100802', 'Thomas E', 'Fletcher', '  tom@fletch.com'],
          ['CU 0102926', 'Taylor', 'Steele', '  taylor@poorspecimen.com'],
          ['CU 0100023', 'Alex', 'Fostvedt', '  axl1@mac.com'],
          ['CU 0100049', 'Andrew', 'Young', '  andy@archipelagofilms.com'],
          ['CU 0100189', 'Darin', 'carlson', '  darin.w.CArlson@intel.com'],
          ['CU 0100192', 'Dave', 'Araki', '  dave@mediabutton.com'],
          ['CU 0100274', 'Floris', 'Liesker', '  f.liesker@gmail.com'],
          ['CU 0100394', 'Jeremie', 'Galan', '  g_remy33@hotmail.com'],
          ['CU 0100505', 'Levan', 'Bakhia', '  levan@sarke.ge'],
          ['CU 0100765', 'Shawn', 'Peterson', '  abc@tempesttech.com'],
          ['CU 0100784', 'Steve', 'Shaw', '  paul@axisfilms.co.uk'],
          ['CU 0100860', 'Zack', 'Birlew', 'SQUALL8765@aol.com'],
          ['CU 0100051', 'Aneel M.', 'Pandey', '  apandey@compuserve.com'],
          ['CU 0100088', 'Blake', 'Beynon', '  blake@eatdrink.com'],
          ['CU 0100092', 'Brad', 'Gensurowsky', 'brad.gensurowsky@nbcuni.com'],
          ['CU 0100097', 'Brent', 'Hoff', '  brent@wholphindvd.com'],
          ['CU 0100104', 'Brian', 'Grisham', '  briangrisham@aol.com'],
          ['CU 0100118', 'Chace', 'Strickland', '  chace@mac.com'],
          ['CU 0100174', 'Damon', 'Botsford', '  damonbots@verizon.net'],
          ['CU 0100180', 'Daniel', 'Edwards', '  dan@auroradvd.com'],
          ['CU 0100226', 'Derek', 'Hoffmann', '  Derek@hoffmannfilms.com'],
          ['CU 0100233', 'Djordjije', 'Lekovic', '  info@kinokamera.com'],
          ['CU 0100235', 'Dominique', 'Grenier', '  infos@elkaosfilms.com'],
          ['CU 0100242', 'Douglas', 'Olney', '  doug@tallboyfilms.com'],
          ['CU 0100255', 'Elliot', 'Gabor', '  egproductions@optonline.net'],
          ['CU 0100262', 'Erick', 'Geisler', '  erick.geisler@gmail.com'],
          ['CU 0100263', 'Erik', 'Rangel', '  erik@inthemind.com'],
          ['CU 0100275', 'Floyd', 'Cowans', '  golive6@mac.com'],
          ['CU 0100282', 'Fred G.', 'Comrie', '  fcomrie@gmail.com'],
          ['CU 0100290', 'Gary', 'Childress', '  garychildress@hotmail.com'],
          ['CU 0100306', 'Glen J.', 'Hurd', '  divfotog@earthlink.net'],
          ['CU 0100311', 'Grant W.', 'Hiebert', '  granthiebert@msn.com'],
          ['CU 0100364', 'James Craig', 'Ferguson', '  alcyone777@yahoo.com'],
          ['CU 0100391', 'Jeffry Alan', 'Baldauf', '  jeffbaldauf@yahoo.com'],
          ['CU 0100425', 'John', 'Haddad', '  moscience9@mac.com'],
          ['CU 0100454', 'Justin', 'Palmen', '  jpalmen@gmail.com'],
          ['CU 0100465', 'Ken', 'Bitz', '  ken@solidgreen.net'],
          ['CU 0100488', 'Kurt', 'Robar', '  krobar@alaska.net'],
          ['CU 0100493', 'Larry', 'Walker', '  lwalker@CAci.com'],
          ['CU 0100508', 'Lorenzo Lopez', 'Rocha', '  lopezrocha@cox.net'],
          ['CU 0100538', 'Mark', 'Stockfisch', '  mstockfisch@quantumdata.com'],
          ['CU 0100556', 'Mat', 'Beck', '  matt@entityfx.com'],
          ['CU 0100564', 'Matvei', 'Jivov', '  mjivov@gmail.com'],
          ['CU 0100583', 'Michael J. James', 'III', '  info@vfxpodCAst.com'],
          ['CU 0100615', 'Nicholaus', 'James', '  scenedirector@yahoo.com'],
          ['CU 0100618', 'Nick', 'Mathis', '  nicholas.mathis@gmail.com'],
          ['CU 0100678', 'Ralph Y.', 'Wong', '  ralphyua@hotmail.com'],
          ['CU 0100679', 'Ramesh Dhas', 'Dhason', '  drameshdhas@gmail.com'],
          ['CU 0100691', 'Richard', 'Burton', '  kozmob@earthlink.net'],
          ['CU 0100704', 'Rick Stough - Rick', 'Pour', '  jedirick1@aol.com'],
          ['CU 0100710', 'Robert', 'Goodman', '  goodman@histories.com'],
          ['CU 0100729', 'Ross', 'Webb', '  ross@marsprod.com'],
          ['CU 0100731', 'Ruben', 'CArrillo', '  ruben@lqshawaii.com'],
          ['CU 0100745', 'Scott', 'Hankel', '  scott_h@cwo.com'],
          ['CU 0100761', 'Shane', 'CArruth', '  shane.CArruth@gmail.com'],
          ['CU 0100770', 'Skve', 'Schklair', '  steve@cobalt3d.com'],
          ['CU 0100771', 'Soreyrith', 'Um', '  sumhome@gmail.com'],
          ['CU 0100775', 'Stephen A.', 'Hicks', '  shix@pacbell.net'],
          ['CU 0100780', 'Stephen P.', 'CArson', '  CArson4520@aol.com'],
          ['CU 0100793', 'Syed H.', 'Bilgrami', '  hyderb@gmail.com'],
          ['CU 0100817', 'Todd', 'Hamilton', '  toddhamilton@gmail.com']        
        ].each do |i|
          item = self.find(:first, :conditions => ['email_address = ?', i[3]])
          unless item
            self.create(:email_address => i[3], :first_name => i[1], :last_name => i[2], :ax_account_number => i[0], :sid => self.sid_generator) 
          end
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
            "#{self.first_name.capitalize} #{self.last_name.capitalize}"
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
          super({:subject => subject, :from => '"RED" <redorders@red.com>'})
        end
      end
