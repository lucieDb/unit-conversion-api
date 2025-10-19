# Class : give information about units
module Units
  class Registry
    extend NormalizationHelper

    # Check if it's a good comparison, not mixed between volume unit and temperature unit
    # Return true if compatible, false otherwise
    def self.compatible?(source_unit, target_unit)
      source_category = category_of(source_unit)
      target_category = category_of(target_unit)
      source_category && (source_category == target_category)
    end

    # Return the category name of the unit
    def self.category_of(unit)
      normalized = normalize(unit)
      category = Categories::DATA.find { |_, data| data[:units].include?(normalized) }&.first
      raise ArgumentError, "Unknown unit: #{unit}" unless category
      category
    end

    # Return the converter category
    def self.converter_for(category)
      raise ArgumentError, "Unknown category: #{category}" unless Categories::DATA.key?(category)
      Categories::DATA[category][:converter].call
    end
  end
end
