require 'spec_helper'

module Tusks
  describe Integer do
    before :each do
      @int1 = 999
      @int2 = 100
    end

    context '#to_pg_s' do
      it 'should serialize to a string representation of its value' do
        expect(@int1.to_pg_s).to eql '999'
        expect(@int2.to_pg_s).to eql '100'
      end
    end
  end
end
