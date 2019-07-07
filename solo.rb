current_dir     = File.expand_path(File.dirname(__FILE__))
file_cache_path "#{current_dir}"
cookbook_path   "#{current_path}/cookbooks"
role_path       "#{current_path}/roles"
data_bag_path   "#{current_path}/data_bags"
