require "spec_helper"
require "f5/icontrol/pool"
require "f5/icontrol/pool/member"
require "f5/icontrol/pool/member/statistics"

RSpec.describe F5::Icontrol::Pool::Member::Statistics do
  let(:pool) { F5::Icontrol::Pool.new(address: "pool") }
  let(:member) do
    F5::Icontrol::Pool::Member.new(
      address: "member",
      port: "80",
      pool: pool,
      client: double,
    )
  end

  describe "#connections" do
    it "returns connections" do
      member_statistics_fixture = "spec/fixtures/member_stats.json"
      member_statistics = JSON.parse(
        File.read(member_statistics_fixture),
        symbolize_names: true,
      )

      pool_client = double(get_member_statistics: member_statistics)
      lb_client = double(Pool: pool_client)
      client = double(F5::Icontrol::API, LocalLB: lb_client)

      stats = F5::Icontrol::Pool::Member::Statistics.new(
        pool: pool,
        member: member,
        client: client,
      )

      expect(stats.connections).to eq(48)
    end
  end
end
