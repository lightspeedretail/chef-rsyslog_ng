
resource_name :rsyslog_file

property :name,
  kind_of:  String,
  identity: true,
  name_property: true,
  coerce: proc { |value| value =~ /\.conf$/ ? value : "#{value}.conf" }

property :priority,
  kind_of:  Integer,
  identity: true,
  default:  20,
  coerce: proc { |value| value.to_i }

property :cookbook,
  kind_of:  String,
  default: "rsyslog_ng"

property :source,
  kind_of: [String,Array],
  default: lazy { |r| [
    "default/conf.d/#{r.name}.erb",
    "default/#{r.name}.erb",
    "default/conf.d/ruleset.conf.erb"
  ] }

property :variables,
  kind_of: Hash,
  default: Hash.new

property :path,
  kind_of: String,
  default: lazy { |r| r.file_path }

load_current_value do
  others = ::Dir.glob(file_path("*"))
  if others.count > 0
    other = ::File.basename(others.first)
    other_priority, other_name = other.split('-')
    name other_name
    priority other_priority if other_name
  end
end

action :create do
  converge_if_changed(:priority) do
    template current_resource.path do
      cookbook  new_resource.cookbook
      source    new_resource.source
      action :delete
    end
  end

  template new_resource.path do
    cookbook  new_resource.cookbook
    source    new_resource.source
    variables new_resource.variables
    helpers   RsyslogNg::TemplateHelper
    action    :create
  end

  notifies_delayed(:restart, syslog_service)
end

action :delete do
  template new_resource.path do
    cookbook  new_resource.cookbook
    source    new_resource.source
    action    :delete
  end

  notifies_delayed(:restart, syslog_service)
end

def includes_directory
  node[:rsyslog_ng][:includes_dir]
end

def syslog_service
  resources("service[rsyslog]")
end

def file_path(pri = nil)
  ::File.join(includes_directory, "#{pri || priority}-#{name}")
end

