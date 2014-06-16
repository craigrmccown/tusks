require 'spec_helper'

module Tusks
  describe String do
    context '#to_pg_s' do
      context 'of zero length' do
        before :each do
          @str = ''
        end

        it 'should serialize to two escaped single quotes, side-by-side' do
          expect(@str.to_pg_s).to eql '\'\''
        end
      end

      context 'of non-zero length' do
        before :each do
          @str = 'this is a string'
        end

        it 'should surround itself by escaped single quotes' do
          expect(@str.to_pg_s).to eql '\'this is a string\''
        end
      end

      context 'containting single quotes' do
        before :each do
          @str = '"It\'s a test", he said'
        end

        it 'should escape them by prepending them with another single quote' do
          expect(@str.to_pg_s).to eql '\'"It\'\'s a test", he said\''
        end
      end
    end
  end
end
