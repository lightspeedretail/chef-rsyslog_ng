
default[:rsyslog][:service_name]  = "rsyslog"
default[:rsyslog][:user]          = "root"
default[:rsyslog][:group]         = "adm"

default[:rsyslog][:config_dir]    = "/etc"
default[:rsyslog][:includes_dir]  = "/etc/rsyslog.d"
default[:rsyslog][:spool_dir]     = "/var/spool/rsyslog"
default[:rsyslog][:log_dir]       = "/var/log"

default[:rsyslog][:global].tap do |global|
  global["maxMessageSize"]  = "8k"
  global["preserveFQDN"]    = "off"
  global["workDirectory"]   = node[:rsyslog][:spool_dir]
  global["net.ipprotocol"]  = "ipv4-only"
end

default[:rsyslog][:main_queue].tap do |main|
end

