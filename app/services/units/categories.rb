module Units
  module Categories
    DATA = {
      temperature: {
        units: %w[KELVIN CELSIUS FAHRENHEIT RANKINE],
        converter: -> { Units::Converters::TemperatureConverter.new }
      },
      volume: {
        units: %w[LITERS TABLESPOONS CUBIC-INCHES CUPS CUBIC-FEET GALLONS],
        converter: -> { Units::Converters::VolumeConverter.new }
      }
    }.freeze
  end
end
