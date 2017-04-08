require 'ruby_memoized/version'
require 'ruby_memoized/memoizer'

module RubyMemoized
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def memoized
      @memoized = true
    end

    def unmemoized
      @memoized = false
    end

    def method_added(method_name)
      if @memoized
        @memoized = false

        unmemoized_method_name = :"unmemoized_#{method_name}"

        memoizer_name = :"memoizer_for_#{method_name}"
        define_method memoizer_name do
          memoizer = instance_variable_get "@#{memoizer_name}"
          if memoizer
            memoizer
          else
            instance_variable_set "@#{memoizer_name}", Memoizer.new(self, unmemoized_method_name)
          end
        end

        alias_method unmemoized_method_name, method_name

        define_method method_name do |*args, &block|
          send(memoizer_name).call(*args, &block)
        end

        @memoized = true
      end
    end
  end
end
