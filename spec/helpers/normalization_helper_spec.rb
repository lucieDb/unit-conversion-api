require "rails_helper"

RSpec.describe NormalizationHelper do
  # fake class to include the helper
  let(:fake_class) { Class.new { include NormalizationHelper }.new }

  describe "#normalize" do
    it "convert to uppercase" do
      expect(fake_class.normalize("liter")).to eq("LITER")
    end

    it "remove spaces around the string" do
      expect(fake_class.normalize("  gram  ")).to eq("GRAM")
    end

    it "convert nil to an empty string" do
      expect(fake_class.normalize(nil)).to eq("")
    end

    it "handle numbers" do
      expect(fake_class.normalize(123)).to eq("123")
    end

    it "no changes in normalized string" do
      expect(fake_class.normalize("LITER")).to eq("LITER")
    end
  end
end
