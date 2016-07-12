require "f5/icontrol/version"
require "f5/icontrol/api"
require "f5/icontrol/pool"
require "f5/icontrol/pool_member"
require "openssl"
require "savon"

module F5
  module Icontrol
    class << self
      attr_writer :configuration
      attr_writer :client
    end

    def self.configuration
      @configuration || Configuration.new
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield configuration
    end

    class Configuration
      attr_accessor :host, :username, :password
      attr_writer :config_file

      def initialize
        @host = nil
        @username = nil
        @password = nil
        @config_file = nil
      end

      def config_file
        @config_file || '.f5.yml'
      end
    end
  end
end
