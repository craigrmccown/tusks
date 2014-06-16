module Tusks
  class ::String
    def to_pg_s
      "'" + self.gsub("'") {"''"} + "'"
    end
  end
end
