module F5
  module Icontrol
    class Pool::Member::Status
      AVAILABLE_STATUS = "AVAILABILITY_STATUS_GREEN"

      def initialize(client:, pool:, member:)
        @client = client
        @pool = pool
        @member = member
      end

      def available?
        availability_status == AVAILABLE_STATUS
      end

      private

      attr_reader :client, :pool, :member

      def availability_status
        get_status.dig(:item, :item, :availability_status)
      end

      def get_status
        client.LocalLB.Pool.get_member_object_status(
          pool_names: {
            item: [pool.address],
          },
          members: {
            item: [[member.to_hash]]
          }
        )
      end
    end
  end
end

