# frozen_string_literal: true

module Errors
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
end
