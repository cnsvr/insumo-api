# frozen_string_literal: true

module ClientErrors
  class Authorization < ClientBaseError
    def initialize(message, code, data)
      super(401, message, code, data)
    end
  end
end
