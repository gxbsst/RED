class MailTaskMayRedChina < ActiveRecord::Base
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
          ['an Joye',            'YES','颜先生','Taiwan',   'joyegoods@yahoo.com.tw', '', ''],
          ['Chen HaiMin',        'YES','陈海明','Beijing',  'hmfilm@126.com', '', '010-82841115'],
          ['Dai KeMing',         'YES','戴克明','Hubei',    'dai.coo@hotmail.com', '', '027 62106123'],
          ['Jian Kun',           'YES','简坤',  'Taiwan',   'chienkun@163.com', '', ''],
          ['Liang HongSheng',    'YES','梁宏生','Beijing',  'harrisonliang@yahoo.com.cn', '', '010_13911559900'],
          ['Lu WenFei',          'YES','陆文翡','Shanghai', 'andrew840328@yahoo.com.cn', '', ''],
          ['Wang BaoDong',       'YES','汪宝栋','Beijing',   'cctv_wbd@126.com', '', ''],
          ['Zhang QiNing',       'YES','张启宁','Nanjing',   'qn.z@hotmail.com', '', '13805176984'],
          ['Chen JianDe',         '', '陈健德', 'Hongkong',  'dougkintakchan@yahoo.com', '64042421', ''],
          ['Deng Fei',            '', '邓霏',   'Guangzhou', 'fiometa@hotmail.com', '', ''],
          ['Dong Yang',           '', '董扬',   'Beijing',   'uploadservice@126.com', '', ''],
          ['Du JiaYi',            '', '杜家毅', 'Beijing',   'dujiayifilm@hotmail.com', '', ''],
          ['Feng GuoDong',        '', '冯国栋', 'Beijing',   'nle3d@21cn.com', '', ''],
          ['Fu Qiang',            '', '傅强',   'Beijing',   'mvs800@sina.com', '', ''],
          ['Gu Dao',              '', '古先生', 'Beijing',   'gudao1962@126.com', '', ''],
          ['Guo Qian',            '', '郭倩',   'Nanning',   'guoqian21@163.com', '0771-2518750', ''],
          ['Guo YongHao',         '', '郭永浩', 'Beijing',   'how418@163.com', '', '010-13910527479'],
          ['Ha barbourhabo',      '', '哈先生', 'Beijing',   'barbourhabo@hotmail.com', '', '13901356981'],
          ['He Bin',              '', '何彬',   'Shenzhen',  'hanks339@yahoo.com.cn', '', '13902438339'],
          ['He Qing',             '', '何庆',   'Beijing',   'david@oxygentec.com', '', ''],
          ['Hu ChongXi',          '', '胡崇晰', 'Shanghai',  'huchongxi@vip.sina.com', '', ''],
          ['Huang XuRong',        '', '黄旭荣', 'Beijing',   'jidi_huang@hotmail.com', '', ''],
          ['Kuang Kui',           '', '匡奎',   'Beijing',   'kuangkui168@126.com', '', ''],
          ['Liang Wei',           '', '梁巍',   'Beijing',   'weiwei23liang@hotmail.com', '', '010-15810361385'],
          ['Lin ChingFa',         '', '林 ChingFa', 'Taiwan','ching_fa@lapcc.com', '', ''],
          ['Lin WenJie',          '', '蔺文杰', 'Beijing',   'hxr@ghg-av.com', '', ''],
          ['Liu biao',            '', '刘飚',   'Beijing',   'chongchong413@263.com', '', ''],
          ['Liu HaiYun',          '', '刘云海', 'ChongQing', 'xinyanqq@sohu.com', '', ''],
          ['Liu Hanmeipainei',    '', '刘先生', 'Beijing',   'hanmeipainei@163.com', '', ''],
          ['Liu JianWu',          '', '刘建武', 'Beijing',   'liu1331155@126.com', '', ''],
          ['Liu QingXin',         '', '刘青鑫', 'Beijing',   'ohioliu@yahoo.com.cn', '', ''],
          ['Liu WuZhou',          '', '刘五洲', 'Beijing',   'xunzhaodongbeihu@126.com', '', ''],
          ['Lu ChunSheng',        '', '陆春生', 'Shanghai',  'happyhappyleg@yahoo.com.cn', '', ''],
          ['Lu YingXia',          '', '陆颖霞', 'Yunnan',    'luyingxia_sc@163.com', '', '0871-13577170787'],
          ['Miao Qing',           '', '苗青',   'Beijing',   'miaoqing1976@yahoo.com', '', '010-13910433918'],
          ['Ma ZhiWei',           '', '马志伟', 'Beijing',   'zw731@tom.com', '', '010-13601218731'],
          ['Ma QingYuan',         '', '马清源', 'Beijing',   'xcopro@gmail.com', '', ''],
          ['Peng Wei',            '', '彭威',   'Beijing',   'awin2007@qq.com', '', ''],
          ['Qiu CK',              '', '邱先生', 'Shenzhen',  'qck135@126.com', '', ''],
          ['Sun Tian',            '', '孙田',   'Beijing',   'sunyuliner@vip.sina.com', '', '13041131173'],
          ['Wang',                '', '王先生', 'Taiwan',    'albert-8@yahoo.com.tw', '', ''],
          ['Wang Hu',             '', '王琥',   'Beijing',   'whfilm2008@sina.com', '', '010-13910265404 '],
          ['Wang HuiHui',         '', '汪徽晖', 'Nanjing',   'wanghuihui_njnu@qq.com', '', '15951894827'],
          ['Wang Ming',           '', '王茗',   'Hunan',     'comicsky@gmail.com', '', ''],
          ['Wang Zuo',            '', '王左',   'Beijing',   'wangzuot729@163.com', '', ''],
          ['Wu Jian',             '', '吴剑',   'Shanghai',  'jam_wu@163.com', '', ''],
          ['Xiao ShiQian',        '', '萧拾仟', 'Beijing',   'xiaoshiqian@sohu.com', '', ''],
          ['Xiao ZhiLi',          '', '萧志力', 'Beijing',   'yulxiao@126.com', '', ''],
          ['Xu HaiDong',          '', '许海东', 'Shanghai',  'uuart@163.com', '', ''],
          ['Xu Lei',              '', '徐磊',   'Shanghai',  'dvhome.com.cn@gmail.com','21-55157067', ''],
          ['Xu Li',               '', '徐力',   'Beijing',   'anxl_2001@hotmail.com','010-13501273487', ''],
          ['Xu Ming',             '', '许明',   'Beijing',   '51286898@163.com',   '010-13311133210', ''],
          ['Xu Ming',             '', '徐明',   'Beijing',   'xuxzh_simon@yahoo.com.cn', '', ''],
          ['Yang Long',           '', '杨龙',   'Yunnan',    'yanglong61@126.com', '0871-13888660033', ''],
          ['Yang Tao',            '', '杨涛',   'Beijing',   'yangtt@cnooc.com', '', ''],
          ['Yang Yang',           '', '杨阳',   'Beijing',   'alex@oxygentec.com', '010-13301213365', ''],
          ['Yao Yang',            '', '耀阳',   'Shenzhen',  'liyy@hypch.com',     '', ''],
          ['Yin Tao',             '', '尹涛',   'Yunnan',    'yinglao1222@126.com','', ''],
          ['Yip king chau',       '', '叶 king chau', 'Hongkong', 'markyipkc@gmail.com', '', ''],
          ['Yu XianSheng',        '', '余先生', 'Beijing',   'syys@cafa.edu.cn',   '', ''],
          ['Zhang FengFu',        '', '张锋福', 'Beijing',   'zxdlfilm@126.com',   '', ''],
          ['Zhang JianWei',       '', '张建伟', 'Beijing',   'jianwei5205@163.com','', ''],
          ['Zhang Liang',         '', '张靓',   'Beijing',   'kido217@126.com',    '', ''],
          ['Zhang ShaoHua',       '', '张昭华', 'Guangzhou', '33131331@163.com',   '', ''],
          ['Zhang XianWei',       '', '张先伟', 'Beijing',   'bsbs8009@163.com',   '', ''],
          ['Zhang XiaoYuan',      '', '张晓元', 'Sichuan',   'zxy1955@vip.sina.com', '', ''],
          #['Zhang YaoYi',         '', '张耀乙', 'Shanghai',  '',                  '021-13636322101', ''],
          ['Zhang Yin',           '', '张鹰',   'Hubei',     'zhangyinghbtv@163.com', '', ''],
          ['Zhao YunChuan',       '', '赵运川', 'Beijing',   'zyc@ghg-av.com',    '010-52215808', ''],
          #['Zhou Li',             '', '周立',   'Guangdong',   '',                '020-15817183266', ''],
          ['Zong ChunSheng',      '', '宗春生', 'Beijing',   'zcszx@vip.163.com', '010-65520880', ''],
          ['Zhang Yu',            '', '张宇',   'Shanghai',  'haoqi0101@163.com', '', ''],
          ['Chen Jun',            '', '陈俊',   'Shenzhen',  'guangkong@163.com', '', ''],
          ['Zhang Nan',           '', '张楠',   'BeiJing',   'acrystal@ceacfbt.com', '', ''],
          ['Zhang Jizhong',       '', '张纪中', 'BeiJing',   'dahuzi2222@sina.com', '', ''],
          ['Zhang Jizhong',       '', '张纪中', 'BeiJing',   'dahuzi2222@163.com', '', ''],
          ['Chen Dengke',         '', '陈登科', 'BeiJing',   'chendengke@crifst.com', '', ''],
          ['Wang Yuan',           '', '王媛',   'BeiJing',   'wangyuan0521@163.com', '', ''],
          ['Michale Hu',          '', '胡斌杰', 'Shanghai',  'hubinjie@red.com', '', '']             
        ].each do |i|
          item = AxAccount.find(:first, :conditions => ['email = ?' ,i[4]])
          unless item
            MailTaskMayRedChina.create(:email_address     => i[4], :full_name => i[2],  :en_full_name => i[0], :city => i[3], :sid => self.sid_generator) 
          end
        end
          
          accounts = AxAccount.find(:all, :conditions => ['country_region_id = ? or country_region_id =  ? or country_region_id =  ? ', 'CN', 'TW', 'HK'])

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
             accounts.each { |account| self.create_queue(account) }
          #Don't send email to the someone
          ['dbworld@hotmail.com', 'D.frenken@excelite.de', 'biaofan@sina.com', 'ricopedra@mac.com', 'chonglee1978@163.com', 'sureshdagur@hotmail.com', 'zac@aspeninnovation.com', 'ryan@red.com', 'carew@gol.com', 'laurent@redeastpictures.com'].each do |email|
            MailTaskMayRedChina.find(:first, :conditions => ['email_address = ?', email]).destroy
          end
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
        self.full_name
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
          subject = "RED ONE 中国之旅－北京，上海，香港（5月31日－6月9日）"
          super({:subject => subject, :from => '"欧文" <ryan@red.com>'})
        end
      end
