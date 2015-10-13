
apt_repository "rsyslog" do
  uri           "ppa:adiscon/v8-stable"
  components    ["main"]
  distribution  node[:lsb][:codename]
end

package "rsyslog" do
  version node[:rsyslog][:version] if node[:rsyslog][:version]
  options [
    "-o Dpkg::Options::='--force-confold'",
    "-o Dpkg::Options::='--force-overwrite'"
  ].join(" ")
  action [:install, :upgrade]
end

if %w(imrelp omrelp).any? { |v|  node[:rsyslog][:modules].keys.include?(v) }
  package "rsyslog-relp" 
end

%w(includes_dir spool_dir).each do |dirname|
  directory dirname do
    owner node[:rsyslog][:user]
    group node[:rsyslog][:group]
    mode  '0750'
  end
end

template ::File.join(node[:rsyslog][:config_dir], "rsyslog.conf") do
  helpers   RsyslogNg::TemplateHelper
  variables global: node[:rsyslog][:global],
            main_queue: node[:rsyslog][:main_queue],
            modules: node[:rsyslog][:modules]
  notifies :restart, "service[#{node[:rsyslog][:service_name]}]"
end

