# frozen_string_literal: true

require 'httparty'
require_relative 'prest/version'

module Prest
  class Error < StandardError; end

  # Main wrapper class for Prest. To use the gem, call:
  # Prest::Client.new('https://base_uri.com', { headers: { 'Authorization' => 'Bearer token' }})
  class Client < BasicObject
    SUPPORTED_HTTP_VERBS = %i[get post put patch delete].freeze

    def initialize(base_uri, options = {})
      @base_uri = base_uri
      @options = options
      @fragments = []
      @query_params = {}
    end

    def method_missing(method, *args, **kwargs)
      if SUPPORTED_HTTP_VERBS.include?(method)
        execute_query(method, **kwargs)
      else
        chain_fragment(method.to_s, *args, **kwargs)
        self
      end
    end

    def respond_to_missing?(_)
      true
    end

    private

    def execute_query(http_method, body: {})
      ::HTTParty.send(http_method, build_url, headers: headers, body: body)
    end

    def chain_fragment(fragment_name, *args, **kwargs)
      arguments = args.join('/')
      parsed_args = arguments.empty? ? '' : "#{arguments}/"
      @query_params.merge!(kwargs)
      @fragments << "#{fragment_name.gsub("__", "-")}/#{parsed_args}"
    end

    def headers
      @options[:headers] || {}
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
