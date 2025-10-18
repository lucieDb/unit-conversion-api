require 'rails_helper'

RSpec.describe Units::Registry do
  describe ".compatible?" do
    it "returns true for compatible temperature units" do
      expect(described_class.compatible?("cElsiuS", "FAHRENHEIT")).to be true
      expect(described_class.compatible?("KELVIN", "RANKINE")).to be true
    end

    it "returns true for compatible volume units" do
      expect(described_class.compatible?("Liters", "CUPS")).to be true
    end

    it "returns false for incompatible units" do
      expect(described_class.compatible?("CELSIUS", "liters")).to be false
      expect(described_class.compatible?("FAHRENHEIT", "tablespoons")).to be false
    end
  end

    describe ".converter_for" do
    it "returns TemperatureConverter for temperature units" do
      expect(described_class.converter_for(:temperature)).to be_a(Units::Converters::TemperatureConverter)
    end

    it "returns VolumeConverter for volume units" do
      expect(described_class.converter_for(:volume)).to be_a(Units::Converters::VolumeConverter)
    end
  end
end
