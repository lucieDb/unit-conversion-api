require 'rails_helper'

RSpec.describe "API::V1::Conversions", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  describe "POST /api/v1/convert" do
    it "returns correct when student answer matches expected result" do
      post "/api/v1/convert", params: {
        input_value: 84.2,
        source_unit: "F",
        target_unit: "R",
        student_answer: 543.87
      }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["result"]).to eq("correct")
    end

    it "returns incorrect when answer does not match" do
      post "/api/v1/convert", params: {
        input_value: 317.33,
        source_unit: "K",
        target_unit: "F",
        student_answer: 111.554
      }.to_json, headers: headers

      body = JSON.parse(response.body)
      expect(body["result"]).to eq("incorrect")
    end

    it "returns invalid when units are incompatible" do
      post "/api/v1/convert", params: {
        input_value: 73.12,
        source_unit: "gal",
        target_unit: "C",
        student_answer: 19.4
      }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["result"]).to eq("invalid")
      expect(body["reason"]).to eq("units_incompatible")
    end

    it "returns incorrect when student answer is not numeric" do
      post "/api/v1/convert", params: {
        input_value: 6.5,
        source_unit: "F",
        target_unit: "R",
        student_answer: "cat"
      }.to_json, headers: headers

      body = JSON.parse(response.body)
      expect(body["result"]).to eq("incorrect")
    end
  end
end
