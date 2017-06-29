module F5
  module Icontrol
    module Configuration
      attr_accessor :host, :username, :password
      attr_writer :config_file

      def configure
        yield self
        load_config_file
      end

      def load_config_file
        if File.exist?(config_file)
          yaml = YAML.load_file(config_file).fetch("default", {})

          self.host ||= yaml["host"]
          self.username ||= yaml["username"]
          self.password ||= yaml["password"]
        end
      end

      def config_file
        File.expand_path(@config_file)
      end

      def self.extended(base)
        base.config_file = "~/.f5.yml"
      end
    end
  end
end
