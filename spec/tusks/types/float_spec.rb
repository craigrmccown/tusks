require 'spec_helper'

module Tusks
  describe Float do
    before :each do
      @float1 = 1.23
      @float2 = 3.21
    end

    context '#to_pg_s' do
      it 'should serialize to a string representation of its value' do
        expect(@float1.to_pg_s).to eql '1.23'
        expect(@float2.to_pg_s).to eql '3.21'
      end
    end
  end
end
