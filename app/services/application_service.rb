# frozen_string_literal: true

class ApplicationService
  attr_accessor :status, :errors, :result

  def self.call(*, &)
    service = new(*, &)
    if service.valid?
      service.result = service.call
      service.status = :success unless service.status == :fail
    end
    service
  end

  def initialize(*_args)
    self.status = :not_run
    self.errors = []
    self.result = nil
  end

  def valid?
    validate if respond_to?(:validate)
    status != :fail
  end

  def succeeded?
    status == :success
  end

  def failed?
    status != :success
  end

  protected

  def add_error(error)
    self.status = :fail
    errors << error
  end
end
