require 'rest_client'

module RedHatSupportLib
  module Network
    #
    # This HACK class allows us to set proxy on per connection basis
    # when using RestClient libraries 1.6.x and below
    # THINGS MAY BREAK when we upgrade RestClient.....
    #
    class HttpRequest < RestClient::Request

      def initialize (args={})
        if args[:proxy]
          @proxy = args[:proxy]
        end
        super(args)
      end

      def self.execute(args, & block)
        new(args).execute(& block)
      end

      # The proxy URI for this request. If `:proxy` was provided on this request,
      # use it over `RestClient.proxy`.
      #
      # @return [URI, nil]
      #
      def proxy_uri
        if defined?(@proxy)
          if @proxy
            URI.parse(@proxy)
          else
            nil
          end
        elsif RestClient.proxy
          URI.parse(RestClient.proxy)
        else
          nil
        end
      end

      def net_http_class
        p_uri = proxy_uri
        if p_uri
          Net::HTTP::Proxy(URI.decode(p_uri.hostname),p_uri.port, URI.decode(p_uri.user), URI.decode(p_uri.password))
        else
          Net::HTTP
        end
      end
    end
  end
end
