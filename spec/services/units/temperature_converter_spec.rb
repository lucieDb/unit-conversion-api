require 'rails_helper'

RSpec.describe Units::TemperatureConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts Celsius to Kelvin" do
      expect(converter.convert(0, "C", "K").round(2)).to eq(273.15)
    end

    it "converts negative Celsius to Kelvin" do
      expect(converter.convert(-12, "C", "K").round(2)).to eq(261.15)
    end

    it "converts Celsius to Fahrenheit" do
      expect(converter.convert(37.5, "C", "F").round(2)).to eq(99.5)
    end

    it "converts Celsius to Rankine" do
      expect(converter.convert(11, "C", "R").round(2)).to eq(511.47)
    end

    it "converts Fahrenheit to Rankine" do
      result = converter.convert(84.2, "F", "R")
      expect(result.round(2)).to eq(543.87)
    end

    it "converts negative Fahrenheit to Rankine" do
      result = converter.convert(-248.9, "F", "R")
      expect(result.round(2)).to eq(210.77)
    end

    it "converts Fahrenheit to Kelvin" do
      result = converter.convert(108.94, "F", "K")
      expect(result.round(2)).to eq(315.89)
    end

    it "converts Fahrenheit to Celsius" do
      result = converter.convert(39, "F", "C")
      expect(result.round(2)).to eq(3.89)
    end

    it "converts Kelvin to Fahrenheit" do
      result = converter.convert(273.15, "K", "F")
      expect(result.round(2)).to eq(32.0)
    end

    it "converts Kelvin to Celsius" do
      result = converter.convert(300.05, "K", "C")
      expect(result.round(2)).to eq(26.9)
    end

    it "converts Kelvin to Rankine" do
      result = converter.convert(248.99, "K", "R")
      expect(result.round(2)).to eq(448.18)
    end

    it "converts Kelvin to Rankine" do
      result = converter.convert(-9, "K", "R")
      expect(result.round(2)).to eq(-16.2)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(10, "X", "C") }.to raise_error(ArgumentError)
    end
  end
end
