module RedHatSupportLib
  module Brokers
    class Problem < Broker
      def initialize(connection)
        super
      end

      def diagnose_string(input)
        #rs/problems
        #TODO encode input and error handling
        #payload = input
        #headers = {"Content-Type" => "application/json",'Accept' => 'application/vnd.redhat.json.suggestions'}
        headers = {:content_type => 'text/plain', :accept => :json}
        result = @connection.post("/rs/problems", input, headers)
        response = result['source_or_link_or_problem'][2]['source_or_link']
        if response
          response.each do |resp|
            id = {:solution_id => get_solution_id(resp)}
            resp.merge! id
          end
        end
      end


      def diagnose_file(file_path)

        File.open(file_path) do |file|
          headers = {:content_type => 'application/octet-stream', :accept => :json}
          result = @connection.post("/rs/problems", file, headers)
          response = result['source_or_link_or_problem'][2]['source_or_link']
          if response
            response.each do |resp|
              id = {:solution_id => get_solution_id(resp)}
              resp.merge! id
            end
          end
        end

      end


      private
      def get_solution_id(problem)
        uri = problem["uri"]
        parts = uri.split("/")
        parts.pop
      end

    end
  end
end
