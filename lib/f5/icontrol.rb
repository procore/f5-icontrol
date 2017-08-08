require "f5/icontrol/api"
require "f5/icontrol/configuration"
require "f5/icontrol/pool"
require "f5/icontrol/pool/member"
require "f5/icontrol/pool/member/statistics"
require "f5/icontrol/pool/member/status"
require "f5/icontrol/version"
require "openssl"
require "savon"

module F5
  module Icontrol
    extend Configuration
  end
end
