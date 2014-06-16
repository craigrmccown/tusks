module Tusks
  class TusksError < StandardError; end
  class NestedArrayError < TusksError; end
  class UnsupportedTypeError < TusksError; end
end
