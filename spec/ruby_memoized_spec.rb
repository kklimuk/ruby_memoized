require 'spec_helper'

describe RubyMemoized do
  let(:klass) do
    output_value = value
    method_name = method

    Class.new do
      include RubyMemoized

      memoized
      define_method(method_name) do |*_args, **_kwargs|
        output_value
      end
    end
  end

  let(:instance) { klass.new }

  let(:method) { :war }
  let(:value) { :is_peace }

  subject { instance }

  it 'builds a method for a memoizer' do
    is_expected.to respond_to(:memoizer_for_war)
  end

  it 'aliases the unmemoized method' do
    is_expected.to respond_to(:unmemoized_war)
  end

  describe 'calling the memoized method' do
    subject { instance.send(method) }

    it 'returns the value' do
      is_expected.to eq value
    end

    it 'calls the memoizer for the value' do
      expect(instance).to receive(:memoizer_for_war).and_call_original
      subject
    end

    context 'and there are args' do
      subject { instance.send(method, *args, **kwargs) }

      let(:args) { [:foo, :bar] }
      let(:kwargs) { { foo: :bar } }

      it 'caches the arguments' do
        is_expected.to eq value
        expect(instance.memoizer_for_war.cache).to eq([[:foo, :bar], {foo: :bar}, nil] => value)
      end
    end
  end
end
