
include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::configure"
include_recipe "#{cookbook_name}::service"

