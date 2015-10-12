
apt_repository "rsyslog" do
  uri           "ppa:adiscon/v8-stable"
  components    ["main"]
  distribution  node[:lsb][:codename]
end

package "rsyslog" do
  version node[:rsyslog_ng][:version] if node[:rsyslog_ng][:version]
  options [
    "-o Dpkg::Options::='--force-confold'",
    "-o Dpkg::Options::='--force-overwrite'"
  ].join(" ")
  action [:install, :upgrade]
end

if %w(imrelp omrelp).any? { |v|  node[:rsyslog_ng][:modules].keys.include?(v) }
  package "rsyslog-relp" 
end

%w(includes_dir spool_dir).each do |dirname|
  directory dirname do
    owner node[:rsyslog_ng][:user]
    group node[:rsyslog_ng][:group]
    mode  '0750'
  end
end

template ::File.join(node[:rsyslog_ng][:config_dir], "rsyslog.conf") do
  helpers   RsyslogNg::TemplateHelper
  variables global: node[:rsyslog_ng][:global],
            main_queue: node[:rsyslog_ng][:main_queue],
            modules: node[:rsyslog_ng][:modules]
  notifies :restart, "service[#{node[:rsyslog_ng][:service_name]}]"
end

