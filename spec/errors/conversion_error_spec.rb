require "rails_helper"

RSpec.describe ConversionError do
  let(:reason) { :input_value_not_numeric }
  let(:details) { { input_value: "test" } }

  subject(:error) { described_class.new(reason, details) }

  describe "initialization" do
    it "is a StandardError" do
      expect(error).to be_a(StandardError)
    end

    it "sets the reason as a symbol" do
      expect(error.reason).to eq(reason)
      expect(error.reason).to be_a(Symbol)
    end

    it "stores the details hash" do
      expect(error.details).to eq(details)
    end

    it "sets the message to reason.to_s" do
      expect(error.message).to eq(reason.to_s)
    end
  end

  describe "when details are not provided" do
    subject(:error_without_details) { described_class.new(:units_incompatible) }

    it "sets the reason as a symbol" do
      expect(error_without_details.reason).to eq(:units_incompatible)
      expect(error_without_details.reason).to be_a(Symbol)
    end

    it "sets details to an empty hash" do
      expect(error_without_details.details).to eq({})
    end

    it "sets the message correctly" do
      expect(error_without_details.message).to eq("units_incompatible")
    end
  end
end
