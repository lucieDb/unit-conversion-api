module Api
  module V1
    class ConversionsController < ApplicationController
      # POST /api/v1/convert
      def create
        result = ConversionService.new(conversion_params).call
        render json: result, status: :ok
      rescue => e
        render json: { error: "internal_error", message: e.message }, status: :internal_server_error
      end

      private

      def conversion_params
        params.permit(:input_value, :source_unit, :target_unit, :student_answer).to_h
      end
    end
  end
end
