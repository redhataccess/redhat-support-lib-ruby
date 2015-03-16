module RedHatSupportLib::TelemetryApi

  SUBSETTED_RESOURCES = {
    "reports" => true,
    "systems" => true
  }

  class Client
    # RestClient.log =
    # Object.new.tap do |proxy|
    #   def proxy.<<(message)
    #     Rails.logger.error message
    #   end
    # end

    def initialize strata_url, creds, optional
      @creds      = creds
      @upload_url = "#{strata_url}/rs/telemetry"
      @api_url    = "#{strata_url}/rs/telemetry/api/v1"
      @subset_url = "#{@api_url}/subsets"

      if optional
        @logger = optional[:logger]
      end
    end

    def call_tapi original_method, resource, original_params, original_payload, extra

      begin
        if SUBSETTED_RESOURCES.has_key?(resource)
          ldebug "Doing subset call to #{resource}"
          response = do_subset_call(resource, { params: original_params, method: original_method, payload: original_payload })
          return { data: response, code: response.code }
        else
          if resource == "/"
            url = @upload_url
          else
            url = "#{@api_url}/#{resource}"
          end

          ldebug "Doing non subset call to #{url}"
          client = default_rest_client(url, { params: original_params, method: original_method, payload: original_payload })
          response = client.execute
          return { data: response, code: response.code }
        end
      rescue RestClient::ExceptionWithResponse => e
        lerror nil, "Caught HTTP error when proxying call to tapi: #{e}"
        return { data: e.response, error: e, code: e.response.code }
      rescue Exception => e
        lerror e, "Caught unexpected error when proxying call to tapi: #{e}"
        return { data: e, error: e, code: 500 }
      end
    end

    private

    def ldebug message
      if @logger
        @logger.debug "#{self.class.name}: #{message}"
      end
    end

    def lerror e, message
      if @logger
        @logger.error "#{self.class.name}: #{message}"
        if e
          @logger.error e.backtrace.join("\n")
        end
      end
    end

    def do_subset_call resource, conf
      ldebug "Doing subset call"
      # Try subset
      begin
        url = build_subset_url(resource)
        ldebug "url: #{url}"
        client = default_rest_client url, conf
        response = client.execute
        ldebug "First subset call passed, CACHE_HIT"
        return response
      rescue RestClient::ExceptionWithResponse => e

        if e.response.code == 412
          create_subset

          # retry the original request
          ldebug "Subset creation passed calling newly created subset"
          response = client.execute
          return response
        else
          raise e
        end
      end
    end

    def create_subset
      ldebug "First subset call failed, CACHE_MISS"
      subset_client = default_rest_client @subset_url, {
        :method => :post,
        payload: {
          hash: get_hash(get_machines()),
          branch_id: get_branch_id,
          leaf_ids: get_machines
        }.to_json
      }
      response = subset_client.execute
    end

    # Transforms the URL that the user requested into the subsetted URL
    def build_subset_url url
      url = "#{@subset_url}/#{get_hash get_machines}/#{url}"
      ldebug "build_subset_url #{url}"
      return url
    end

    # Returns an array of the machine IDs that this user has access to
    # def get_machines
    #  raise NotImplementedError
    # end

    # Returns the UUID for this branch
    # def get_branch_id
    #  raise NotImplementedError
    # end

    # Returns the machines hash used for /subset/$hash/
    def get_hash(machines)
      branch = get_branch_id
      hash   = Digest::SHA1.hexdigest(machines.join)
      return "#{branch}__#{hash}"
    end

    def default_rest_client(url, override_options)

      opts = {
        :method   => :get,
        :url      => url,
      }
      opts = opts.merge(get_auth_opts(@creds))
      opts = opts.merge(override_options)
      if override_options[:params]
        opts[:url] = "#{url}?#{override_options[:params].to_query}"
        override_options.delete(:params)
      end
      if override_options[:method] == :post and override_options[:payload]
        opts[:headers] = ensure_content_type(opts)
      end
      RestClient::Request.new(opts)
    end


    def ensure_content_type(opts)
      # TODO we should probably not force here.
      # I would rather throw an exception if nothing is provided
      # Or even just let it POST w/o anything and have upstream fail
      if not opts[:headers]
        return opts[:headers] = {'content-type' => 'application/json', 'accept' => 'application/json'}
      end
    end
  end

end
