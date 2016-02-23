require 'pathname'
require_relative '../network/ftp_connection'

module RedHatSupportLib
  module Brokers
    class Attachment < Broker

      def initialize(connection, comments_broker, attachments_config)
        super(connection)
        @comments_broker = comments_broker
        @attachments_config = attachments_config
      end

      def list(case_number, start_date, end_date, filter=[])

        uri = "/rs/cases/#{case_number}/attachments"
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


      def get(case_number, attachment_uuid, file_name, dest_dir)
        #TODO

      end

      def delete(case_number, attachment_uuid)

        uri = "/rs/cases/#{case_number}/attachments/#{attachment_uuid}";
        result = @connection.delete(uri)
      end

      def add(case_number, is_public, file_name, description)
        #puts "Sending attachment for case "+ case_number
        attachment_id = nil
        File.open(file_name) do |file|
          if file.size < @attachments_config[:max_http_size]
            headers = {:description => description}
            @connection.upload("/rs/cases/#{case_number}/attachments",
                               file, headers) do |code, headers|
              if code == 201
                location = headers[:location]
                attachment_id = get_id(location)
              else
                #What to return here?
                raise "Attachment failed " + code
              end
            end
          else
            ftp_connection = RedHatSupportLib::Network::FtpConnection.new(@attachments_config[:ftp_host])
            ftp_connection.upload(file_name,
                                  @attachments_config[:ftp_remote_dir])
            comment = StringIO.new
            comment << "The file #{file_name} exceeds the byte limit to attach a file to a case;"
            comment << " Therefore, the file was uploaded to"
            comment << " #{@attachments_config[:ftp_host]} as #{File.basename(file_name)}"
            @comments_broker.add(comment.string, case_number, false, is_public)
            #TODO what to return here?
          end
        end
        attachment_id
      end

      def get_id(uri)
        parts = uri.split("/")
        parts.pop
      end

    end
  end
end
