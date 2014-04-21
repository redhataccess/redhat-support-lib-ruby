module  RedHatSupportLib
  module Brokers
    class Group < Broker
      def initialize(connection)
        super
      end
      def list
        result = @connection.get("/rs/groups", {:accept => :json})
        result['group']
      end

    end
  end
end