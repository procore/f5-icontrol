require 'spec_helper'
require 'f5/icontrol/pool'
require 'f5/icontrol/pool_member'

RSpec.describe F5::Icontrol::PoolMember do
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

  let(:pool) { F5::Icontrol::Pool.new(address: 'pool') }

  describe '#enable' do
    it 'enables the pool member in its parent pool' do
      member = F5::Icontrol::PoolMember.new(address: 'address', port: '80', pool: pool)

      expect_any_instance_of(F5::Icontrol::API).to receive(:set_member_session_enabled_state).with(
        pool_names: { item: [pool.address] },
        members: { item: [[{ address: member.address, port: member.port }]] },
        session_states: { item: [['STATE_ENABLED']] },
      )

      expect_any_instance_of(F5::Icontrol::API).to receive(:set_member_monitor_state).with(
        pool_names: { item: [pool.address] },
        members: { item: [[{ address: member.address, port: member.port }]] },
        monitor_states: { item: [['STATE_ENABLED']] },
      )

      member.enable
    end
  end

  describe '#disable' do
    it 'disables the pool member in its parent pool' do
      member = F5::Icontrol::PoolMember.new(address: 'address', port: '80', pool: pool)

      expect_any_instance_of(F5::Icontrol::API).to receive(:set_member_session_enabled_state).with(
        pool_names: { item: [pool.address] },
        members: { item: [[{ address: member.address, port: member.port }]] },
        session_states: { item: [['STATE_DISABLED']] },
      )

      expect_any_instance_of(F5::Icontrol::API).to receive(:set_member_monitor_state).with(
        pool_names: { item: [pool.address] },
        members: { item: [[{ address: member.address, port: member.port }]] },
        monitor_states: { item: [['STATE_DISABLED']] },
      )

      member.disable
    end
  end
end
