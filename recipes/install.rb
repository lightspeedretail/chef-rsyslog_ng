
# On Ubuntu, rsyslog8 requires a PPA to be installed
apt_repository "rsyslog" do
  node['rsyslog_ng']['apt_repository'].each do |k,v|
    send(k, v)
  end
end

# Install/Upgrade rsyslog and ensure that we are not prevented by config files
package "rsyslog" do
  version node[:rsyslog_ng][:version] if node[:rsyslog_ng][:version]
  options [
    "-o Dpkg::Options::='--force-confold'",
    "-o Dpkg::Options::='--force-overwrite'"
  ].join(" ")
  action [:install]
end

# Optionally install the required relp package
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

# Deploy hte main configuration file
template ::File.join(node[:rsyslog_ng][:config_dir], "rsyslog.conf") do
  helpers   RsyslogNg::TemplateHelper
  variables global: node[:rsyslog_ng][:global],
            main_queue: node[:rsyslog_ng][:main_queue],
            modules: node[:rsyslog_ng][:modules]
  notifies :restart, "service[#{node[:rsyslog_ng][:service_name]}]"
end

