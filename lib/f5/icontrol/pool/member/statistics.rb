module F5
  module Icontrol
    class Pool::Member::Statistics
      def initialize(client:, pool:, member:)
        @client = client
        @pool = pool
        @member = member
      end

      def connections
        values = hash.fetch("STATISTIC_SERVER_SIDE_CURRENT_CONNECTIONS")
        values.fetch(:high).to_i * (2 << 32) + values.fetch(:low).to_i
      end

      private

      attr_reader :client, :pool, :member

      def hash
        @hash ||= build_hash
      end

      def build_hash
        raw = client.LocalLB.Pool.get_member_statistics(
          pool_names: { item: [pool.address] },
          members: { item: [[member.to_hash]] },
        )

        stats_array = raw
          .fetch(:item)
          .fetch(:statistics)
          .fetch(:item)
          .fetch(:statistics)
          .fetch(:item)

        stats_array.each_with_object(Hash.new) do |stat, hash|
          hash[stat.fetch(:type)] = stat.fetch(:value)
        end
      end
    end
  end
end
