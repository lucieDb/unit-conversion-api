require 'rails_helper'

RSpec.describe Units::TemperatureConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts Celsius to Kelvin" do
      expect(converter.convert(0, "C", "K").round(2)).to eq(273.15)
    end

    it "converts Fahrenheit to Rankine" do
      result = converter.convert(84.2, "F", "R")
      expect(result.round(2)).to eq(543.87)
    end

    it "converts Kelvin to Fahrenheit" do
      result = converter.convert(273.15, "K", "F")
      expect(result.round(2)).to eq(32.0)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(10, "X", "C") }.to raise_error(ArgumentError)
    end
  end
end
