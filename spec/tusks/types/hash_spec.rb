require 'spec_helper'

module Tusks
  describe Hash do
    context '#to_pg_s' do
      before :each do
        @hash = {}
      end

      it 'should serialize itself to a json string using #to_json' do
        expect(@hash).to receive :to_json
        @hash.to_pg_s
      end
    end
  end
end
