require 'open-uri'
module  RedHatSupportLib
  module Brokers
    class Solution < Broker
      def initialize(connection)
        super
      end

      def search(text, limit=10)
        text = URI::encode(text)
        result = @connection.get("/rs/solutions?keyword=#{text}&limit=#{limit}", {:accept => :json})
        result['solution']
      end

      def get_solution(id)
        #error handling
        result = @connection.get("/rs/solutions/#{id}", {:accept => :json})
        #result.parsed_response
      end
    end
  end
end
