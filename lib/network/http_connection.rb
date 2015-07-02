require 'rest_client'
require 'json'
require "base64"
require_relative './http_request'
require_relative './http_resource'


module RedHatSupportLib
  module Network
    class HttpConnection
      USER_AGENT = "ruby-rest-client"
      attr_reader :config
      def initialize(config)
        @config = config
        user_agent = USER_AGENT
        unless config.user_agent.nil?
          user_agent = config.user_agent
        end
        @additional_headers = {:user_agent => user_agent}
        #unless config.proxy_host.nil? || config.proxy_host.strip.empty?
        #  RestClient.proxy = "http://#{config.proxy_user}:#{config.proxy_password}@#{config.proxy_host}:#{config.proxy_port}"
        #end
        unless config.log_location.nil?
          RestClient.log = config.log_location
        end
      end

      def get(relative_uri, headers={}, &block)

        hdr = @additional_headers.merge!(headers)
        result = get_resource(relative_uri).get hdr
        parse_response(result.body, headers[:accept])

      end

      def post(relative_uri, data, headers={}, &block)

        hdr = @additional_headers.merge!(headers)
        result = get_resource(relative_uri).post data, hdr
        if block
          yield result.code, result.headers
        end
        parse_response(result.body, headers[:accept])
      end

      def put(relative_uri, data, headers={}, &block)

        hdr = @additional_headers.merge!(headers)
        result = get_resource(relative_uri).put data, hdr
        if block
          yield result.code, result.headers
        end
        parse_response(result.body, headers[:accept])
      end

      def delete(relative_uri, headers={}, &block )

        hdr = @additional_headers.merge!(headers)
        result = get_resource(relative_uri).delete hdr
        if block
          yield result.code, result.headers
        end
      end

      #upload a file as multipart
      def upload(relative_uri, file, headers={}, &block )
        request = RedHatSupportLib::Network::HttpRequest.new(
          :headers => headers,
          :method => :post,
          :url => "#{@config.base_uri}#{relative_uri}",
          :user => @config.username,
          :password => @config.password,
          :payload => {
            :multipart => true,
            :file => file
          },
          :proxy => config.proxy
        )

        result = request.execute
        if block
          yield result.code, result.headers
        end
      end

      private
      def get_resource(relative_uri)
        resource = RedHatSupportLib::Network::HttpResource.new("#{@config.base_uri}#{relative_uri}",
                                            {:user => @config.username,
                                             :password => @config.password,
                                             :proxy => config.proxy})
      end

      def parse_response(body, format)
        return nil if body.nil? || body.strip.empty? || body == "null"
        if (format == :json)
          return JSON.parse(body)
        end
        body  # for now do nothing for other formats
      end
    end

    class Config
      attr_accessor :username, :password, :base_uri, :user_agent,
        :proxy, :log_location
    end
  end
end
