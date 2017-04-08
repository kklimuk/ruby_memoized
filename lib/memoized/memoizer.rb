module Memoized
  class Memoizer
    attr_reader :context, :method

    def initialize(context, method)
      @context = context
      @method = method
    end

    def call(*args, &block)
      return cache[[args, block]] if cache.has_key?([args, block])
      cache[[args, block]] = context.send(method, *args, &block)
    end

    def cache
      @cache ||= {}
    end
  end
end