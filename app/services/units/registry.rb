# Class : give information about units
module Units
  class Registry
    # TODO : refacto CATEGORIES in another file ?
    CATEGORIES = {
      temperature: {
        # K => Kelvin
        # C => Celsius
        # F => Fahrenheit
        # R => Rankine
        units: %w[K C F R],
        converter: -> { Units::TemperatureConverter.new }
      },
      volume: {
        # L => Liter
        # cups => Cups
        # gall => Gallon
        # tbsp => Tablespoon
        # in3 => Cubic-inch
        # ft3 => Cubic-foot
        units: %w[L tbsp in3 cups ft3 gal],
        converter: -> { Units::VolumeConverter.new }
      }
    }

    # Check if it's a good comparison, not mixed between volume unit and temperature unit
    def self.compatible?(source_unit, target_unit)
      category_of(source_unit) && (category_of(source_unit) == category_of(target_unit))
    end

    # Return the category name of the unit
    def self.category_of(unit)
      CATEGORIES.find { |_, data| data[:units].include?(unit) }&.first
    end

    def self.converter_for(category)
      CATEGORIES[category][:converter].call
    end

    # TODO : more search
    # Standardization of the input unit
    # e.g:normalize(" GAL ") => "gal"
    # def self.normalize(unit)
    #   unit.to_s.strip[0].upcase == "K" ? "K" : unit.to_s.strip.downcase.gsub(/\s+/, "").sub(/^°/, "")
    # end
  end
end
