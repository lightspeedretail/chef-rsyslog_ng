
# Short-hand to configure the remote host to log to
default[:rsyslog_ng][:remote_host] = nil

# Rsyslog configurations that drive the resources
# - In some instances we will be redeclaring configuration files that would
# usually be deployed by the package so as to ensure that we own them and that
# they are valid in rsyslog8
default[:rsyslog_ng][:configs].tap do |configs|
  configs[:imuxsock].tap do |conf|
    conf[:priority]   = 10
    conf[:variables]  = { 
      name: "input",
      attrs: { type: "imuxsock", socket: "/dev/log" }
    }
    conf[:enabled]  = true
  end

  configs[:json].tap do |conf|
    conf[:priority] = 15
    conf[:enabled]  = true
  end

  configs[:ufw].tap do |conf|
    conf[:priority] = 20
    conf[:enabled]  = true
  end

  configs[:cloudinit].tap do |conf|
    conf[:priority] = 21
    conf[:enabled]  = true
  end

  configs[:remote].tap do |conf|
    conf[:priority] = 49
    conf[:enabled] = true
    conf[:variables] = {
      name: "action",
      attrs:{ type: "omrelp", target: nil, port: "2514", template: "json", 
              "queue.maxdiskspace" => "1G", "queue.maxfilesize" => "10M",
              "queue.type" => "LinkedList", "queue.saveonshutdown" => "on",
              "queue.filename" => "remote", "action.resumeRetryCount" => -1
            }
    }
  end

  configs[:default].tap do |conf|
    conf[:priority] = 50
    conf[:enabled] = false
  end

  configs[:facility_logs].tap do |conf|
    _logdir = node[:rsyslog_ng][:log_dir]

    conf[:filename]   = "default"
    conf[:priority]   = 80
    conf[:enabled]  = true
    conf[:variables]  = { 
      facilities: {
        "auth.*"        => "#{_logdir}/auth.log",
        "authpriv.*"    => "#{_logdir}/auth.log",
        "*.*"           => "-#{_logdir}/syslog",
        "auth.none"     => "-#{_logdir}/syslog",
        "authpriv.none" => "-#{_logdir}/syslog",
        "daemon.*"      => "-#{_logdir}/daemon.log",
        "kern.*"        => "-#{_logdir}/kern.log",
        "user.*"        => "-#{_logdir}/user.log",
        "mail.*"        => "-#{_logdir}/mail.log",
        "news.*"        => "-#{_logdir}/news.log",
        "auth,authpriv.none;cron,daemon.none;mail,news.none" => "-#{_logdir}/messages"
        }
    }
  end
end

