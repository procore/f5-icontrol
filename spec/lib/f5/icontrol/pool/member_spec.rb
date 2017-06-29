require "spec_helper"
require "f5/icontrol/pool"
require "f5/icontrol/pool/member"

RSpec.describe F5::Icontrol::Pool::Member do
  before do
    allow_any_instance_of(F5::Icontrol::API).to receive(:set_member_session_enabled_state)
    allow_any_instance_of(F5::Icontrol::API).to receive(:set_member_monitor_state)

    F5::Icontrol.configure do |f5|
      f5.host = "test.host"
      f5.username = "username"
      f5.password = "password"
    end

    stub_request(:any, /test.host/)
  end

  let(:pool) { F5::Icontrol::Pool.new(address: "pool") }

  describe "#enable" do
    it "enables the pool member in its parent pool" do
      address = "address"
      port = "port"

      pool_client = double(
        set_member_session_enabled_state: {
          pool_names: { item: [pool.address] },
          members: { item: [[{ address: address, port: port }]] },
          session_states: { item: [["STATE_ENABLED"]] },
        },
        set_member_monitor_state: {
          pool_names: { item: [pool.address] },
          members: { item: [[{ address: address, port: port }]] },
          monitor_states: { item: [["STATE_ENABLED"]] },
        },
      )
      lb_client = double(Pool: pool_client)
      client = double(LocalLB: lb_client)

      member = F5::Icontrol::Pool::Member.new(
        address: address,
        port: port,
        pool: pool,
        client: client,
      )

      member.enable
    end
  end

  describe "#disable" do
    it "disables the pool member in its parent pool" do
      address = "address"
      port = "port"

      pool_client = double(
        set_member_session_enabled_state: {
          pool_names: { item: [pool.address] },
          members: { item: [[{ address: address, port: port }]] },
          session_states: { item: [["STATE_DISABLED"]] },
        },
        set_member_monitor_state: {
          pool_names: { item: [pool.address] },
          members: { item: [[{ address: address, port: port }]] },
          monitor_states: { item: [["STATE_DISABLED"]] },
        },
      )
      lb_client = double(Pool: pool_client)
      client = double(LocalLB: lb_client)

      member = F5::Icontrol::Pool::Member.new(
        address: address,
        port: port,
        pool: pool,
        client: client,
      )

      member.disable
    end
  end
end
