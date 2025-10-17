require 'rails_helper'

RSpec.describe Units::Registry do
  describe ".compatible?" do
    it "returns true for compatible temperature units" do
      expect(described_class.compatible?("C", "F")).to be true
      expect(described_class.compatible?("K", "R")).to be true
    end

    it "returns true for compatible volume units" do
      expect(described_class.compatible?("L", "cups")).to be true
    end

    it "returns false for incompatible units" do
      expect(described_class.compatible?("C", "liters")).to be false
      expect(described_class.compatible?("F", "tablespoons")).to be false
    end
  end

    describe ".converter_for" do
    it "returns TemperatureConverter for temperature units" do
      expect(described_class.converter_for(:temperature)).to be_a(Units::TemperatureConverter)
    end

    it "returns VolumeConverter for volume units" do
      expect(described_class.converter_for(:volume)).to be_a(Units::VolumeConverter)
    end
  end
end
