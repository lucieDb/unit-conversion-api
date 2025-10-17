require 'rails_helper'

RSpec.describe "API::V1::Conversions", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:params) do
    {
      input_value: input_value,
      source_unit: source_unit,
      target_unit: target_unit,
      student_answer: student_answer
    }.to_json
  end

  subject(:api_response) do
    post "/api/v1/convert", params: params, headers: headers
    response
  end

  let(:json) { JSON.parse(api_response.body) }

  shared_examples "returns the expected result" do |expected_result, expected_reason = nil, expected_status = :ok|
    it "returns #{expected_result} with proper HTTP status" do
      expect(api_response).to have_http_status(expected_status)
      expect(json["result"]).to eq(expected_result)
      expect(json["reason"]).to eq(expected_reason) if expected_reason
    end
  end

  describe "POST /api/v1/convert" do
    context "when student answer is correct (temperature)" do
      let(:input_value) { 84.2 }
      let(:source_unit) { "F" }
      let(:target_unit) { "R" }
      let(:student_answer) { 543.87 }

      include_examples "returns the expected result", "correct"
    end

    context "when student answer is correct (volume)" do
      let(:input_value) { 4 }
      let(:source_unit) { "tbsp" }
      let(:target_unit) { "cups" }
      let(:student_answer) { 0.25 }

      include_examples "returns the expected result", "correct"
    end

    context "when student answer is incorrect (temperature)" do
      let(:input_value) { 489.76 }
      let(:source_unit) { "in3" }
      let(:target_unit) { "ft3" }
      let(:student_answer) { 1 }

      include_examples "returns the expected result", "incorrect"
    end

    context "when student answer is incorrect (volume)" do
      let(:input_value) { 317.33 }
      let(:source_unit) { "K" }
      let(:target_unit) { "F" }
      let(:student_answer) { 111.554 }

      include_examples "returns the expected result", "incorrect"
    end

    context "when units are incompatible (volume to temperature)" do
      let(:input_value) { 73.12 }
      let(:source_unit) { "gal" }
      let(:target_unit) { "C" }
      let(:student_answer) { 19.4 }

      include_examples "returns the expected result", "invalid", "units_incompatible", :unprocessable_entity
    end

    context "when units are incompatible (temperature to volume)" do
      let(:input_value) { 0.12 }
      let(:source_unit) { "R" }
      let(:target_unit) { "L" }
      let(:student_answer) { 8942 }

      include_examples "returns the expected result", "invalid", "units_incompatible", :unprocessable_entity
    end

    context "when student answer is not numeric" do
      let(:input_value) { 6.5 }
      let(:source_unit) { "F" }
      let(:target_unit) { "R" }
      let(:student_answer) { "cat" }

      include_examples "returns the expected result", "incorrect"
    end
  end
end
