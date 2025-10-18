require "rails_helper"

RSpec.describe ConversionService do
  describe "#call" do
    subject(:service_call) do
      described_class.new(
        input_value: input_value,
        source_unit: source_unit,
        target_unit: target_unit,
        student_answer: student_answer
      ).call
    end

    shared_examples "a conversion verdict" do |expected_result|
      it "returns #{expected_result}" do
        expect(service_call[:result]).to eq(expected_result)
      end
    end

    context "when student answer matches the correct conversion" do
      context "for temperature units" do
        let(:input_value) { "84.2" }
        let(:source_unit) { "Fahrenheit" }
        let(:target_unit) { "RANKINE" }
        let(:student_answer) { "543.87" }

        include_examples "a conversion verdict", "correct"
      end

      context "for volume units" do
        let(:input_value) { "25.6" }
        let(:source_unit) { "cups" }
        let(:target_unit) { "Liters" }
        let(:student_answer) { "6.059" }

        include_examples "a conversion verdict", "correct"
      end
    end

    context "when student answer is numerically wrong" do
      let(:input_value) { "317.33" }
      let(:source_unit) { "KELVIN" }
      let(:target_unit) { "Fahrenheit" }
      let(:student_answer) { "111.554" }

      include_examples "a conversion verdict", "incorrect"
    end

    context "when units are incompatible" do
      let(:input_value) { "73.12" }
      let(:source_unit) { "gallons" }
      let(:target_unit) { "kelvin" }
      let(:student_answer) { "19.4" }

      include_examples "a conversion verdict", "invalid"
    end

    context "when student answer is not numeric" do
      let(:input_value) { "6.5" }
      let(:source_unit) { "Fahrenheit" }
      let(:target_unit) { "Rankine" }
      let(:student_answer) { "cat" }

      include_examples "a conversion verdict", "incorrect"
    end

    context "when units are incompatible" do
      let(:input_value) { "10" }
      let(:source_unit) { "liters" }
      let(:target_unit) { "Celsius" }
      let(:student_answer) { "10" }

      include_examples "a conversion verdict", "invalid"
    end
  end
end
