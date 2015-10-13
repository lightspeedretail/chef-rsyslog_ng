
module RsyslogNg
  module TemplateHelper
    def param(name, value)
      "#{name}=\"#{value}\""
    end

    def params(hash)
      hash.map { |k,v| param(k,v) }.join(" ")
    end

    def ruleset(name, attrs, content=nil)
      unless attrs.is_a?(Hash)
        raise ArgumentError.new "attrs must be a Hash, got #{attrs}"
      end

      value = "#{name}("
      value << params(attrs)
      value << ") "
      if content
        value << "{\n"
        value << content
        value << "\n}"
      end

      value
    end
  end
end

