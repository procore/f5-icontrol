require 'yaml'

module F5
  module Icontrol
    class PoolMember
      attr_reader :address, :port, :pool

      def initialize(address:, port:, pool:)
        @address = address
        @port = port
        @pool = pool
      end

      def enable
        client.LocalLB.Pool.set_member_session_enabled_state(
          pool_names: { item: [pool.address] },
          members: { item: [[to_hash]] },
          session_states: {  item: [["STATE_ENABLED"]] }
        )

        client.LocalLB.Pool.set_member_monitor_state(
          pool_names: { item: [pool.address] },
          members: { item: [[to_hash]] },
          monitor_states: {  item: [["STATE_ENABLED"]] }
        )
      end

      def disable
        client.LocalLB.Pool.set_member_session_enabled_state(
          pool_names: { item: [pool.address] },
          members: { item: [[to_hash]] },
          session_states: {  item: [["STATE_DISABLED"]] }
        )

        client.LocalLB.Pool.set_member_monitor_state(
          pool_names: { item: [pool.address] },
          members: { item: [[to_hash]] },
          monitor_states: {  item: [["STATE_DISABLED"]] }
        )
      end

      private

      def to_hash
        {
          address: address,
          port: port,
        }
      end

      def client
        F5::Icontrol::API.new
      end
    end
  end
end
