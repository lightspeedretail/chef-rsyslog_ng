
node[:rsyslog_ng][:configs].each do |name, attrs|
  rsyslog_file name do
    action :delete if attrs[:enabled] == false
    attrs.each do |k,v| 
      send(k,v) if not v.nil? and respond_to?(k)
    end
  end
end

