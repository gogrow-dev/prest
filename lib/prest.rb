# frozen_string_literal: true

require 'httparty'
require_relative 'prest/client'
require_relative 'prest/service'
require_relative 'prest/version'
require_relative 'prest/response'

module Prest
  class Error < StandardError; end
end
