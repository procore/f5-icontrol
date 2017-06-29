module F5
  module Icontrol
    class API
      attr_accessor :api_path
      attr_reader :params, :client_cache

      def initialize(api_path = nil, **params)
        @params = params.dup
        @username = params[:username]
        @password = params[:password]
        @hostname = params[:host] || params[:hostname]
        @client_cache = {}
        @api_path = api_path
      end

      def method_missing(method, args = nil, &block)
        if terminal_node? && supported_method?(method)
          response_key = "#{method.to_s}_response".to_sym

          response = client.call(method) do
            if args
              message args
            end
          end

          response.to_hash[response_key][:return]

        elsif supported_path?(append_path(method))
          self.class.new(append_path(method), params)
        else
          raise NameError, "#{method} is not supported by #{api_path}"
        end
      end

      def client
        api_namespace = api_path.to_s.gsub(/\./, '/')
        endpoint = '/iControl/iControlPortal.cgi'
        client_cache[api_path] ||= Savon.client(
          wsdl: "#{wsdl_path}#{api_path}.wsdl",
          endpoint: "https://#{hostname}#{endpoint}",
          ssl_verify_mode: :none,
            basic_auth: [username, password],
            namespace: "urn:iControl:#{api_namespace}",
          convert_request_keys_to: :none
        )
      end

      private

      def hostname
        @hostname || F5::Icontrol.configuration.host
      end

      def username
        @username || F5::Icontrol.configuration.username
      end

      def password
        @password || F5::Icontrol.configuration.password
      end

      def terminal_node?
        ::File.exists?("#{wsdl_path}/#{api_path}.wsdl")
      end

      def supported_method?(method)
        client.operations.include?(method)
      end

      def supported_path?(path)
        !Dir.glob("#{wsdl_path}/#{path}.*wsdl").empty?
      end

      def append_path(item)
        if api_path
          "#{api_path}.#{item}"
        else
          item.to_s
        end
      end

      def wsdl_path
        File.dirname(__FILE__).gsub(/(f5-icontrol[^\/]*\/lib)\/.*/, "\\1/wsdl/")
      end
    end
  end
end
