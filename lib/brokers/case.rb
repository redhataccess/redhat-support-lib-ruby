module RedHatSupportLib
  module Brokers
    class Case < Broker
      def initialize(connection)
        super
      end

      def list(keywords, include_closed, detail, group, start_date, end_date,
               count, start, kwargs)
        headers = {:content_type => 'application/xml', :accept => :json}
        param =""
        if detail
          param = "?detail=true"
        end
        filter = self.create_filter(keywords, include_closed,
                                    group, start_date,
                                    end_date, count, start,
                                    @connection.config.username)
        result = @connection.post("/rs/cases/filter#{param}", filter, headers)

      end

      def list_severities
        result = @connection.get("/rs/values/case/severity", {:accept => :json})
        list = result["value"].map do |item|
          item["name"]
        end
      end

      def list_case_types
        result = @connection.get("/rs/values/case/types", {:accept => :json})
        list = result["value"].map do |item|
          item["name"]
        end
      end


      def get(id)
        result = @connection.get("/rs/cases/#{id}", {:accept => :json})
      end

      def create(product, version, summary, description, severity, folder_number=nil)

        headers = {:content_type => 'application/xml'}
        data = StringIO.new
        data << "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        data << "<tns:case xmlns:tns=\"http://www.redhat.com/gss/strata\"> "
        data << "<tns:summary>#{summary}</tns:summary>"
        data << "<tns:description>#{description}</tns:description>"
        data << "<tns:product>#{product}</tns:product>"
        data << "<tns:version>#{version}</tns:version>"
        data << "<tns:severity>#{severity}</tns:severity>"
        if folder_number
          data << "<tns:folderNumber>#{folder_number}</tns:folderNumber>"
        end
        data << "</tns:case>"
        result = @connection.post("/rs/cases", data.string, headers) do |code, headers|
          if code == 201
            return get_id(headers[:location])
          end
        end
      end

      def update(case_number, product, version, alternate_id, status, severity, type)
        headers = {:content_type => 'application/xml'}
        data = create_update_data(product, version, alternate_id, status, severity, type)
        result = @connection.put("/rs/cases/#{case_number}", data, headers) do |code, headers|
          if code == 202
            return get case_number
          end
        end
      end

      def create_update_data(product, version, alternate_id, status, severity, type)
        #for now use xml version
        data = StringIO.new
        data << "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
        if alternate_id
          data << "<case  xmlns=\"http://www.redhat.com/gss/strata\" alternateId=\"#{alternate_id}\">"
        else
          data << "<case  xmlns=\"http://www.redhat.com/gss/strata\">"
        end
        if product
          data << "<product>#{product}</product>"
        end
        if version
          data << "<version>#{version}</version>"
        end
        if status
          data << "<status>#{status}</status>"
        end
        if severity
          data << "<severity>#{severity}</severity>"
        end
        if type
          data << "<type>#{type}</type>"
        end
        data << "</case>"
        return data.string
      end

      def create_filter(keywords, include_closed, group, start_date, end_date,
                        count, start, owner_sso_name)
        #for now use xml version
        filter = StringIO.new
        filter << '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        filter << '<caseFilter xmlns="http://www.redhat.com/gss/strata">'
        if keywords
          keywords.each do |keyword|
            filter << "<keyword>#{keyword}</keyword>"
          end
        end
        if include_closed
          filter << "<includeClosed>true</includeClosed>"
        end
        if group.nil?
          filter << "<onlyUngrouped>false</onlyUngrouped>"
        else
          filter << "<groupNumber>#{group}</groupNumber>"
        end
        if start_date
          filter << "<startDate>#{start_date}</startDate>"
        end
        if end_date
          filter << "<endDate>#{end_date}</endDate>"
        end
        if count
          filter << "<count>#{count}</count>"
        end
        if start
          filter << "<start>#{start}</start>"
        end
        filter << "<ownerSSOName>#{owner_sso_name}</ownerSSOName>"
        filter << "</caseFilter>"
        filter.string
      end


    end
    # class CaseFilter
    #   attr_accessor :keywords, :include_closed, :detail,
    #     :group, :start_date, :end_date, :count, :start, :kwargs
    # end
  end
end
