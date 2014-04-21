module  RedHatSupportLib
  module Brokers
    class Symptom < Broker
      def initialize(connection)
        super
      end
      
      def diagnose_file(file_path)
        
        File.open(file_path) do |file|
          headers = {:content_type => 'text/plain', :accept => :json}
          result = @connection.post("/rs/symptoms/extractor", file, headers)
        end
      end


    end
  end
end
