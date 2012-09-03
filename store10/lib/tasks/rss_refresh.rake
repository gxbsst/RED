namespace :rss do
  desc 'refresh all rss cache.'
  task :refresh => :environment do
    begin
      Rake::Task["rss:refresh:reduser"].invoke
      Rake::Task["rss:refresh:recon"].invoke
    rescue
      msg = "Refresh rss cache from REDUSER.net failed! #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      `echo "#{msg}"|mail -s "#{msg}" sysadmin@raw.red.com`
    end
  end
  
  namespace :refresh do
    desc 'refresh reduser rss cache.'
    task :reduser => :environment do
      file = open('http://www.reduser.net/forum/external.php?type=RSS2&forumids=1,2').read
      File.open(File.join(RAILS_ROOT, 'tmp', 'reduser.rss'), "w") do |rss|
        rss << file
      end
    end

    desc 'refresh recon rss cache.'
    task :recon => :environment do
      file = open('http://www.reduser.net/forum/external.php?type=RSS2&forumids=29').read
      File.open(File.join(RAILS_ROOT, 'tmp', 'recon.rss'), "w") do |rss|
        rss << file
      end
    end

  end
end
