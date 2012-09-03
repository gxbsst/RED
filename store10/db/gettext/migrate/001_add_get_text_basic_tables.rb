class AddGetTextBasicTables < ActiveRecord::Migration
  def self.up
    create_table :entities, :options => 'ENGINE=MyISAM' do |t|
      t.column "name", :string, :null => false
      t.column "text", :text
      t.column "deleted", :boolean, :null => false, :default => false
      t.column "description", :text
      
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
    
    create_table :languages, :options => 'ENGINE=MyISAM' do |t|
      t.column "name", :string, :null => false
      t.column "display_name", :string, :null => false, :default => ""
      t.column "description", :text
    end
    
    create_table :revisions, :options => 'ENGINE=MyISAM' do |t|
      t.column "entity_id", :integer, :null => false
      t.column "language_id", :string, :limit => 5, :null => false
      t.column "text", :text
      t.column "revision", :integer, :null => false, :default => 1
      
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
    
    add_index :entities, "name"
    
    add_index :languages, "name"
    
    add_index :revisions, "entity_id"
    add_index :revisions, "language_id"
    
    # Initialize supported languages
    $I18N.each do |key, value|
      GetText::Db::Language.create(:name => key, :display_name => value)
    end
  end
  
  def self.down
    drop_table :entities
    drop_table :languages
    drop_table :revisions
  end
end