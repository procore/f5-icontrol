require "f5/icontrol/api"
require "f5/icontrol/pool"
require "f5/icontrol/pool/member"
require "f5/icontrol/pool/member/statistics"
require "f5/icontrol/version"
require "openssl"
require "savon"

module F5
  module Icontrol
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        self.configuration ||= Configuration.new
        yield configuration
        configuration.load_config_file
      end
    end

    class Configuration
      attr_accessor :host, :username, :password, :config_file

      def initialize
        @config_file = Dir.home.join(".f5.yml")
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
    end
  end
end
