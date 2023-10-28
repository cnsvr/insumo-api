# frozen_string_literal: true

module ServerErrors
  class InternalServerError < BaseError
    def initialize(message, code, data)
      super(500, message, code, data)
    end
  end
end
