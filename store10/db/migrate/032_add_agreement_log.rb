class AddAgreementLog < ActiveRecord::Migration
  def self.up
    add_column :downloads, :restrict, :boolean, :default => true

    create_table 'agreements' do |t|
      t.column 'name', :string
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end

    create_table 'agreement_versions' do |t|
      t.column 'agreement_id', :integer, :null => false
      t.column 'content', :text, :null => false
      t.column 'version', :integer, :null => false, :default => 0
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end

    create_table 'agreement_logs' do |t|
      t.column 'agreement_version_id', :integer, :null => false
      t.column 'store_user_id', :integer
      t.column 'download_id', :integer
      t.column 'order_id', :integer
      t.column 'remote_ip', :string
      t.column 'created_at', :datetime
    end

    add_column :download_categories, :agreement_id, :integer
    
    Right.create(:name => 'Agreement', :controller => 'agreement', :actions => '*')
    Role.find(1).rights << Right.find_by_controller('agreement')
    
    # Load initial terms & conditions.
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    %w(agreements agreement_versions).each do |table|
      Fixtures.create_fixtures(File.dirname(__FILE__)+"/dev_data", table)
    end
  end

  def self.down
    remove_column :downloads, :restrict

    drop_table :agreements
    drop_table :agreement_versions
    drop_table :agreement_logs

    remove_column :download_categories, :agreement_id

    Role.find(1).rights.delete(Right.find_by_controller('agreement'))
    Right.find_by_controller('agreement').destroy
  end
end
