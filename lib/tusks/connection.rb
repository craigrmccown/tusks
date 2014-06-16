module Tusks
  class Connection
    def initialize(options = {})
      @options = options
      @in_transaction = false
    end

    def connected?
      !(@conn.nil? || @conn.finished?)
    end

    def in_transaction?
      @in_transaction
    end

    def begin_transaction
      connect
      @conn.exec("BEGIN TRANSACTION")
      @in_transaction = true
    end

    def commit_transaction
      if in_transaction?
        @conn.exec("COMMIT TRANSACTION")
        disconnect
      end
    end

    def rollback_transaction
      if in_transaction?
        @conn.exec("ROLLBACK TRANSACTION")
        disconnect
      end
    end

    def functions(&block)
      instance_eval &block
    end

    private

    def connect
      disconnect if connected?
      @conn = PG.connect(@options)
    end

    def disconnect
      @conn.close if connected?
      @in_transaction = false
    end

    def execute_function(sproc_name, *args)
      connect if !connected?
      @conn.exec(build_sql_string(sproc_name, *args))
      disconnect
    end

    def build_sql_string(sproc_name, *args)
      arg_str = ''
      args.each do |arg|
        raise UnsupportedTypeError.new 'Unsupported type: ' + arg.class.to_s unless arg.respond_to? :to_pg_s
        arg_str = (arg_str.empty? && arg.to_pg_s) || [arg_str, arg.to_pg_s].join(',')
      end
      "SELECT * FROM #{sproc_name}(#{arg_str})"
    end

    def no_results(*sproc_names)
      sproc_names.each do |sproc_name|
        define_singleton_method(sproc_name) do |*args|
          execute_function(sproc_name, *args)
        end
      end
    end

    def one_result(*sproc_names)
      sproc_names.each do |sproc_name|
        define_singleton_method(sproc_name) do |*args|
          result = execute_function(sproc_name, *args)
          result[0]
        end
      end
    end

    def many_results(*sproc_names)
      sproc_names.each do |sproc_name|
        define_singleton_method(sproc_name) do |*args|
          results = execute_function(sproc_name, *args)
          result_array = []
          results.each { |row| result_array << row }
          result_array
        end
      end
    end
  end
end
