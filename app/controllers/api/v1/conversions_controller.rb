module Api
  module V1
    class ConversionsController < ApplicationController
      # in : {
      #   "responses": [
      #     { "input_value": 84.2, "source_unit": "Fahrenheit", "target_unit": "Rankine", "student_answer": 543.87 },
      #     { "input_value": 317.33, "source_unit": "Kelvin", "target_unit": "Fahrenheit", "student_answer": 111.554 },
      #     { "input_value": 73.12, "source_unit": "Gallon", "target_unit": "Celsius", "student_answer": 19.4 }
      #   ]
      # }
      # out :
      #       {
      #   "results": [
      #     {
      #       "input_value": 84.2,
      #       "source_unit": "Fahrenheit",
      #       "target_unit": "Rankine",
      #       "student_answer": 543.87,
      #       "correct_answer": 543.87,
      #       "result": "correct"
      #     },
      #     {
      #       "input_value": 317.33,
      #       "source_unit": "Kelvin",
      #       "target_unit": "Fahrenheit",
      #       "student_answer": 111.554,
      #       "correct_answer": 111.55,
      #       "result": "incorrect"
      #     },
      #     {
      #       "input_value": 73.12,
      #       "source_unit": "Gallon",
      #       "target_unit": "Celsius",
      #       "student_answer": 19.4,
      #       "result": "invalid",
      #       "reason": "units_incompatible",
      #       "message": "Source and target units are not compatible."
      #     }
      #   ]
      # }

      # POST /api/v1/convert_batch
      def batch_create
        responses = params[:responses] || []
        results = responses.map do |response|
          # ** => unpacks the hash in keywords arguments for the service
          ConversionService.new(**extract_conversion_params(response)).call
        end

        binding.pry
        render json: { results: results }, status: :ok
      rescue StandardError => e
        Rails.logger.error("Batch conversion error: #{e.full_message}")
        render json: { error: "internal_error", message: e.message }, status: :internal_server_error
      end

      private

      def extract_conversion_params(response)
        response.permit(:input_value, :source_unit, :target_unit, :student_answer)
                .to_h
                .symbolize_keys
      end
    end
  end
end
