module Tusks
  class ::Array
    def to_pg_s
      array_string = 'ARRAY['

      self.each do |element|
        raise TypeError.new 'Unsupported Postgres type: ' + element.class.to_s unless element.respond_to? :to_pg_s
        raise TypeError.new 'Nested arrays not yet supported' if element.is_a? Array

        array_string << element.to_pg_s << ','
      end

      array_string.chomp(',') << ']'
    end
  end
end
