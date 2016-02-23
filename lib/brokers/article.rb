require 'open-uri'
module RedHatSupportLib
  module Brokers
    class Article < Broker
      def initialize(connection)
        super
      end

      def search(text, limit=10)
        #TODO encode input and error handling
        text = URI::encode(text)
        result = @connection.get("/rs/articles?keyword=#{text}&limit=#{limit}", {:accept => :json})
        result['article']
      end

      def get_article(id)
        #TODO encode input and error handling
        result = @connection.get("/rs/articles/#{id}", {:accept => :json})
        #result.parsed_response
      end

    end
  end
end
