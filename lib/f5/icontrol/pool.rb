require 'yaml'

module F5
  module Icontrol
    class Pool
      attr_reader :address

      def initialize(address)
        @address = address
      end

      def self.list
        response = F5::Icontrol::API.new.LocalLB.Pool.get_list

        response[:item].map { |p| F5::Icontrol::Pool.new(p) }
      end

      def members
        response = F5::Icontrol::API.new.LocalLB.Pool.get_member_v2(pool_names: { item: [address] } )

        my_members = response[:item][:item]
        my_members = [members] if my_members.is_a?(Hash)

        my_members.map { |m| F5::Icontrol::PoolMember.new(address: m[:address], port: m[:port], pool: self) }
      end
    end
  end
end
