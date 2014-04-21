module  RedHatSupportLib
  module Brokers
    class Broker
            attr_accessor :connection
      def initialize (connection)
        @connection = connection
      end

      def  get_id(uri)
        parts = uri.split("/")
        parts.pop
      end
    end
  end
end
