class CreateTableNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :title,:string,:null => true,:limit => 100
      t.column :language,:string, :limit => 20
      t.column :permalink,:string,:null => true,:limit => 100
      t.column :random_id, :string, :null => true,:limit => 50
      t.column :remote_url,:string, :null => true, :limit => 100
      t.column :beta_visible,:boolean,:default => 1
      t.column :live_visible, :boolean,:default => 1
      t.column :headline_or_sticky, :boolean,:default => 0
      t.column :headline_position, :integer,:limit => 3
      t.column :sticky_position,:integer,:limit => 3
      t.column :description,:text
      t.column :content,:text
      t.column :created_at, :datetime 
      t.column :updated_at,:datetime
      t.column :post_timestamp,:datetime
    end       
    add_index :news, :permalink
  end 
    
  def self.down
    drop_table :news
  end
end 
