require 'rails_helper'

RSpec.describe Units::VolumeConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts liters to cups" do
      expect(converter.convert(1, "L", "CUPS").round(2)).to eq(4.23)
    end

    it "converts liters to tbsp" do
      expect(converter.convert(0.5, "L", "TBSP").round(2)).to eq(33.81)
    end

    it "converts liters to in3" do
      expect(converter.convert(9, "L", "IN3").round(2)).to eq(549.21)
    end

    it "converts liters to ft3" do
      expect(converter.convert(158.76, "L", "FT3").round(2)).to eq(5.61)
    end

    it "converts liters to gal" do
      expect(converter.convert(42, "L", "GAL").round(2)).to eq(11.1)
    end

    it "converts tablespoons to gallons" do
      expect(converter.convert(256, "TBSP", "GAL").round(2)).to eq(1.0)
    end

    it "converts tablespoons to L" do
      expect(converter.convert(2, "TBSP", "L").round(2)).to eq(0.03)
    end

    it "converts tablespoons to IN3" do
      expect(converter.convert(666, "TBSP", "IN3").round(2)).to eq(600.96)
    end

    it "converts tablespoons to CUPS" do
      expect(converter.convert(10567, "TBSP", "CUPS").round(2)).to eq(660.44)
    end

    it "converts cubic-inch to CUPS" do
      expect(converter.convert(549, "IN3", "CUPS").round(2)).to eq(38.03)
    end

    it "converts cubic-inch to L" do
      expect(converter.convert(78.9, "IN3", "L").round(2)).to eq(1.29)
    end

    it "converts cubic-inch to TBSP" do
      expect(converter.convert(0.05, "IN3", "TBSP").round(2)).to eq(0.06)
    end

    it "converts cubic-inch to FT3" do
      expect(converter.convert(999, "IN3", "FT3").round(2)).to eq(0.58)
    end

    it "converts cubic-inch to GAL" do
      expect(converter.convert(3541, "IN3", "GAL").round(2)).to eq(15.33)
    end

    it "converts cubic-foot to GAL" do
      expect(converter.convert(3541, "FT3", "GAL").round(2)).to eq(26488.49)
    end

    it "converts cubic-foot to L" do
      expect(converter.convert(13, "FT3", "L").round(2)).to eq(368.12)
    end

    it "converts cubic-foot to IN3" do
      expect(converter.convert(874, "FT3", "IN3").round(2)).to eq(1510266.2)
    end

    it "converts cubic-foot to TBSP" do
      expect(converter.convert(8, "FT3", "TBSP").round(2)).to eq(15320.04)
    end

    it "converts cubic-foot to CUPS" do
      expect(converter.convert(48.25, "FT3", "CUPS").round(2)).to eq(5774.96)
    end

    it "converts gallon to CUPS" do
      expect(converter.convert(0.11, "GAL", "CUPS").round(2)).to eq(1.76)
    end

    it "converts gallon to L" do
      expect(converter.convert(573, "GAL", "L").round(2)).to eq(2169.04)
    end

    it "converts gallon to TBSP" do
      expect(converter.convert(1, "GAL", "TBSP").round(2)).to eq(256.0)
    end

    it "converts gallon to IN3" do
      expect(converter.convert(34.87, "GAL", "IN3").round(2)).to eq(8054.95)
    end

    it "converts gallon to FT3" do
      expect(converter.convert(145752, "GAL", "FT3").round(2)).to eq(19484.23)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(1, "banana", "liters") }.to raise_error(ArgumentError)
    end
  end
end
