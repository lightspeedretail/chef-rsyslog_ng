
class Chef
  class Resource
    class RsyslogFile < LWRPBase
      actions :create, :delete
      default_action :create

      provides :rsyslog_file
      resource_name :rsyslog_file

      attribute :filename,  kind_of: String,
                              name_attribute: true
      attribute :priority,  kind_of: [String,Integer],
                              default: "20"
      attribute :cookbook,  kind_of: String,
                              default: "rsyslog_ng"
      attribute :source,    kind_of: String
      attribute :variables, kind_of: Hash,
                              default: {}

      def initialize(*args)
        super
        notifies :restart, "service[#{node[:rsyslog][:service_name]}]"
      end

      def path
        path = ::File.join(
          node[:rsyslog][:includes_dir],
          "#{priority}-#{filename}"
        )
        path = "#{path}.conf" unless filename =~ /\.conf$/
        path
      end
    end
  end

  class Provider
    class RsyslogFile < LWRPBase
      provides :rsyslog_file

      use_inline_resources

      def whyrun_supported?
        true
      end

      action :create do
        template_resource.action :create
      end

      action :delete do
        template_resource.action :delete
      end

      def template_resource
        new_resource = @new_resource
        @template_resource ||= begin
          template new_resource.path do
            cookbook  new_resource.cookbook
            source    new_resource.source
            variables new_resource.variables
            helpers   RsyslogNg::TemplateHelper
          end
        end
      end
    end
  end
end

