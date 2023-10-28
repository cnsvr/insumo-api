# frozen_string_literal: true

module ClientErrors
  class NotFound < ClientBaseError
    def initialize(message, code, data)
      super(404, message, code, data)
    end
  end
end
