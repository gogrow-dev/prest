# frozen_string_literal: true

require 'httparty'
require_relative 'prest/client'
require_relative 'prest/service'
require_relative 'prest/version'
require_relative 'prest/response'

module Prest
  class Error < StandardError; end

  # Error for when a request is unsuccessful.
  class RequestError < StandardError
    attr_reader :status, :body, :headers

    def initialize(status:, body: '', headers: {})
      super()
      @status = status
      @body = body
      @headers = headers
    end
  end
end
