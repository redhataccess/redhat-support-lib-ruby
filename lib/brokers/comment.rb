module RedHatSupportLib
  module Brokers
    class Comment < Broker
      def initialize(connection)
        super
      end

      def get(case_number, comment_id)
        #TODO check params
        params =[];
        result = @connection.get("/rs/cases/#{case_number}/comments/#{comment_id}",
                                 {:accept => :json})
      end

      def list(case_number, start_date, end_date, filter=[])

        uri = "/rs/cases/#{case_number}/comments"
        param = ''
        if start_date
          param = "?startDate=#{start_date}"
        end
        if end_date
          if start_date
            param = param + "&endDate=#{end_date}"
          else
            param = param + "?endDate=#{end_date}"
          end
        end
        result = @connection.get(uri+param, {:accept => :json})
      end

      def add(text, case_number, is_draft, is_public=true)
        headers = {:content_type => 'application/xml'}
        data = create_comment(text, case_number, is_draft, is_public)
        result = @connection.post("/rs/cases/#{case_number}/comments", data, headers) do |code, headers|
          if code == 201
            location = headers[:location]
            return get_id(location)
          end
        end
      end

      def create_comment(comment, case_number, is_draft, is_public=true)
        #for now use xml version
        filter = StringIO.new
        filter << '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        filter << '<tns:comment xmlns:tns="http://www.redhat.com/gss/strata"' << " caseNumber=\"#{case_number}\">"
        filter << "<tns:text>#{comment}</tns:text>"
        if is_public
          filter << "<tns:public>true</tns:public>"
        else
          filter << "<tns:public>false</tns:public>"
        end
        if is_draft
          filter << "<tns:draft>true</tns:draft>"
        else
          filter << "<tns:draft>false</tns:draft>"
        end
        filter << "</tns:comment>"
        filter.string
      end

      def get_id(uri)
        parts = uri.split("/")
        parts.pop
      end
    end
  end
end
