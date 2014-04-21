module  RedHatSupportLib
  module Brokers
    class Entitlement < Broker
      def initialize(connection)
        super
      end
      def list
        result = @connection.get("/rs/entitlements", {:accept => :json})
        result['entitlement']
      end

    end
  end
end