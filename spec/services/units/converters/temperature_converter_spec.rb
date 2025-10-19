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
      expect(converter.convert(84.2, "FAHRENHEIT", "RANKINE").round(2)).to eq(543.87)
    end

    it "converts negative Fahrenheit to Rankine" do
      expect(converter.convert(-248.9, "FAHRENHEIT", "rankine").round(2)).to eq(210.77)
    end

    it "converts Fahrenheit to Kelvin" do
      expect(converter.convert(108.94, "FAHRENHEIT", "KELVIN").round(2)).to eq(315.89)
    end

    it "converts Fahrenheit to Celsius" do
      expect(converter.convert(39, "FAHRENHEIT", "CELSIUS").round(2)).to eq(3.89)
    end

    it "converts Kelvin to Fahrenheit" do
      expect(converter.convert(273.15, "KelviN", "FAHRENHEIT").round(2)).to eq(32.0)
    end

    it "converts Kelvin to Celsius" do
      expect(converter.convert(300.05, "KELVIN", "CELSIUS").round(2)).to eq(26.9)
    end

    it "converts Kelvin to Rankine" do
      expect(converter.convert(248.99, "KELVIN", "RANKINE").round(2)).to eq(448.18)
    end

    it "converts Rankine to Fahrenheit" do
      expect(converter.convert(12, "RANKINE", "FAHRENHEIT").round(2)).to eq(-447.67)
    end

    it "converts Rankine to Celsius" do
      expect(converter.convert(300.05, "RANKINE", "CELSIUS").round(2)).to eq(-106.46)
    end

    it "converts Rankine to Kelvin" do
      expect(converter.convert(248.99, "RANKINE", "KELVIN").round(2)).to eq(138.33)
    end

    it "converts negative Kelvin to Rankine" do
      expect(converter.convert(-9, "KELVIN", "rankine").round(2)).to eq(-16.2)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(10, "UniCorn", "Tomatoes") }.to raise_error(ArgumentError)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(10, "Kelvin", "Tomatoes") }.to raise_error(ArgumentError)
    end
  end
end
