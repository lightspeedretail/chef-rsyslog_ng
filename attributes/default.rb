
# Standard service level configuration
#
default[:rsyslog_ng][:service_name]  = "rsyslog"
default[:rsyslog_ng][:user]          = "root"
default[:rsyslog_ng][:group]         = "adm"

default[:rsyslog_ng][:config_dir]    = "/etc"
default[:rsyslog_ng][:includes_dir]  = "/etc/rsyslog.d"
default[:rsyslog_ng][:spool_dir]     = "/var/spool/rsyslog"
default[:rsyslog_ng][:log_dir]       = "/var/log"

default[:rsyslog_ng][:global].tap do |global|
  global["maxMessageSize"]  = "8k"
  global["preserveFQDN"]    = "off"
  global["workDirectory"]   = node[:rsyslog_ng][:spool_dir]
  global["net.ipprotocol"]  = "ipv4-only"
end

default[:rsyslog_ng][:main_queue].tap do |main|
end

