require "spec_helper"
require "f5/icontrol/pool"
require "f5/icontrol/pool/member"
require "f5/icontrol/pool/member/status"

RSpec.describe F5::Icontrol::Pool::Member::Status do
  let(:pool) { F5::Icontrol::Pool.new(address: "pool") }
  let(:member) do
    F5::Icontrol::Pool::Member.new(
      address: "member",
      port: "80",
      pool: pool,
      client: double,
    )
  end

  describe "available?" do
    it "returns true when the member is healthy" do
      member_status_fixture = "spec/fixtures/healthy_member_status.json"
      member_status = JSON.parse(
        File.read(member_status_fixture),
        symbolize_names: true,
      )

      pool_client = double(get_member_object_status: member_status)
      lb_client = double(Pool: pool_client)
      client = double(F5::Icontrol::API, LocalLB: lb_client)

      stats = F5::Icontrol::Pool::Member::Status.new(
        pool: pool,
        member: member,
        client: client,
      )

      expect(stats.available?).to be(true)
    end

    it "returns false when the member is unhealthy" do
      member_status_fixture = "spec/fixtures/unhealthy_member_status.json"
      member_status = JSON.parse(
        File.read(member_status_fixture),
        symbolize_names: true,
      )

      pool_client = double(get_member_object_status: member_status)
      lb_client = double(Pool: pool_client)
      client = double(F5::Icontrol::API, LocalLB: lb_client)

      stats = F5::Icontrol::Pool::Member::Status.new(
        pool: pool,
        member: member,
        client: client,
      )

      expect(stats.available?).to be(false)
    end
  end
end
