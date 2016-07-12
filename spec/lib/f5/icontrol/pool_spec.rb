require 'f5/icontrol/pool'
require 'f5/icontrol/pool_member'
require 'spec_helper'

RSpec.describe F5::Icontrol::Pool do
  before do
    F5::Icontrol.configure do |f5|
      f5.host = "test.host"
      f5.username = "username"
      f5.password = "password"
    end
    stub_request(:any, /test.host/)
  end

  describe '.list' do
    it 'lists all pools' do
      allow_any_instance_of(F5::Icontrol::API).to receive(:get_list) {
        {
          item: [
            "/Customer/POOL-app.procore.com-173.203.45.14-80",
            "/Customer/POOL-get.thecurrentset.com-192.237.235.30-80",
            "/Customer/POOL-imageprocessing.production-192.168.95.105-80",
          ],
          "@s:type" => "A:Array",
          "@a:array_type" => "y:string[45]"
        }
      }

      expect(F5::Icontrol::Pool.list.map(&:address)).to match_array(
        [
          "/Customer/POOL-app.procore.com-173.203.45.14-80",
          "/Customer/POOL-get.thecurrentset.com-192.237.235.30-80",
          "/Customer/POOL-imageprocessing.production-192.168.95.105-80",
        ]
      )
    end
  end

  describe '#members' do
    it 'returns an array of PoolMembers' do
      allow_any_instance_of(F5::Icontrol::API).to receive(:get_member_v2) {
        {
          item: {
            item: [
              { 
                address: "/Customer/web1.production",
                port: "80"
              }, 
              {
                address: "/Customer/web10.production",
                port: "80"
              }
            ],
            "@a:array_type": "iControl:Common.AddressPort[17]"
          },
          "@s:type": "A:Array",
          "@a:array_type": "iControl:Common.AddressPort[][1]"
        }
      }

      pool = F5::Icontrol::Pool.new("address")

      expect(pool.members.map(&:address)).to match_array(
        [
          "/Customer/web1.production",
          "/Customer/web10.production",
        ]
      )
    end
  end
end
