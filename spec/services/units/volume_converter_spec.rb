require 'rails_helper'

RSpec.describe Units::VolumeConverter do
  subject(:converter) { described_class.new }

  describe "#convert" do
    it "converts liters to cups" do
      expect(converter.convert(1, "L", "CUPS").round(2)).to eq(4.23)
    end

    it "converts tablespoons to gallons" do
      expect(converter.convert(256, "TBSP", "GAL").round(2)).to eq(1.0)
    end

    it "raises error for unknown unit" do
      expect { converter.convert(1, "banana", "liters") }.to raise_error(ArgumentError)
    end
  end
end
