module RubyMemoized
  class Memoizer
    attr_reader :context, :method

    def initialize(context, method)
      @context = context
      @method = method
    end

    def call(*args, **kwargs, &block)
      return cache[[args, kwargs, block]] if cache.has_key?([args, kwargs, block])
      cache[[args, kwargs, block]] = context.send(method, *args, **kwargs, &block)
    end

    def cache
      @cache ||= {}
    end
  end
end
