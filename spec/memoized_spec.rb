require 'spec_helper'

describe Memoized do
  let(:klass) do
    output_value = value
    method_name = method

    Class.new do
      include Memoized

      memoized
      define_method(method_name) { output_value }
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

    let(:memoizer) { instance_double(Memoized::Memoizer) }

    it 'returns the value' do
      is_expected.to eq value
    end

    it 'calls the memoizer for the value' do
      expect(instance).to receive(:memoizer_for_war).and_return(memoizer)
      expect(memoizer).to receive(:call).and_return(value)
      subject
    end
  end
end
