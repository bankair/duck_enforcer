# encoding: utf-8

class DuckEnforcer
  # This module holds the DuckEnforcer version information.
  module Version
    STRING = '1.0.0'

    module_function

    def version(_debug = false)
      STRING
    end
  end
end
