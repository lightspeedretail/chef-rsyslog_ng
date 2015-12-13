
if remote = node[:rsyslog_ng][:remote_host]
  node.set[:rsyslog_ng][:configs][:remote][:variables][:attrs][:target] = remote
end

node[:rsyslog_ng][:configs].each do |name, attrs|
  rsyslog_file name do
    action :delete if attrs[:enabled] == false
    attrs.each do |k,v| 
      send(k,v) if not v.nil? and respond_to?(k)
    end
  end
end

