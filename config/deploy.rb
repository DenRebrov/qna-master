# config valid for current version and patch releases of Capistrano
lock "~> 3.12.0"

set :application, "qna"
set :repo_url, "git@github.com:DenRebrov/qna-master.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

after 'deploy:publishing', 'unicorn:restart'
