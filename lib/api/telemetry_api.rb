require_relative '../network/http_request'

module RedHatSupportLib::TelemetryApi

  SUBSET_LIST_TYPE_KEY = :subset_list_type
  SUBSET_LIST_TYPE_MACHINE_ID = :machine_ids
  SUBSET_LIST_TYPE_LEAF_ID = :leaf_ids
  SUBSET_ROUTE_REGEX = [/^(v[0-9]|latest)\/systems\/status$/,
                        /^systems\/status$/,
                        /^(v[0-9]|latest)\/systems$/,
                        /^systems$/,
                        /^(v[0-9]|latest)\/rules$/,
                        /^rules$/,
                        /^(v[0-9]|latest)\/reports$/,
                        /^reports$/,
                        /^(v[0-9]|latest)\/messaging\/data\/weeklyinfo$/,
                        /^(v[0-9]|latest)\/stats\/reports$/,
                        /^(v[0-9]|latest)\/stats\/systems$/,
                        /^(v[0-9]|latest)\/stats\/rules$/ ,
                        /^(v[0-9]|latest)\/topics$/,
                        /^(v[0-9]|latest)\/topics\/.*/,
                        /^(v[0-9]|latest)\/maintenance\/*/,
                        /^(v[0-9]|latest)\/exports\/*/].freeze


  class Client
    RestClient.log =Object.new.tap do |proxy|
      def proxy.<<(message)
        Rails.logger.debug message
      end
    end

    #
    #  Creates and returns the subset route corresponding to 'path' if 'path' is a subset resource, otherwise
    #  returns 'nil'
    #
    def create_subset_route(path)
      SUBSET_ROUTE_REGEX.each do |regex|
        if regex.match(path)
          subset_id = get_hash(get_machines)
          path.gsub(regex) do |s|
            api_version = Regexp.last_match[1]
            if api_version
              path = s.sub(api_version, "#{api_version}/subsets/#{subset_id}")
            else
              path = "subsets/#{subset_id}/#{s}"
            end
          end
          return path
        end
      end
      nil
    end


    def initialize(upload_url,
                   api_url,
                   creds,
                   optional)

      @creds = creds
      @upload_url = upload_url
      @api_url = api_url
      @subset_url = "#{@api_url}/subsets"
      @subset_list_type = SUBSET_LIST_TYPE_LEAF_ID

      if optional
        @logger = optional[:logger]
        @http_proxy = optional[:http_proxy] if optional[:http_proxy]
        @user_agent = optional[:user_agent] if optional[:user_agent]
        @http_headers = optional[:headers] if optional[:headers]
        @subset_list_type = optional[SUBSET_LIST_TYPE_KEY] if optional[SUBSET_LIST_TYPE_KEY]
      end
      ldebug ("HTTP proxy is set to #{@http_proxy}")
    end

    def post_upload(original_params,
                    original_payload)

      call_tapi('POST',
                '/',
                original_params,
                original_payload,
                do_upload: true)
    end

    def call_tapi_no_subset(original_method,
                            resource,
                            original_params,
                            original_payload,
                            extra)

      ldebug ('Called no subset proxy')
      call_tapi(original_method, resource, original_params, original_payload, extra, false)
    end

    def call_tapi(original_method,
                  resource,
                  original_params,
                  original_payload,
                  extra, use_subsets = true)

      if (use_subsets && subset_resource = create_subset_route(resource))
        ldebug "Doing subset call to #{subset_resource} (was : #{resource})"
        response = do_subset_call("#{@api_url}/#{subset_resource}", params: original_params, method: original_method, payload: original_payload)
        return {data: response, code: response.code}
      else
        if extra && extra[:do_upload]
          url = @upload_url
        else
          url = "#{@api_url}/#{resource}"
        end
        client = default_rest_client(url, params: original_params, method: original_method, payload: original_payload)
        response = client.execute
        return {data: response, code: response.code}
      end
    rescue RestClient::ExceptionWithResponse => e
      lerror nil, "Caught HTTP error when proxying call to tapi: #{e}"
      return {data: e.response, error: e, code: e.response.code}
    rescue Exception => e
      lerror e, "Caught unexpected error when proxying call to tapi: #{e}"
      return {data: e, error: e, code: 500}
    end

    def call_strata(original_method,
                    resource,
                    original_params,
                    original_payload,
                    _extra)

      url = "#{@api_url}/#{resource}"
      client = default_rest_client(url, params: original_params, method: original_method, payload: original_payload)
      response = client.execute
      return {data: response, code: response.code}
    rescue RestClient::ExceptionWithResponse => e
      lerror nil, "Caught HTTP error when proxying call to tapi: #{e}"
      return {data: e.response, error: e, code: e.response.code}
    rescue Exception => e
      lerror e, "Caught unexpected error when proxying call to tapi: #{e}"
      return {data: e, error: e, code: 500}
    end

    def get_machines
      throw NotImplementedError
    end

    def get_branch_id
      throw NotImplementedError
    end

    # Returns the machines hash used for /subset/$hash/
    def get_hash(machines)
      branch = get_branch_id
      hash = Digest::SHA1.hexdigest(machines.join)
      "#{branch}__#{hash}"
    end

    private

    def ldebug(message)
      @logger.debug "#{self.class.name}: #{message}" if @logger
    end

    def lerror(e, message)
      if @logger
        @logger.error ("#{self.class.name}: #{message}")
        @logger.error (e.backtrace.join("\n")) if e
      end
    end

    def do_subset_call(resource,
                       conf)
      ldebug 'Doing subset call'
      # Try subset
      begin
        ldebug "url: #{resource}"
        client = default_rest_client resource, conf
        response = client.execute
        ldebug 'First subset call passed, CACHE_HIT'
        ldebug(response.headers)
        return response
      rescue RestClient::ExceptionWithResponse => e

        if e.response && e.response.code == 412
          create_subset

          # retry the original request
          ldebug 'Subset creation passed calling newly created subset'
          response = client.execute
          return response
        else
          raise e
        end
      end
    end


    def create_subset
      ldebug 'First subset call failed, CACHE_MISS'
      subset_client = default_rest_client(@subset_url,
                                          method: :post,
                                          payload: {
                                              hash: get_hash(get_machines),
                                              branch_id: get_branch_id,
                                              @subset_list_type => get_machines
                                          }.to_json)
      subset_client.execute
    end


    def default_rest_client(url, override_options)
      opts = {
          method: :get,
          url: url
      }
      opts[:proxy] = @http_proxy unless @http_proxy.nil? || @http_proxy == ''
      opts = opts.merge(get_auth_opts(@creds))
      opts = opts.merge(override_options)
      opts[:headers] = @http_headers if @http_headers
      if override_options[:params]
        opts[:url] = "#{url}?#{override_options[:params].to_query}"
        override_options.delete(:params)
      end
      opts[:headers] = {} unless opts[:headers]
      if opts[:headers]['content-type'].nil?
        opts[:headers] = opts[:headers].merge('content-type' => 'application/json')
      end
      if opts[:headers]['accept'].nil?
        opts[:headers] = opts[:headers].merge('accept' => 'application/json')
      end
      if @user_agent
        opts[:headers] = opts[:headers].merge(user_agent: @user_agent)
      end
      RedHatSupportLib::Network::HttpRequest.new(opts)
    end
  end
end
