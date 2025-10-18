require 'rails_helper'

RSpec.describe "API::V1::Conversions (Batch)", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  subject(:api_response) do
    post "/api/v1/convert_batch", params: params.to_json, headers: headers
    response
  end

  let(:json) { JSON.parse(api_response.body) }
  let(:results) { json["results"] }

  # TODO : factory responses ??
  describe "POST /api/v1/convert_batch" do
    let(:params) do
      {
        responses: [
          {
            input_value: 84.2,
            source_unit: "FAHRENHEIT",
            target_unit: "Rankine",
            student_answer: 543.87
          },
          {
            input_value: 317.33,
            source_unit: "KelviN",
            target_unit: "FAHRENHEIT",
            student_answer: 111.554
          },
          {
            input_value: 73.12,
            source_unit: "gallons",
            target_unit: "CELSIUS",
            student_answer: 19.4
          },
          {
            input_value: "abc",
            source_unit: "FAHRENHEIT",
            target_unit: "Celsius",
            student_answer: 50
          }
        ]
      }
    end

    it "returns HTTP 200" do
      expect(api_response).to have_http_status(:ok)
    end

    it "returns one result per input" do
      expect(results.size).to eq(4)
    end

    it "returns correct, incorrect, and invalid results properly" do
      first = results[0]
      expect(first["result"]).to eq("correct")
      expect(first).to include("correct_answer", "student_answer")

      second = results[1]
      expect(second["result"]).to eq("incorrect")
      expect(second).to include("correct_answer", "student_answer")

      third = results[2]
      expect(third["result"]).to eq("invalid")
      expect(third["reason"]).to eq("units_incompatible")
      expect(third["message"]).to eq("Source and target units are not compatible")

      fourth = results[3]
      expect(fourth["result"]).to eq("invalid")
      expect(fourth["reason"]).to eq("input_value_not_numeric")
      expect(fourth["message"]).to eq("Input value must be a valid number")
    end
  end

  context "when one of the responses causes a crash" do
    let(:params) { { responses: [ {} ] } }

    it "returns a 500 internal error" do
      expect(api_response).to have_http_status(:internal_server_error)
      parsed = JSON.parse(api_response.body)
      expect(parsed["error"]).to eq("internal_error")
    end
  end
end
