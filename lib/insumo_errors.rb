# frozen_string_literal: true

module InsumoErrors
  class BaseError < StandardError
    attr_reader :status, :message, :code, :data

    def initialize(status, message, code, data)
      super(message)
      @status = status
      @message = message
      @code = code
      @data = data
    end

    def to_s
      "#{@code}: #{@message}"
    end

    def to_json(*_args)
      {
        status: @status,
        message: @message,
        code: @code,
        data: @data
      }.to_json
    end
  end

  class BadRequest < BaseError
    def initialize(message, code, data)
      super(400, message, code, data)
    end
  end

  class Authorization < BaseError
    def initialize(message, code, data)
      super(401, message, code, data)
    end
  end

  class Forbidden < BaseError
    def initialize(message, code, data)
      super(403, message, code, data)
    end
  end

  class NotFound < BaseError
    def initialize(message, code, data)
      super(404, message, code, data)
    end
  end

  class InternalServerError < BaseError
    def initialize(message, code, data)
      super(500, message, code, data)
    end
  end
end
