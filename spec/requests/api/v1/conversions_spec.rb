require 'rails_helper'

RSpec.describe "API::V1::Conversions (Batch)", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  subject(:api_response) do
    post "/api/v1/convert_batch", params: params.to_json, headers: headers
    response
  end

  let(:json) { JSON.parse(api_response.body) }
  let(:results) { json["results"] }

  describe "POST /api/v1/convert_batch" do
    let(:params) do
      {
        responses: [
          FactoryBot.build(:conversion),
          FactoryBot.build(:conversion, input_value: 317.33, source_unit: "KelviN", target_unit: "FAHRENHEIT", student_answer: 111.554),
          FactoryBot.build(:conversion, :units_incompatible, input_value: 73.12, student_answer: 19.4),
          FactoryBot.build(:conversion, :invalid_input),
          FactoryBot.build(:conversion, :incorrect_answer)
        ]
      }
    end

    it "returns HTTP 200" do
      expect(api_response).to have_http_status(:ok)
    end

    it "returns one result per input" do
      expect(results.size).to eq(5)
    end

    it "returns correct, incorrect, and invalid results properly" do
      first = results[0]
      expect(first["result"]).to eq("correct")
      expect(first).to include("correct_answer", "student_answer", "input_value", "source_unit", "target_unit", "result")

      second = results[1]
      expect(second["result"]).to eq("incorrect")
      expect(second).to include("correct_answer", "student_answer", "input_value", "source_unit", "target_unit", "result")

      third = results[2]
      expect(third).to include("details", "input_value", "source_unit", "target_unit", "student_answer", "result", "message", "reason")
      expect(third["result"]).to eq("invalid")
      expect(third["reason"]).to eq("units_incompatible")
      expect(third["message"]).to eq("Source and target units are not compatible")

      fourth = results[3]
      expect(fourth).to include("details", "input_value", "source_unit", "target_unit", "student_answer", "result", "message", "reason")
      expect(fourth["result"]).to eq("invalid")
      expect(fourth["reason"]).to eq("input_value_not_numeric")
      expect(fourth["message"]).to eq("Input value must be a valid number")

      fiveth = results[4]
      expect(fiveth["result"]).to eq("incorrect")
      expect(fiveth).to include("correct_answer", "student_answer", "input_value", "source_unit", "target_unit", "result")
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
