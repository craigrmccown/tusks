require 'spec_helper'

module Tusks
  describe Connection do
    before :each do
      @connection = Connection.new({'key1' => 'value 1', 'key2' => 'value 2'})
    end

    context 'after defining a function interface' do
      before :each do
        @connection.functions do
          no_results :none
          one_result :one
          many_results :many
        end
      end

      it 'should respond to the configured methods' do
        expect(@connection).to respond_to :none
        expect(@connection).to respond_to :one
        expect(@connection).to respond_to :many
      end

      it 'should only define methods on the connection instance that is configured' do
        expect { Connection.new.none }.to raise_error NoMethodError
        expect { Connection.new.one }.to raise_error NoMethodError
        expect { Connection.new.many }.to raise_error NoMethodError
      end

      context 'a method defined by #no_results' do
        before :each do
          allow(@connection).to receive(:execute_function)
        end

        it 'should return nil' do
          expect(@connection.none).to be_nil
        end

        it 'should execute the function with the correct name and arguments' do
          expect(@connection).to receive(:execute_function).with(:none, 'arg 1', 'arg 2') 
          @connection.none('arg 1', 'arg 2')
        end
      end

      context 'a method defined by #one_result' do
        it 'should execute the function with the correct name and arguments' do
          allow(@connection).to receive(:execute_function).and_return([])
          expect(@connection).to receive(:execute_function).with(:one, 'arg 1', 'arg 2')
          @connection.one('arg 1', 'arg 2')
        end

        context 'that has results' do
          before :each do
            allow(@connection).to receive(:execute_function).and_return([{
              'key 1' => 'value 1',
              'key 2' => 'value 2'
            }])
          end

          it 'should return the first result returned by the connection' do
            expect(@connection.one).to eql({
              'key 1' => 'value 1',
              'key 2' => 'value 2'
            })
          end
        end

        context 'that has no results' do
          before :each do
            allow(@connection).to receive(:execute_function).and_return([])
          end

          it 'should return nil' do
            expect(@connection.one).to be_nil
          end
        end
      end

      context 'a method defined by #many_results' do
        it 'should execute the function with the correct name and arguments' do
          allow(@connection).to receive(:execute_function).and_return([])
          expect(@connection).to receive(:execute_function).with(:many, 'arg 1', 'arg 2')
          @connection.many('arg 1', 'arg 2')
        end

        context 'that has results' do
          before :each do
            allow(@connection).to receive(:execute_function).and_return([
              {
                'key 1' => 'value 1',
                'key 2' => 'value 2'
              },
              {
                'key 3' => 'value 3',
                'key 4' => 'value 4'
              }
            ])
          end

          it 'should return all results returned by the connection' do
            expect(@connection.many).to eql([
              {
                'key 1' => 'value 1',
                'key 2' => 'value 2'
              },
              {
                'key 3' => 'value 3',
                'key 4' => 'value 4'
              }
            ])
          end
        end

        context 'that has no results' do
          context 'when passed no records' do
            before :each do
              allow(@connection).to receive(:execute_function).and_return []
            end

            it 'should return an empty array' do
              expect(@connection.many).to eql []
            end
          end
        end
      end
    end

    context '#build_sql_string' do
      it 'should raise an error if an unsupported type is passed in' do
        expect { @connection.instance_eval { build_sql_string('function_name', Class.new, 'arg2') }}.to raise_error Tusks::UnsupportedTypeError
      end

      context 'with arguments' do
        it 'should build the proper SQL string' do
          arg1 = double('arg1')
          arg2 = double('arg2')
          allow(arg1).to receive(:to_pg_s).and_return('arg1#to_pg_s')
          allow(arg2).to receive(:to_pg_s).and_return('arg2#to_pg_s')

          expect(@connection.instance_eval {
            build_sql_string(
              'function_name',
              arg1,
              arg2
          )}).to eql 'SELECT * FROM function_name(arg1#to_pg_s,arg2#to_pg_s)'
        end
      end

      context 'without arguments' do
        it 'should build the proper SQL string' do
          expect(@connection.instance_eval { build_sql_string('function_name') }).to eql 'SELECT * FROM function_name()'
        end
      end
    end

    context 'when first created' do
      it 'should set the passed in options as the connection options' do
        expect(@connection.instance_variable_get(:@options)).to eql ({
          'key1' => 'value 1',
          'key2' => 'value 2'
        })
      end

      it 'should not claim to be in a transaction' do
        expect(@connection.in_transaction?).to be false
      end

      it 'should not claim to be connected' do
        expect(@connection.connected?).to be false
      end
    end
  end
end
