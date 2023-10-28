# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def json_response(object, status = :ok)
    render json: object, status:
  end
end
