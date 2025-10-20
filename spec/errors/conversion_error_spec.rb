require "rails_helper"

RSpec.describe ConversionError do
  let(:reason) { :input_value_not_numeric }

  subject(:error) { described_class.new(reason) }

  describe "initialization" do
    it "is a StandardError" do
      expect(error).to be_a(StandardError)
    end

    it "sets the reason as a symbol" do
      expect(error.reason).to eq(reason)
      expect(error.reason).to be_a(Symbol)
    end

    it "sets the message to reason.to_s" do
      expect(error.message).to eq(reason.to_s)
    end
  end

  describe "when details are not provided" do
    subject(:unit_compatible_error) { described_class.new(:units_incompatible) }

    it "sets the reason as a symbol" do
      expect(unit_compatible_error.reason).to eq(:units_incompatible)
      expect(unit_compatible_error.reason).to be_a(Symbol)
    end

    it "sets the message correctly" do
      expect(unit_compatible_error.message).to eq("units_incompatible")
    end
  end
end
