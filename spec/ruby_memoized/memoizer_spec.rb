require 'spec_helper'

describe RubyMemoized::Memoizer do
  let(:memoizer) { described_class.new(context, method) }

  let(:context) { klass.new }
  let(:klass) do
    output_value = value
    method_name = method

    Class.new do
      define_method(method_name) { |*_, **_, &_| output_value }
    end
  end

  let(:method) { :american_exceptionalism }

  subject { memoizer.call(*args, **kwargs, &block) }

  shared_examples 'a memoized method' do |args, kwargs, block, value|
    let(:args) { args }
    let(:kwargs) { kwargs }
    let(:block) { block }
    let(:value) { value }

    it 'caches the value' do
      is_expected.to eq value
      expect(memoizer.cache).to include([args, kwargs, block] => value)
    end

    context 'and the subject has already run once' do
      before { memoizer.call(*args, **kwargs, &block) }

      it 'uses the cache if the value has been computed' do
        expect(memoizer.cache).to receive(:[]).with([args, kwargs, block]).and_call_original
        is_expected.to eq value
      end
    end
  end

  context 'when there are no arguments or blocks' do
    include_examples 'a memoized method', [], {}, nil, 26
  end

  context 'when there are arguments' do
    include_examples 'a memoized method', [1, 2, 3], {}, nil, 34
  end

  context 'when there are only keyword arguments' do
    include_examples 'a memoized method', [], { foo: :bar }, nil, 26
  end

  context 'when there is a block' do
    include_examples 'a memoized method', [], {}, proc {}, 36
  end

  context 'when there are arguments and a block' do
    include_examples 'a memoized method', [1, 2, 3], {}, proc {}, 53
  end
end
