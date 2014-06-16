require 'spec_helper'

module Tusks
  describe Array do
    before :each do
      @arr = []
    end

    context '#to_pg_s' do
      context 'holding zero elements' do
        it 'should serialize to an empty Postgres array constructor' do
          expect(@arr.to_pg_s).to eql 'ARRAY[]'
        end
      end

      context 'holding one element' do
        before :each do
          @arr << 'element'
        end

        it 'should serialize to a Postgres array constructor holding a serialized version of that element' do
          expect(@arr.to_pg_s).to eql 'ARRAY[\'element\']'
        end
      end

      context 'holding many elements' do
        before :each do
          @arr << 'element1'
          @arr << 'element2'
        end

        it 'should serialize to a Postgres array constructor holding serialized versions of those elements' do
          expect(@arr.to_pg_s).to eql 'ARRAY[\'element1\',\'element2\']'
        end
      end

      context 'holding unsupported types' do
        before :each do
          @arr << double
        end

        it 'should raise a Tusks::UnsupportedTypeError' do
          expect { @arr.to_pg_s }.to raise_error Tusks::UnsupportedTypeError
        end
      end

      context 'holding nested arrays' do
        before :each do
          @arr << ['asdf']
        end

        it 'should raise a Tusks::NestedArrayError' do
          expect { @arr.to_pg_s }.to raise_error Tusks::NestedArrayError
        end
      end
    end
  end
end
