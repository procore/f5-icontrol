require "yaml"

module F5
  module Icontrol
    class Pool::Member
      attr_reader :address, :client, :port, :pool

      def initialize(address:, client:, port:, pool:)
        @address = address
        @client = client
        @pool = pool
        @port = port
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

      def stats
        Statistics.new(client: client, pool: pool, member: self)
      end

      def status
        Status.new(client: client, pool: pool, member: self)
      end

      def to_hash
        {
          address: address,
          port: port,
        }
      end
    end
  end
end
