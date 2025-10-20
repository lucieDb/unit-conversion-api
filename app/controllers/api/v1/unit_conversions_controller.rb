# in :
# { "studentId" => 0,
#   "responses": [
#     { "input_value": 84.2, "source_unit": "Fahrenheit", "target_unit": "Rankine", "student_answer": 543.87 },
#     { "input_value": 317.33, "source_unit": "Kelvin", "target_unit": "Fahrenheit", "student_answer": 111.554 },
#     { "input_value": 73, "source_unit": "Gallons", "target_unit": "Celsius", "student_answer": 19.4 }
#   ]
# }

# out :
# {studentId: 0,
#  results:
#   [{input_value: "84.2",
#     source_unit: "Fahrenheit",
#     target_unit: "Rankine",
#     correct_answer: 543.87,
#     student_answer: 543.87,
#     result: "correct"},
#   {input_value: "317.33",
#     source_unit: "Kelvin",
#     target_unit: "Fahrenheit",
#     correct_answer: 111.52,
#     student_answer: 76.0,
#     result: "incorrect"},
#   {input_value: "73",
#     source_unit: "Gallons",
#     target_unit: "Celsius",
#     student_answer: "83.56",
#     result: "invalid",
#     reason: :units_incompatible,
#     message: "Source and target units are not compatible."},
#   {input_value: "chat",
#     source_unit: "Liters",
#     target_unit: "Cups",
#     student_answer: "8",
#     result: "invalid",
#     reason: :input_value_not_numeric,
#     message: "Input value must be a valid number."}]}

module Api
  module V1
    class UnitConversionsController < ApplicationController
      # don't want Rails to wrap params under the name of the main object : Conversion
      wrap_parameters false

      # Map exceptions to HTTP status codes
      ERROR_STATUS = {
        ConversionError => :unprocessable_entity,
        ArgumentError   => :bad_request,
        StandardError   => :internal_server_error
      }.freeze

      # Centralized rescue
      ERROR_STATUS.keys.each do |error_class|
        rescue_from error_class, with: :handle_error
      end

      # POST /api/v1/convert_batch
      def batch_create
        responses = params[:responses]
        unless responses.is_a?(Array) && responses.present?
          render json: { error: "invalid_params", message: "responses must be a non-empty array" }, status: :bad_request
          return
        end

        results = responses.map do |response|
          # ** => unpacks the hash in keywords arguments for the service
          UnitConversionService.new(**extract_conversion_params(response)).call
        end

        render json: { studentId: params[:studentId], results: results }, status: :ok
      end

      private

      def handle_error(exception)
        status = ERROR_STATUS[exception.class]
        log_error(exception, status)

        render json: {
          error: exception.class.name.underscore,
          message: exception.message
        }, status: status
      end

      def log_error(exception, status)
        case status
        when :internal_server_error
          Rails.logger.error("Unexpected error: #{exception.full_message}")
        else
          Rails.logger.warn("#{exception.class}: #{exception.message}")
        end
      end

      def extract_conversion_params(response)
        response.permit(:input_value, :source_unit, :target_unit, :student_answer)
                .to_h
                .symbolize_keys
      end
    end
  end
end
