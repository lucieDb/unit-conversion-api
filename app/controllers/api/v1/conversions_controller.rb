module Api
  module V1
    class ConversionsController < ApplicationController
      # POST /api/v1/convert
      def create
        conversion_service = ConversionService.new(
          input_value: params[:input_value],
          source_unit: params[:source_unit],
          target_unit: params[:target_unit],
          student_answer: params[:student_answer]
        )

        result = conversion_service.call

        render json: result, status: :ok
      rescue => e
        render json: { error: "internal_error", message: e.message }, status: :internal_server_error
      end
    end
  end
end
