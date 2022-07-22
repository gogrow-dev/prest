# frozen_string_literal: true

module Prest
  # Main wrapper class for Prest Response.
  class Response
    extend ::Forwardable

    def_delegator :@body, :[]

    attr_reader :status, :body, :headers

    def initialize(status, body, headers)
      @status = status
      @body = body
      @headers = headers
    end

    def successful?
      @status.between?(100, 399)
    end
  end
end
