# frozen_string_literal: true

module Prest
  # Main wrapper class for Prest. To use the gem, call:
  # Prest::Client.new('https://base_uri.com', { headers: { 'Authorization' => 'Bearer token' }})
  class Client < BasicObject
    SUPPORTED_HTTP_VERBS = %i[get post put patch delete get! post! put! patch! delete!].freeze

    def initialize(base_uri, options = {})
      @base_uri = base_uri
      @options = options
      @fragments = []
      @query_params = {}
    end

    def method_missing(method, *args, **kwargs)
      if SUPPORTED_HTTP_VERBS.include?(method)
        if method.to_s.end_with?('!')
          execute_query!(method[0..-2], **kwargs)
        else
          execute_query(method, **kwargs)
        end
      else
        chain_fragment(method.to_s, *args, **kwargs)
        self
      end
    end

    def respond_to_missing?(_, _)
      true
    end

    private

    def execute_query(http_method, body: {})
      res = ::HTTParty.send(http_method, build_url, headers: headers, body: body)
      ::Prest::Response.new(res.code, res.parsed_response, res.headers)
    rescue ::HTTParty::ResponseError => e
      ::Kernel.raise(::Prest::RequestError.new(status: res.status,
                                               body: res.parsed_response,
                                               headers: res.headers), e.message)
    end

    def execute_query!(*args, **kwargs)
      res = execute_query(*args, **kwargs)

      unless res.successful?
        ::Kernel.raise(::Prest::RequestError.new(status: res.status,
                                                 body: res.body.to_json,
                                                 headers: res.headers), res.body.to_json)
      end

      res
    end

    def chain_fragment(fragment_name, *args, **kwargs)
      arguments = args.join('/')
      parsed_args = arguments.empty? ? '' : "/#{arguments}"
      @query_params.merge!(kwargs)
      @fragments << "#{fragment_name.gsub("__", "-")}#{parsed_args}"
    end

    def headers
      tmp_headers = @options[:headers] || {}
      tmp_headers.merge!('Content-Type' => 'application/json', 'Accept' => 'application/json') if @options[:json]
      tmp_headers
    end

    def build_url
      path = @fragments.join('/')

      stringified_params = ''
      @query_params.to_a.each do |key_val|
        stringified_params += "#{key_val[0]}=#{key_val[1]}&"
      end

      stringified_params = stringified_params.empty? ? '' : "?#{stringified_params[0..-2]}"
      "#{@base_uri}/#{path}#{stringified_params}"
    end
  end
end
