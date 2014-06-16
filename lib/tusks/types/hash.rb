module Tusks
  class ::Hash
    def to_pg_s
      self.to_json
    end
  end
end
