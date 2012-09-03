require "rubygems"
require 'yaml'
require "fastercsv"
require 'zip/zip'
require "open-uri"
require "fileutils"

namespace :db do
  def find_cmd(*commands)
    dirs_on_path = ENV['PATH'].split(File::PATH_SEPARATOR)
    commands += commands.map{|cmd| "#{cmd}.exe"} if RUBY_PLATFORM =~ /win32/
    commands.detect do |cmd|
      dirs_on_path.detect do |path|
        File.executable? File.join(path, cmd)
      end
    end || raise("couldn't find matching executable: #{commands.join(', ')}")
  end

  namespace :console do
    YAML::load(File.read(RAILS_ROOT + "/config/database.yml")).each do |env, config|
      desc "Connect to the '#{env}' DB using a console tool"
      task env.to_sym do
        case config["adapter"]
        when "mysql"
          system(find_cmd(*%w(mysql5 mysql)),
            '-u', config["username"],
            "-p#{config["password"]}",
            '-h', "#{config["host"]}",
            '--default-character-set', config["encoding"],
            '-D', config["database"])
        when "postgresql"
          ENV['PGHOST']     = config["host"] if config["host"]
          ENV['PGPORT']     = config["port"].to_s if config["port"]
          ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
          system(find_cmd('psql'), '-U', config["username"], config["database"])
        when "sqlite"
          system(find_cmd('sqlite'), config["database"])
        when "sqlite3"
          system(find_cmd('sqlite3'), config["database"])
        else raise "not supported for this database type"
        end
      end
    end
  end

  task :console do
    Rake::Task["db:console:" + (ENV['DB'] || RAILS_ENV || 'development')].invoke
  end

  namespace :fixtures do
    desc "Create YAML fixture from current database. Defaults to development database. Set RAILS_ENV to override."
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end

  namespace :mail do
    desc 'Migrate the mail database.'
    task :migrate => :environment do
      ActiveRecord::Migrator.migrate("db/mail_migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end
 
  namespace :mail_tasks do
    desc 'Setup tables of RED Mails Blaster'
    task :migrate => :environment do
      ActiveRecord::Migrator.migrate("db/mail_tasks_migration/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end

 
  namespace :ipdb do
    desc "Create IP Database from scratch"
    task :create do
      productcode = "db3"
      username    = "chadj@red.com"
      password    = "Z86XL25R"
      RAILS_ROOT  = File.join(File.dirname(__FILE__), '..', '..')
      zip_file    = File.join(RAILS_ROOT, 'tmp', 'ipdata.zip')
      csv_file    = File.join(RAILS_ROOT, 'tmp', 'ipdata.csv')
      sql_file    = File.join(RAILS_ROOT, 'tmp', 'ipdata.sql')
      database    = File.join(RAILS_ROOT, 'tmp', 'ipdb.sqlite3')
      target_db   = File.join(RAILS_ROOT, 'db', 'ipdb.sqlite3')

      begin
        puts "Download ip data."
        open(zip_file, "wb+") { |file| file << open("http://www.ip2location.com/download.aspx?productcode=#{productcode}&login=#{username}&password=#{password}").read }
        puts "Finish download."

        puts "Extract raw csv file."
        Zip::ZipFile.open(zip_file) do |file|
          file.extract('IP-COUNTRY-REGION-CITY.CSV', csv_file) {true}
        end
        puts "Finish extract."
      rescue
        FileUtils.rm zip_file if File.exists? zip_file
        FileUtils.rm csv_file if File.exists? csv_file
        puts "Fetch ip data failure!"
        exit
      end

      puts "Parse csv file."
      counter = [0]
      counter_sum = 100000
      addresses, countries = [], []
      i,j,k = nil
      FasterCSV.foreach(csv_file) do |row|
        counter << counter.last.next
        if counter.last == counter_sum
          puts "#{counter_sum} rows."
          counter_sum += 100000
        end

        # addresses
        addresses << "INSERT INTO \"ip2addresses\" VALUES(#{row[0]},#{row[1]},\"#{row[2]}\",\"#{row[3]}\",\"#{row[4]}\",\"#{row[5]}\");\n"

        # countries
        case
        when i == nil || j == nil || k == nil
          i,j,k = row[0],row[1],row[2]
          countries << "INSERT INTO \"ip2countries\" VALUES(#{i},#{j},\"#{k}\");\n"
        when j.next == row[0] && k == row[2]
          j = row[1]
        else
          countries << "INSERT INTO \"ip2countries\" VALUES(#{i},#{j},\"#{k}\");\n"
          i,j,k = row[0],row[1],row[2]
        end
      end
      # write last i,j,k values to countries
      countries << "INSERT INTO \"ip2countries\" VALUES(#{i},#{j},\"#{k}\");\n"
      puts "Finish parse."

      puts "Generate database"
      #ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => database)
      #ActiveRecord::Schema.define do
      #  create_table :ip2addresses, :force => true do |t|
      #    t.column :ipFROM,       :integer, :null => false, :default => 0
      #    t.column :ipTO,         :integer, :null => false, :default => 0
      #    t.column :countrySHORT, :string,  :null => false, :default => "", :limit => 2
      #    t.column :countryLONG,  :string,  :null => false, :defalut => "", :limit => 64
      #    t.column :ipREGION,     :string,  :null => false, :default => "", :limit => 128
      #    t.column :ipCITY,       :string,  :null => false, :default => "", :limit => 128
      #  end
      #  add_index :ip2addresses, :ipFROM
      #  add_index :ip2addresses, :ipTO
      #  create_table :ip2countries, :force => true do |t|
      #    t.column :ipFROM,       :integer, :null => false, :default => 0
      #    t.column :ipTO,         :integer, :null => false, :default => 0
      #    t.column :countrySHORT, :string,  :null => false, :default => "", :limit => 2
      #  end
      #  add_index :ip2countries, :ipFROM
      #  add_index :ip2countries, :ipTO
      #end

      open(sql_file, "w") do |file|
        file << <<EOF
BEGIN TRANSACTION;
CREATE TABLE ip2addresses (
"ipFROM" integer(10) DEFAULT 0 NOT NULL,
"ipTO" integer(10) DEFAULT 0 NOT NULL,
"countrySHORT" varchar(2) DEFAULT "" NOT NULL,
"countryLONG" varchar(64) DEFAULT "" NOT NULL,
"ipREGION" varchar(128) DEFAULT "" NOT NULL,
"ipCITY" varchar(128) DEFAULT "" NOT NULL
);
EOF
        file << addresses
        file << <<EOF
CREATE INDEX ipFROM_IDX_ADDR on ip2addresses(ipFROM);
CREATE INDEX ipTO_IDX_ADDR on ip2addresses(ipTO);
COMMIT;
EOF
        file << <<EOF
BEGIN TRANSACTION;
CREATE TABLE ip2countries (
"ipFROM" integer(10) DEFAULT 0 NOT NULL,
"ipTO" integer(10) DEFAULT 0 NOT NULL,
"countrySHORT" varchar(2) DEFAULT "" NOT NULL
);
EOF
        file << countries
        file << <<EOF
CREATE INDEX ipFROM_IDX on ip2countries(ipFROM);
CREATE INDEX ipTO_IDX on ip2countries(ipTO);
COMMIT;
EOF
      end

      # release object memory space
      counter,counter_sum,addresses,countries,i,j,k = nil

      FileUtils.rm database if File.exist? database
      system("sqlite3 #{database} < #{sql_file}")
      FileUtils.mv database, target_db

      # cleanup
      FileUtils.rm zip_file if File.exists? zip_file
      FileUtils.rm csv_file if File.exists? csv_file
      FileUtils.rm sql_file if File.exists? sql_file

      puts "Finish generate."
    end
  end
end
