require "yaml"

module F5
  module Icontrol
    class Pool
      attr_reader :address, :client

      def initialize(address:, client: F5::Icontrol::API.new)
        @address = address
        @client = client
      end

      def self.list(client: F5::Icontrol::API.new)
        response = client.LocalLB.Pool.get_list

        response.fetch(:item).map do |address|
          F5::Icontrol::Pool.new(address: address, client: client)
        end
      end

      def members
        response = client.LocalLB.Pool.get_member_v2(
          pool_names: { item: [address] },
        )

        my_members = Array(response.fetch(:item).fetch(:item))

        my_members.map do |member|
          F5::Icontrol::Pool::Member.new(
            address: member.fetch(:address),
            port: member.fetch(:port),
            pool: self,
            client: client,
          )
        end
      end
    end
  end
end
