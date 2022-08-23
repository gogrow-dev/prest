# frozen_string_literal: true

module Prest
  # Base Service Object from which to extend to integrate with api's using the Prest gem.
  class Service < BasicObject
    def method_missing(method, *args, **kwargs)
      client.__send__(method, *args, **kwargs)
    end

    def self.method_missing(method, *args, **kwargs)
      new.__send__(:client).__send__(method, *args, **kwargs)
    end

    def self.respond_to_missing?(_, _)
      true
    end

    def respond_to_missing?(_, _)
      true
    end

    protected

    def client
      @client ||= ::Prest::Client.new(base_uri, options)
    end

    def base_uri
      ::Kernel.raise(Error, 'Implement in subclass')
    end

    def options
      {}
    end
  end
end
