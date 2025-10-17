module Api
  module V1
    class ConversionsController < ApplicationController
      # POST /api/v1/convert
      def create
        # ** => unpacks the hash in keywords arguments for the service
        result = ConversionService.new(**conversion_params).call
        status = result[:result] == "invalid" ? :unprocessable_entity : :ok
        render json: result, status: status

      rescue StandardError => e
        Rails.logger.error("Conversion error: #{e.full_message}")
        render json: { error: "Internal server error", message: e.message }, status: :internal_server_error
      end

      private

      def conversion_params
        params.permit(:input_value, :source_unit, :target_unit, :student_answer)
              .to_h
              .symbolize_keys
      end
    end
  end
end
