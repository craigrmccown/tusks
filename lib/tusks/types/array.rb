module Tusks
  class ::Array
    def to_pg_s
      array_string = 'ARRAY['

      self.each do |element|
        raise UnsupportedTypeError.new 'Unsupported type: ' + element.class.to_s unless element.respond_to? :to_pg_s
        raise NestedArrayError.new 'Nested arrays not yet supported' if element.is_a? Array

        array_string << element.to_pg_s << ','
      end

      array_string.chomp(',') << ']'
    end
  end
end
