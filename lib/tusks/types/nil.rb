module Tusks
  class ::NilClass
    def to_pg_s
      'NULL'
    end
  end
end
