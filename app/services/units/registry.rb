# Class : give information about units
module Units
  class Registry
    extend NormalizationHelper

    # TODO : refacto CATEGORIES in another file ?
    CATEGORIES = {
      temperature: {
        units: %w[KELVIN CELSIUS FAHRENHEIT RANKINE],
        converter: -> { Units::TemperatureConverter.new }
      },
      volume: {
        units: %w[LITER TABLESPOON CUBIC-INCH CUPS CUBIC-FOOT GALLON],
        converter: -> { Units::VolumeConverter.new }
      }
    }

    # Check if it's a good comparison, not mixed between volume unit and temperature unit
    def self.compatible?(source_unit, target_unit)
      category_of(source_unit) && (category_of(source_unit) == category_of(target_unit))
    end

    # Return the category name of the unit
    def self.category_of(unit)
      CATEGORIES.find { |_, data| data[:units].include?(normalize(unit)) }&.first
    end

    def self.converter_for(category)
      CATEGORIES[category][:converter].call
    end
  end
end
