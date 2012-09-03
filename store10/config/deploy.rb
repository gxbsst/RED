set :application, "boba"
set :repository,  "svn+ssh://source.red.com/repos/boba/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :deploy_to, "/home/daniel/boba"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

ssh_options[:port] = 22222

role :app, "daniel.red.com"
role :web, "daniel.red.com"
role :db,  "daniel.red.com", :primary => true

#======================================
# Custom task
#======================================
desc 'copy essential files to current project'
task :after_update_code, :roles => :app do
  run "cp #{shared_path}/config/* #{release_path}/config/"
  run "rm -rf #{release_path}/po"
  run "cp -r #{shared_path}/i18n/* #{release_path}/"
end

desc 'web server restart'
task :web_server_restart, :roles => :web do
  run "sudo /etc/init.d/nginx restart"
end

desc 'mongrel cluster restart'
task :mongrel_cluster_restart, :roles => :app do
  run "mongrel_cluster_ctl stop"
  run "mongrel_cluster_ctl start"
end
