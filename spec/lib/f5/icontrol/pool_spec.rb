require "f5/icontrol/pool"
require "f5/icontrol/pool/member"
require "spec_helper"

RSpec.describe F5::Icontrol::Pool do
  describe ".list" do
    it "lists all pools" do
      pool_client = double(
        get_list: {
          item: [
            "/Customer/POOL-app.procore.com-173.203.45.14-80",
            "/Customer/POOL-get.thecurrentset.com-192.237.235.30-80",
            "/Customer/POOL-imageprocessing.production-192.168.95.105-80",
          ],
          "@s:type" => "A:Array",
          "@a:array_type" => "y:string[45]",
        },
      )
      lb_client = double(Pool: pool_client)
      client = double(LocalLB: lb_client)

      expect(F5::Icontrol::Pool.list(client: client).map(&:address)).to match_array(
        [
          "/Customer/POOL-app.procore.com-173.203.45.14-80",
          "/Customer/POOL-get.thecurrentset.com-192.237.235.30-80",
          "/Customer/POOL-imageprocessing.production-192.168.95.105-80",
        ]
      )
    end
  end

  describe "#members" do
    it "returns an array of PoolMembers" do
      pool_client = double(
        get_member_v2: {
          item: {
            item: [
              {
                address: "/Customer/web1.production",
                port: "80",
              },
              {
                address: "/Customer/web10.production",
                port: "80",
              },
            ],
            "@a:array_type": "iControl:Common.AddressPort[17]",
          },
          "@s:type": "A:Array",
          "@a:array_type": "iControl:Common.AddressPort[][1]",
        },
      )
      lb_client = double(Pool: pool_client)
      client = double(LocalLB: lb_client)

      pool = F5::Icontrol::Pool.new(address: "address", client: client)

      expect(pool.members.map(&:address)).to match_array(
        [
          "/Customer/web1.production",
          "/Customer/web10.production",
        ]
      )
    end
  end
end
