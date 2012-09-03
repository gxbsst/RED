class MailTaskAprNearlyReadyToShipQueueLineItems < ActiveRecord::Migration
  def self.up
    create_table "mail_task_apr_nearly_ready_to_ship_queue_line_items", :force => true do |t|
      t.column "mail_task_apr_nearly_ready_to_ship_queue_id", :integer
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
  end
  def self.down
    drop_table :mail_task_apr_nearly_ready_to_ship_queue_line_items
  end
end

