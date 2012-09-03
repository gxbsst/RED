class InitializeAllTables < ActiveRecord::Migration
  def self.up

    create_table "ax_store_user_logs", :force => true do |t|
      t.column "email_address", :string
      t.column "raw_input", :text
      t.column "status", :string
      t.column "message", :text
      t.column "return_message", :text
      t.column "created_at", :datetime
      t.column "created_on", :date
      t.column "updated_at", :datetime
    end

    create_table "content_node_types", :force => true do |t|
      t.column "name", :string, :limit => 50, :default => "", :null => false
    end

    create_table "content_nodes", :force => true do |t|
      t.column "name", :string, :limit => 200, :default => "", :null => false
      t.column "title", :string, :limit => 100, :default => "", :null => false
      t.column "content", :text, :default => "", :null => false
      t.column "display_on", :datetime, :null => false
      t.column "created_on", :datetime, :null => false
      t.column "content_node_type_id", :integer, :default => 1, :null => false
    end

    add_index "content_nodes", ["name"], :name => "name"

    create_table "countries", :force => true do |t|
      t.column "name", :string, :limit => 100, :default => "", :null => false
      t.column "fedex_code", :string, :limit => 50
      t.column "ufsi_code", :string, :limit => 3
      t.column "number_of_orders", :integer, :default => 0, :null => false
    end

    add_index "countries", ["number_of_orders"], :name => "number_of_orders"

    create_table "email_announcements", :force => true do |t|
      t.column "name", :string, :default => "", :null => false
      t.column "email_address", :string, :default => "", :null => false
      t.column "industry", :string
      t.column "editor", :string
      t.column "system", :string
      t.column "comments", :text
      t.column "hd_camera", :string
      t.column "raw_camera", :string
    end

    create_table "erp_order_logs", :force => true do |t|
      t.column "erp_order_id", :integer
      t.column "uuid", :string, :limit => 40
      t.column "order_number", :string
      t.column "erp_serv", :string
      t.column "log_msg", :string
      t.column "xml", :text
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end

    create_table "images", :force => true do |t|
      t.column "path", :string, :default => "", :null => false
      t.column "description", :string
      t.column "width", :integer, :default => 0, :null => false
      t.column "height", :integer, :default => 0, :null => false
    end

    create_table "images_products", :id => false, :force => true do |t|
      t.column "image_id", :integer, :default => 0, :null => false
      t.column "product_id", :integer, :default => 0, :null => false
      t.column "sort_order", :integer
    end

    add_index "images_products", ["product_id", "image_id"], :name => "main"

    create_table "jan_line_items", :force => true do |t|
      t.column "order_id", :integer, :default => 0, :null => false
      t.column "product", :string, :default => "", :null => false
      t.column "subproduct", :string
      t.column "quantity", :integer, :default => 0, :null => false
      t.column "price", :float, :limit => 19, :default => 0.0, :null => false
      t.column "serial_no", :integer, :limit => 6
      t.column "created", :datetime
      t.column "modified", :datetime
    end

    create_table "jan_orders", :force => true do |t|
      t.column "order_number", :string, :limit => 30
      t.column "account_id", :integer, :default => 0, :null => false
      t.column "name", :string, :limit => 128
      t.column "firstname", :string, :limit => 64, :default => "", :null => false
      t.column "lastname", :string, :limit => 64, :default => "", :null => false
      t.column "email", :string, :limit => 64, :default => "", :null => false
      t.column "phone", :string, :limit => 32, :default => "", :null => false
      t.column "address", :string, :limit => 64, :default => "", :null => false
      t.column "address_two", :string, :limit => 128
      t.column "postcode", :string, :limit => 10, :default => "0", :null => false
      t.column "city", :string, :limit => 64, :default => "", :null => false
      t.column "state", :string
      t.column "country", :string, :limit => 64, :default => "", :null => false
      t.column "shipping_method", :string, :limit => 100, :default => "", :null => false
      t.column "shipping_price", :float, :limit => 19, :default => 0.0, :null => false
      t.column "payment_method", :string, :limit => 100, :default => "", :null => false
      t.column "payment_price", :float, :limit => 19, :default => 0.0, :null => false
      t.column "payment_pending", :string, :limit => 1, :default => "Y"
      t.column "contract_required", :string, :limit => 1, :default => "N"
      t.column "contract_sent", :datetime
      t.column "comments", :text
      t.column "created", :datetime
      t.column "modified", :datetime
      t.column "viaklix_trx_id", :string
    end

    create_table "news", :force => true do |t|
      t.column "title", :string, :limit => 100
      t.column "language", :string, :limit => 20
      t.column "permalink", :string, :limit => 100
      t.column "random_id", :string, :limit => 50
      t.column "remote_url", :string, :limit => 100
      t.column "beta_visible", :boolean, :default => false
      t.column "live_visible", :boolean, :default => false
      t.column "headline_or_sticky", :boolean, :default => false
      t.column "headline_position", :integer, :limit => 3, :default => 0
      t.column "sticky_position", :integer, :limit => 3, :default => 0
      t.column "description", :text
      t.column "content", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "post_timestamp", :datetime
    end

    add_index "news", ["permalink"], :name => "news_permalink_index"

    create_table "news_admin_users", :force => true do |t|
      t.column "name", :string
      t.column "hashed_password", :string
      t.column "created_at", :datetime
      t.column "status", :boolean
      t.column "level", :integer
    end

    create_table "order_account_types", :force => true do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end

    create_table "order_accounts", :force => true do |t|
      t.column "order_user_id", :integer, :default => 0, :null => false
      t.column "order_address_id", :integer, :default => 0, :null => false
      t.column "order_account_type_id", :integer, :default => 1, :null => false
      t.column "account_number", :string, :limit => 20
      t.column "expiration_month", :integer, :limit => 2
      t.column "expiration_year", :integer, :limit => 4
      t.column "routing_number", :string, :limit => 20
      t.column "bank_name", :string, :limit => 50
      t.column "cardholder_name", :string
      t.column "payment_type", :integer
      t.column "safe_cc_number", :string
      t.column "encrypted_cc_number", :text
      t.column "remote_ip", :string
      t.column "pfp_amount", :float
      t.column "pfp_pnref", :string
      t.column "pfp_authcode", :string
      t.column "avs_result", :string
      t.column "avs_streetmatch", :boolean
      t.column "avs_zipmatch", :boolean
      t.column "erp_recid", :string
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "remote_location", :string
    end

    add_index "order_accounts", ["order_user_id", "order_address_id", "order_account_type_id"], :name => "ids"

    create_table "order_addresses", :force => true do |t|
      t.column "order_user_id", :integer, :default => 0, :null => false
      t.column "is_shipping", :boolean, :default => false, :null => false
      t.column "telephone", :string, :limit => 20
      t.column "address", :string, :default => "", :null => false
      t.column "city", :string, :limit => 50
      t.column "state", :string, :limit => 10
      t.column "zip", :string, :limit => 10
      t.column "country_id", :integer, :default => 0, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "shipping_label", :text
      t.column "company", :string
      t.column "address_two", :string
      t.column "first_name", :string
      t.column "last_name", :string
    end

    create_table "order_line_items", :force => true do |t|
      t.column "product_id", :integer, :default => 0, :null => false
      t.column "order_id", :integer, :default => 0, :null => false
      t.column "quantity", :integer, :default => 0, :null => false
      t.column "unit_price", :float, :default => 0.0, :null => false
      t.column "unit_deposit", :float, :default => 0.0, :null => false
    end

    create_table "order_shipping_types", :force => true do |t|
      t.column "name", :string, :limit => 100, :default => "", :null => false
      t.column "code", :string, :limit => 50
      t.column "company", :string, :limit => 20
      t.column "is_domestic", :boolean, :default => false, :null => false
      t.column "service_type", :string, :limit => 50
      t.column "transaction_type", :string, :limit => 50
      t.column "shipping_multiplier", :float, :default => 0.0, :null => false
      t.column "flat_fee", :float, :default => 0.0, :null => false
    end

    create_table "order_status_codes", :force => true do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end

    add_index "order_status_codes", ["name"], :name => "name"

    create_table "order_transactions", :force => true do |t|
      t.column "created_on", :datetime
      t.column "order_id", :integer
      t.column "transaction_id", :string
      t.column "description", :string
    end

    create_table "order_users", :force => true do |t|
      t.column "email_address", :string, :limit => 50, :default => "", :null => false
      t.column "password", :string, :limit => 20
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "name", :string
      t.column "company", :string
      t.column "store_user_id", :integer
    end

    add_index "order_users", ["email_address"], :name => "email"

    create_table "order_users_emails", :force => true do |t|
      t.column "order_users_id", :integer, :default => 0, :null => false
      t.column "real_name", :string, :limit => 50, :default => "", :null => false
      t.column "email", :string, :limit => 50, :default => "", :null => false
    end

    create_table "orders", :force => true do |t|
      t.column "order_number", :integer, :default => 0, :null => false
      t.column "created_on", :datetime
      t.column "shipped_on", :datetime
      t.column "order_user_id", :integer
      t.column "order_status_code_id", :integer, :default => 1, :null => false
      t.column "notes", :text
      t.column "referer", :string
      t.column "order_shipping_type_id", :integer, :default => 1, :null => false
      t.column "product_cost", :float, :default => 0.0
      t.column "shipping_cost", :float, :default => 0.0
      t.column "tax", :float
      t.column "auth_transaction_id", :integer
      t.column "sent_email_receipt", :boolean
      t.column "erp_order_number", :string
      t.column "erp_status_msg", :string
      t.column "erp_account_uuid", :string, :limit => 40
      t.column "erp_order_uuid", :string, :limit => 40
      t.column "erp_cc_uuid", :string, :limit => 40
      t.column "erp_complete", :boolean, :default => false
      t.column "pre_ax", :boolean, :default => false
    end

    add_index "orders", ["order_number"], :name => "order_number"
    add_index "orders", ["order_user_id"], :name => "order_user_id"
    add_index "orders", ["order_status_code_id"], :name => "status"

    create_table "pfp_transaction_logs", :force => true do |t|
      t.column "pfp_serv", :string
      t.column "store_user_id", :integer
      t.column "card_name", :string
      t.column "email_address", :string
      t.column "order_number", :integer
      t.column "uuid", :string
      t.column "req_xml", :text
      t.column "res_xml", :text
      t.column "status", :string
      t.column "res_code", :string
      t.column "res_message", :string
      t.column "created_on", :date
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "remote_ip", :string
      t.column "remote_location", :string
    end

    create_table "pfp_transactions", :force => true do |t|
      t.column "pfp_serv", :string
      t.column "uuid", :string, :limit => 40
      t.column "message", :string, :limit => 20
      t.column "xml", :text
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end

    create_table "products", :force => true do |t|
      t.column "code", :string, :limit => 20, :default => "", :null => false
      t.column "name", :string, :limit => 100, :default => "", :null => false
      t.column "description", :text, :default => "", :null => false
      t.column "price", :float, :default => 0.0, :null => false
      t.column "date_available", :datetime, :null => false
      t.column "quantity", :integer, :default => 0, :null => false
      t.column "size_width", :float, :default => 0.0, :null => false
      t.column "size_height", :float, :default => 0.0, :null => false
      t.column "size_depth", :float, :default => 0.0, :null => false
      t.column "weight", :float, :default => 0.0, :null => false
      t.column "erp_product_item", :string
      t.column "deposit", :float, :default => 0.0, :null => false
    end

    create_table "products_tags", :id => false, :force => true do |t|
      t.column "product_id", :integer, :default => 0, :null => false
      t.column "tag_id", :integer, :default => 0, :null => false
    end

    create_table "questions", :force => true do |t|
      t.column "short_question", :string
      t.column "long_question", :text, :default => "", :null => false
      t.column "answer", :text
      t.column "rank", :integer
      t.column "featured", :boolean, :default => false, :null => false
      t.column "times_viewed", :integer, :default => 0, :null => false
      t.column "created_on", :datetime, :null => false
      t.column "answered_on", :datetime
      t.column "email_address", :string, :limit => 50
    end

    create_table "reservation_items", :force => true do |t|
      t.column "reservation_id", :integer
      t.column "serial_number", :string
      t.column "description", :string
      t.column "price", :float
    end

    create_table "reservations", :force => true do |t|
      t.column "email_address", :string
      t.column "secret_code", :string
      t.column "order_id", :integer
      t.column "total", :float
      t.column "name", :string
      t.column "payment_method", :string
      t.column "source_name", :string
      t.column "source_id", :string
      t.column "paid_on", :datetime
    end

    create_table "rights", :force => true do |t|
      t.column "name", :string
      t.column "controller", :string
      t.column "actions", :string
    end

    create_table "rights_roles", :id => false, :force => true do |t|
      t.column "right_id", :integer
      t.column "role_id", :integer
    end

    create_table "roles", :force => true do |t|
      t.column "name", :string
      t.column "description", :text
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end

    create_table "sessions", :force => true do |t|
      t.column "sessid", :string, :default => "", :null => false
      t.column "data", :text, :default => "", :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
    end

    add_index "sessions", ["sessid"], :name => "session_index"

    create_table "store_users", :force => true do |t|
      t.column "name", :string
      t.column "company", :string
      t.column "email_address", :string
      t.column "password", :string
      t.column "ship_to_address_id", :integer
      t.column "bill_to_address_id", :integer
      t.column "order_account_id", :integer
      t.column "security_token", :string, :limit => 40
      t.column "erp_account_number", :string
      t.column "creation_email", :boolean, :default => false, :null => false
    end

    create_table "tags", :force => true do |t|
      t.column "name", :string, :limit => 100, :default => "", :null => false
      t.column "sort_order", :integer
    end

    create_table "transaction_order_link", :force => true do |t|
      t.column "transaction_id", :integer
      t.column "order_id", :integer
    end

    create_table "users", :force => true do |t|
      t.column "login", :string, :limit => 50, :default => "", :null => false
      t.column "password", :string, :limit => 40
    end

    add_index "users", ["login", "password"], :name => "login"

    create_table "viaklix_batches", :force => true do |t|
      t.column "batch_number", :string, :limit => 10
      t.column "download_date", :datetime
      t.column "settlement_number", :string, :limit => 50
      t.column "total", :float
    end

    add_index "viaklix_batches", ["settlement_number"], :name => "settlement_number", :unique => true

    create_table "viaklix_transactions", :force => true do |t|
      t.column "transactionid", :text
      t.column "transactiontype", :text
      t.column "transactiondatetime", :text
      t.column "approvalcode", :text
      t.column "ssl_invoice_number", :text
      t.column "ssl_amount", :float, :limit => 8, :default => 0.0, :null => false
      t.column "sales_tax", :text
      t.column "cvv2_indicator", :text
      t.column "cvv2response", :text
      t.column "customer_code", :text
      t.column "card_number", :text
      t.column "exp_date", :text
      t.column "auth_response_code", :text
      t.column "auth_message", :text
      t.column "auth_source", :text
      t.column "auth_avs_response", :text
      t.column "status", :text
      t.column "ssl_amount2", :text
      t.column "ssl_avs_address", :text
      t.column "ssl_avs_zip", :text
      t.column "ssl_card_number", :text
      t.column "ssl_customer_code", :text
      t.column "ssl_description", :text
      t.column "ssl_exp_date", :text
      t.column "ssl_salestax", :text
      t.column "settlement_number", :string, :limit => 50, :default => "", :null => false
      t.column "ssl_city", :text
      t.column "ssl_email", :text
      t.column "ssl_first_name", :text
      t.column "ssl_last_name", :text
      t.column "ssl_state", :string, :limit => 50
    end
  end

  def self.down
    drop_table :ax_store_user_logs
    drop_table :content_node_types
    drop_table :content_nodes
    drop_table :countries
    drop_table :email_announcements
    drop_table :erp_order_logs
    drop_table :images
    drop_table :images_products
    drop_table :jan_line_items
    drop_table :jan_orders
    drop_table :news
    drop_table :news_admin_users
    drop_table :order_account_types
    drop_table :order_accounts
    drop_table :order_addresses
    drop_table :order_line_items
    drop_table :order_shipping_types
    drop_table :order_status_codes
    drop_table :order_transactions
    drop_table :order_users
    drop_table :order_users_emails
    drop_table :orders
    drop_table :pfp_transaction_logs
    drop_table :pfp_transactions
    drop_table :products
    drop_table :products_tags
    drop_table :questions
    drop_table :reservation_items
    drop_table :reservations
    drop_table :rights
    drop_table :rights_roles
    drop_table :roles
    drop_table :roles_users
    drop_table :sessions
    drop_table :store_users
    drop_table :tags
    drop_table :transaction_order_link
    drop_table :users
    drop_table :viaklix_batches
    drop_table :viaklix_transactions
  end

end
