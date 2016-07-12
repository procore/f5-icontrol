require "f5/icontrol/version"
require "f5/icontrol/api"
require "f5/icontrol/pool"
require "f5/icontrol/pool_member"
require "openssl"
require "savon"

module F5
  module Icontrol
    class << self
      attr_accessor :configuration
      attr_writer :client
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield configuration
    end

    class Configuration
      attr_accessor :host, :username, :password

      def initialize
        @host = "set_me_in_configure_block"
        @username = ""
        @password = ""
      end
    end
  end
end
