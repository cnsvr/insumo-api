# frozen_string_literal: true

module ClientErrors
  class Forbidden < ClientBaseError
    def initialize(message, code, data)
      super(403, message, code, data)
    end
  end
end
