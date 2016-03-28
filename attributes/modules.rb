
default[:rsyslog_ng][:modules][:imklog].tap do |config|
  config["load"]   = "imklog"
end

default[:rsyslog_ng][:modules][:imuxsock].tap do |config|
  config["load"] = "imuxsock"
  config["SysSock.FlowControl"]         = "on"
  config["SysSock.RateLimit.Interval"]  = "2"
  config["SysSock.RateLimit.Burst"]     = "500"
end

default[:rsyslog_ng][:modules][:omrelp].tap do |config|
  config["load"]            = "omrelp"
end

default[:rsyslog_ng][:modules][:omfile].tap do |config|
  config["load"]            = "builtin:omfile"
  config["template"]        = "RSYSLOG_TraditionalFileFormat"
  config["dirOwner"]        = "root"
  config["dirGroup"]        = "adm"
  config["dirCreateMode"]   = "0755"
  config["fileOwner"]       = "root"
  config["fileGroup"]       = "adm"
  config["fileCreateMode"]  = "0640"
end

