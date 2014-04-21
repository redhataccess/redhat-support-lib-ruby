module  RedHatSupportLib
  module Brokers
    class Product < Broker
      def initialize(connection)
        super
      end
      def list
        result = @connection.get("/rs/products", {:accept => :json})
        result['product']
      end

    end
  end
end