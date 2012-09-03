class InitMailDatabase < ActiveRecord::Migration
  def self.up
    create_table "mail_task_feb_hello_redone_owner_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "mail_task_feb_nearly_ready_to_ship2_queue_line_items", :force => true do |t|
      t.column "mail_task_feb_nearly_ready_to_ship2_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_feb_nearly_ready_to_ship2_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_feb_nearly_ready_to_ship2_queues", ["sid"], :name => "mail_task_feb_nearly_ready_to_ship2_queues_sid_index"

    create_table "mail_task_feb_nearly_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_feb_nearly_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_feb_nearly_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_feb_nearly_ready_to_ship_queues", ["sid"], :name => "mail_task_feb_nearly_ready_to_ship_queues_sid_index"

    create_table "mail_task_feb_offical_red_delivery_policies", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_feb_ready_to_ship2_queue_line_items", :force => true do |t|
      t.column "mail_task_feb_ready_to_ship2_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_feb_ready_to_ship2_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_feb_ready_to_ship2_queues", ["sid"], :name => "mail_task_feb_ready_to_ship2_queues_sid_index"

    create_table "mail_task_feb_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_feb_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_feb_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_feb_ready_to_ship_queues", ["sid"], :name => "mail_task_feb_ready_to_ship_queues_sid_index"

    create_table "mail_task_feb_red_invited_one_hundred_to_three_hundred_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_feb_red_invited_second_part_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_jan_prepare_delivery_queue_line_items", :force => true do |t|
      t.column "mail_task_jan_prepare_delivery_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_jan_prepare_delivery_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "readed_at", :datetime
    end

    add_index "mail_task_jan_prepare_delivery_queues", ["sid"], :name => "mail_task_jan_prepare_delivery_queues_sid_index"

    create_table "mail_task_jan_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_jan_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
      t.column "delivery_message", :string
    end

    create_table "mail_task_jan_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_jan_ready_to_ship_queues", ["sid"], :name => "mail_task_jan_ready_to_ship_queues_sid_index"

    create_table "mail_task_jan_redone_delivery_policy_six_to_five_hundred_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_jan_redone_delivery_policy_update_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_mar_for_red_day_invited_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "mail_task_mar_nearly_ready_to_ship2_queue_line_items", :force => true do |t|
      t.column "mail_task_mar_nearly_ready_to_ship2_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
    end

    create_table "mail_task_mar_nearly_ready_to_ship2_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "address", :string
      t.column "contact_person_email_address", :string
      t.column "contact_person_first_name", :string
      t.column "contact_person_last_name", :string
      t.column "contact_person_name", :string
      t.column "contact_person_selected_address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_mar_nearly_ready_to_ship2_queues", ["sid"], :name => "mail_task_mar_nearly_ready_to_ship2_queues_sid_index"

    create_table "mail_task_mar_nearly_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_mar_nearly_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
    end

    create_table "mail_task_mar_nearly_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_mar_nearly_ready_to_ship_queues", ["sid"], :name => "mail_task_mar_nearly_ready_to_ship_queues_sid_index"

    create_table "mail_task_mar_nikon_mount_price_adjustment_notice_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "ax_order_numbers", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "email_address", :string
      t.column "quantity", :integer
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "mail_task_mar_payment_status_of_your_order_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "order_number", :string, :default => "", :null => false
      t.column "order_create_date", :string, :limit => 64, :default => "", :null => false
      t.column "customer_number", :string, :limit => 16, :default => "", :null => false
      t.column "email_address", :string, :limit => 32, :default => "", :null => false
      t.column "name", :string, :limit => 32, :default => "", :null => false
      t.column "camera_number", :string, :limit => 32, :default => "", :null => false
      t.column "prepayments_due", :float, :default => 0.0, :null => false
      t.column "payments_received", :float, :default => 0.0, :null => false
      t.column "payments_needed", :float, :default => 0.0, :null => false
      t.column "complete", :boolean, :default => false
      t.column "sid", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "mail_task_mar_ready_to_ship2_queue_line_items", :force => true do |t|
      t.column "mail_task_mar_ready_to_ship2_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
    end

    create_table "mail_task_mar_ready_to_ship2_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "address", :string
      t.column "contact_person_email_address", :string
      t.column "contact_person_first_name", :string
      t.column "contact_person_last_name", :string
      t.column "contact_person_name", :string
      t.column "contact_person_selected_address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_mar_ready_to_ship2_queues", ["sid"], :name => "mail_task_mar_ready_to_ship2_queues_sid_index"

    create_table "mail_task_mar_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_mar_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
    end

    create_table "mail_task_mar_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_mar_ready_to_ship_queues", ["sid"], :name => "mail_task_mar_ready_to_ship_queues_sid_index"

    create_table "mail_task_mar_red_day_invite_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "serial_numbers", :string
    end

    create_table "mail_task_mar_revised_nearly_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_mar_revised_nearly_ready_to_ship_queue_id", :integer
      t.column "ax_order_number", :string
      t.column "confirmed_lv", :string
      t.column "delivered_in_total", :integer
      t.column "invoiced_in_total", :integer
      t.column "item_id", :string
      t.column "item_name", :string
      t.column "remain_sales_physical", :integer
      t.column "sales_item_reservation_number", :string
      t.column "sales_qty", :integer
      t.column "sales_unit", :string
      t.column "price", :float, :default => 0.0
    end

    create_table "mail_task_mar_revised_nearly_ready_to_ship_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "account_balance", :float, :default => 0.0
      t.column "discounts", :float, :default => 0.0
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "phone", :string
      t.column "contact_person_name", :string
      t.column "contact_person_select_address", :string
      t.column "address", :string
      t.column "invoice_address", :string
      t.column "invoice_city", :string
      t.column "invoice_country_region_id", :string
      t.column "invoice_state", :string
      t.column "invoice_street", :string
      t.column "delivery_address", :string
      t.column "delivery_city", :string
      t.column "delivery_country_region_id", :string
      t.column "delivery_state", :string
      t.column "delivery_street", :string
      t.column "assign_to", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index "mail_task_mar_revised_nearly_ready_to_ship_queues", ["sid"], :name => "mail_task_mar_revised_nearly_ready_to_ship_queues_sid_index"

    create_table "mail_task_redone_serial_number_notify_queues", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "ax_order_number", :string
      t.column "email_address", :string
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "serial_number", :string
      t.column "purch_order_form_num", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "readed_at", :datetime
    end

    add_index "mail_task_redone_serial_number_notify_queues", ["sid"], :name => "mail_task_redone_serial_number_notify_queues_sid_index"

    create_table "mail_task_sent_logs", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "mail_queue_id", :integer
      t.column "from", :string
      t.column "to", :string
      t.column "subject", :string
      t.column "body", :text
      t.column "sent", :boolean
      t.column "created_at", :datetime
    end

    create_table "mail_tasks", :force => true do |t|
      t.column "task_name", :string
      t.column "task_description", :text
      t.column "table_name", :string
      t.column "task_date", :date
      t.column "available", :boolean, :default => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end

  def self.down
    drop_table :mail_task_feb_hello_redone_owner_queues                          
    drop_table :mail_task_feb_nearly_ready_to_ship2_queue_line_items             
    drop_table :mail_task_feb_nearly_ready_to_ship2_queues                       
    drop_table :mail_task_feb_nearly_ready_to_ship_queue_line_items              
    drop_table :mail_task_feb_nearly_ready_to_ship_queues                        
    drop_table :mail_task_feb_offical_red_delivery_policies                      
    drop_table :mail_task_feb_ready_to_ship2_queue_line_items                    
    drop_table :mail_task_feb_ready_to_ship2_queues                              
    drop_table :mail_task_feb_ready_to_ship_queue_line_items                     
    drop_table :mail_task_feb_ready_to_ship_queues                               
    drop_table :mail_task_feb_red_invited_one_hundred_to_three_hundred_queues    
    drop_table :mail_task_feb_red_invited_second_part_queues                     
    drop_table :mail_task_jan_prepare_delivery_queue_line_items                  
    drop_table :mail_task_jan_prepare_delivery_queues                            
    drop_table :mail_task_jan_ready_to_ship_queue_line_items                     
    drop_table :mail_task_jan_ready_to_ship_queues                               
    drop_table :mail_task_jan_redone_delivery_policy_six_to_five_hundred_queues  
    drop_table :mail_task_jan_redone_delivery_policy_update_queues               
    drop_table :mail_task_mar_for_red_day_invited_queues                         
    drop_table :mail_task_mar_nearly_ready_to_ship2_queue_line_items             
    drop_table :mail_task_mar_nearly_ready_to_ship2_queues                       
    drop_table :mail_task_mar_nearly_ready_to_ship_queue_line_items              
    drop_table :mail_task_mar_nearly_ready_to_ship_queues                        
    drop_table :mail_task_mar_nikon_mount_price_adjustment_notice_queues         
    drop_table :mail_task_mar_payment_status_of_your_order_queues                
    drop_table :mail_task_mar_ready_to_ship2_queue_line_items                    
    drop_table :mail_task_mar_ready_to_ship2_queues                              
    drop_table :mail_task_mar_ready_to_ship_queue_line_items                     
    drop_table :mail_task_mar_ready_to_ship_queues                               
    drop_table :mail_task_mar_red_day_invite_queues                              
    drop_table :mail_task_mar_revised_nearly_ready_to_ship_queue_line_items      
    drop_table :mail_task_mar_revised_nearly_ready_to_ship_queues                
    drop_table :mail_task_redone_serial_number_notify_queues                     
    drop_table :mail_task_sent_logs                                              
    drop_table :mail_tasks                                                       
  end
end
