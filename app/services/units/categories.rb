module Units
  module Categories
    DATA = {
      temperature: {
        units: %w[KELVIN CELSIUS FAHRENHEIT RANKINE],
        converter: -> { Units::Converters::TemperatureConverter.new }
      },
      volume: {
        units: %w[LITER TABLESPOON CUBIC-INCH CUPS CUBIC-FOOT GALLON],
        converter: -> { Units::Converters::VolumeConverter.new }
      }
    }.freeze
  end
end
