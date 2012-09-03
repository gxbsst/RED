class AddTaskTables < ActiveRecord::Migration
  def self.up
    with_options :options => "ENGINE=MyISAM" do |engine|
      engine.create_table "tasks" do |t|
        t.column "name", :string, :limit => 128, :null => false
        t.column "description", :text
        t.column "entity_id", :integer, :null => false
      
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end
      
      engine.create_table "completions" do |t|
        t.column "task_id", :integer, :null => false
        t.column "language_id", :integer, :null => false
        t.column "completed", :boolean, :null => false, :default => false
        t.column "updated_at", :datetime
      end
    end
    
    add_index :tasks, "entity_id"
    add_index :tasks, "created_at"
    
    add_index :completions, "task_id"
    add_index :completions, "language_id"
  end
  
  def self.down
    drop_table :tasks
    drop_table :completions
  end
end