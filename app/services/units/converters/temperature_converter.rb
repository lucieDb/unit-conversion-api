# Class : transform the value with the new unit
# Pivot unit => unit reference : Kelvin. Any unit is converted to this unit,
# then from this unit. Avoid multiplying calculations
module Units
  module Converters
    class TemperatureConverter
      include NormalizationHelper

      def convert(input_value, source_unit, target_unit)
        kelvin = to_kelvin(input_value, source_unit)
        from_kelvin(kelvin, target_unit)
      end

      private

      def to_kelvin(input_value, source_unit)
        case normalize(source_unit)
        when "KELVIN" then input_value
        when "CELSIUS" then input_value + 273.15
        when "FAHRENHEIT" then (input_value - 32) * 5.0 / 9.0 + 273.15
        when "RANKINE" then input_value * 5.0 / 9.0
        else raise ArgumentError, "Unknown temperature unit: #{source_unit}"
        end
      end

      def from_kelvin(input_value, target_unit)
        case normalize(target_unit)
        when "KELVIN" then input_value
        when "CELSIUS" then input_value - 273.15
        when "FAHRENHEIT" then (input_value - 273.15) * 9.0 / 5.0 + 32
        when "RANKINE" then input_value * 9.0 / 5.0
        else raise ArgumentError, "Unknown temperature unit: #{target_unit}"
        end
      end
    end
  end
end
