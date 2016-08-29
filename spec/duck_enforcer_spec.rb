require 'spec_helper'
require 'duck_enforcer'
describe 'DuckEnforcer' do
  class Quacker < DuckEnforcer
    implement :quack
    implement :waddle
  end

  describe '.quacks_like_a!' do
    it 'should not raise error when the class is conform to the DuckEnforcer' do
      expect {
        class Duck1
          def quack() :no_implementation_needed; end
          def waddle() :no_implementation_needed; end
          quacks_like_a! Quacker
        end
      }.not_to raise_error
    end

    it 'should not raise error when the class is conform and has other methods' do
      expect {
        class Duck2
          def quack() :no_implementation_needed; end
          def waddle() :no_implementation_needed; end
          def additional_method() :no_implementation_needed; end
          quacks_like_a! Quacker
        end
      }.not_to raise_error
    end

    it 'should raise an error when the class is not conform to the DuckEnforcer' do
      expect {
        class Duck3
          def no_quack() :no_implementation_needed; end
          def waddle() :no_implementation_needed; end
          quacks_like_a! Quacker
        end
      }.to raise_error NotImplementedError
    end
  end

  describe '.as_a' do
    class Duck
      def quack() :quack; end
      def waddle() :waddle; end
      def mooh() :mooh; end
    end

    class NotDuck
      def waddle() :waddle; end
      def mooh() :mooh; end
    end

    let (:duck) { Duck.new }
    let (:not_duck) { NotDuck.new }

    it { expect(duck.as_a(Quacker).quack).to eq :quack }
    it { expect(duck.as_a(Quacker).waddle).to eq :waddle }
    it { expect{duck.as_a(Quacker).mooh}.to raise_error NoMethodError }
    it { expect{not_duck.as_a(Quacker)}.to raise_error NotImplementedError }

  end
end
