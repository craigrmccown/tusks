require 'spec_helper'

module Tusks
  describe NilClass do
    before :each do
      @nil = nil
    end

    context '#to_pg_s' do
      it 'should serialize to NULL' do
        expect(@nil.to_pg_s).to eql 'NULL'
      end
    end
  end
end
