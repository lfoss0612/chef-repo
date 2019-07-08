# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'media_server'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'media_server::default'

# Specify a custom source for a single cookbook:
cookbook 'media_server', github: '/lfoss0612/chef-repo/tree/master/cookbooks/media_server', branch: 'master'
