require 'rails_helper'

RSpec.describe Units::Converters::VolumeConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts LITERS to CUPS" do
      expect(converter.convert(1, "liters", "cups").round(2)).to eq(4.23)
    end

    it "converts LITERS to TABLESPOONS" do
      expect(converter.convert(0.5, "LITERS", "tablespoons").round(2)).to eq(33.81)
    end

    it "converts LITERS to CUBIC-INCHES" do
      expect(converter.convert(9, "LITERS", "Cubic-INCHES").round(2)).to eq(549.21)
    end

    it "converts LITERS to CUBIC-FEET" do
      expect(converter.convert(158.76, "LITERS", "CUBIC-FEET").round(2)).to eq(5.61)
    end

    it "converts LITERS to GALLONS" do
      expect(converter.convert(42, "LITERS", "GALLONS").round(2)).to eq(11.1)
    end

    it "converts TABLESPOONS to GALLONSlons" do
      expect(converter.convert(256, "TABLESPOONS", "GALLONS").round(2)).to eq(1.0)
    end

    it "converts TABLESPOONS to LITERS" do
      expect(converter.convert(2, "tablespoons", "LITERS").round(2)).to eq(0.03)
    end

    it "converts TABLESPOONS to CUBIC-INCHES" do
      expect(converter.convert(666, "TABLESPOONS", "CUBIC-inches").round(2)).to eq(600.96)
    end

    it "converts TABLESPOONS to CUPS" do
      expect(converter.convert(10567, "TABLESPOONS", "CUPS").round(2)).to eq(660.44)
    end

    it "converts CUBIC-INCHES to CUPS" do
      expect(converter.convert(549, "Cubic-inches", "CUPS").round(2)).to eq(38.03)
    end

    it "converts CUBIC-INCHES to LITERS" do
      expect(converter.convert(78.9, "cubic-inches", "LITERS").round(2)).to eq(1.29)
    end

    it "converts CUBIC-INCHES to TABLESPOONS" do
      expect(converter.convert(0.05, "CUBIC-INCHES", "TABLESPOONS").round(2)).to eq(0.06)
    end

    it "converts CUBIC-INCHES to CUBIC-FEET" do
      expect(converter.convert(999, "CUBIC-INCHES", "CUBIC-FEET").round(2)).to eq(0.58)
    end

    it "converts CUBIC-INCHES to GALLONS" do
      expect(converter.convert(3541, "CUBIC-INCHES", "GALLONS").round(2)).to eq(15.33)
    end

    it "converts CUBIC-FEET to GALLONS" do
      expect(converter.convert(3541, "CUBIC-FEET", "GALLONS").round(2)).to eq(26488.49)
    end

    it "converts CUBIC-FEET to LITERS" do
      expect(converter.convert(13, "CUBIC-FEET", "LITERS").round(2)).to eq(368.12)
    end

    it "converts CUBIC-FEET to CUBIC-INCHES" do
      expect(converter.convert(874, "CUBIC-FEET", "CUBIC-INCHES").round(2)).to eq(1510266.2)
    end

    it "converts CUBIC-FEET to TABLESPOONS" do
      expect(converter.convert(8, "CUBIC-FEET", "TABLESPOONS").round(2)).to eq(15320.04)
    end

    it "converts CUBIC-FEET to CUPS" do
      expect(converter.convert(48.25, "CUBIC-FEET", "CUPS").round(2)).to eq(5774.96)
    end

    it "converts GALLONS to CUPS" do
      expect(converter.convert(0.11, "GALLONS", "CUPS").round(2)).to eq(1.76)
    end

    it "converts GALLONS to LITERS" do
      expect(converter.convert(573, "GALLONS", "LITERS").round(2)).to eq(2169.04)
    end

    it "converts GALLONS to TABLESPOONS" do
      expect(converter.convert(1, "GALLONS", "TABLESPOONS").round(2)).to eq(256.0)
    end

    it "converts GALLONS to CUBIC-INCHES" do
      expect(converter.convert(34.87, "GALLONS", "CUBIC-INCHES").round(2)).to eq(8054.95)
    end

    it "converts GALLONS to CUBIC-FEET" do
      expect(converter.convert(145752, "GALLONS", "CUBIC-FEET").round(2)).to eq(19484.23)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(1, "banana", "LITERS") }.to raise_error(ArgumentError)
    end
  end
end
