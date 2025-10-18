require 'rails_helper'

RSpec.describe Units::Converters::TemperatureConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts Celsius to Kelvin" do
      expect(converter.convert(0, "CELSIUS", "KELVIN").round(2)).to eq(273.15)
    end

    it "converts negative Celsius to Kelvin" do
      expect(converter.convert(-12, "CELSIUS", "KELVIN").round(2)).to eq(261.15)
    end

    it "converts Celsius to Fahrenheit" do
      expect(converter.convert(37.5, "celsius", "Fahrenheit").round(2)).to eq(99.5)
    end

    it "converts Celsius to Rankine" do
      expect(converter.convert(11, "CELSIUS", "RANKINE").round(2)).to eq(511.47)
    end

    it "converts Fahrenheit to Rankine" do
      result = converter.convert(84.2, "FAHRENHEIT", "RANKINE")
      expect(result.round(2)).to eq(543.87)
    end

    it "converts negative Fahrenheit to Rankine" do
      result = converter.convert(-248.9, "FAHRENHEIT", "rankine")
      expect(result.round(2)).to eq(210.77)
    end

    it "converts Fahrenheit to Kelvin" do
      result = converter.convert(108.94, "FAHRENHEIT", "KELVIN")
      expect(result.round(2)).to eq(315.89)
    end

    it "converts Fahrenheit to Celsius" do
      result = converter.convert(39, "FAHRENHEIT", "CELSIUS")
      expect(result.round(2)).to eq(3.89)
    end

    it "converts Kelvin to Fahrenheit" do
      result = converter.convert(273.15, "KelviN", "FAHRENHEIT")
      expect(result.round(2)).to eq(32.0)
    end

    it "converts Kelvin to Celsius" do
      result = converter.convert(300.05, "KELVIN", "CELSIUS")
      expect(result.round(2)).to eq(26.9)
    end

    it "converts Kelvin to Rankine" do
      result = converter.convert(248.99, "KELVIN", "RANKINE")
      expect(result.round(2)).to eq(448.18)
    end

    it "converts negative Kelvin to Rankine" do
      result = converter.convert(-9, "KELVIN", "rankine")
      expect(result.round(2)).to eq(-16.2)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(10, "UniCorn", "Tomatoes") }.to raise_error(ArgumentError)
    end
  end
end
