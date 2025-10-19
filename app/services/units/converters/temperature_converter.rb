# Class: transform the input_value with the target_unit
# Pivot unit => unit reference: Kelvin. Any unit (source_unit) is converted to this unit (Kelvin),
# then from this unit (Kelvin) to the target_unit. Avoid multiplying calculations.
# input_value: float or integer
# source_unit: string
# target_unit: string
module Units
  module Converters
    class TemperatureConverter
      include NormalizationHelper

      def convert(input_value, source_unit, target_unit)
        value = input_value.to_f
        kelvin = to_kelvin(value, source_unit)
        from_kelvin(kelvin, target_unit)
      end

      private

      def to_kelvin(value, source_unit)
        case normalize(source_unit)
        when "KELVIN" then value
        when "CELSIUS" then value + 273.15
        when "FAHRENHEIT" then (value - 32) * 5.0 / 9.0 + 273.15
        when "RANKINE" then value * 5.0 / 9.0
        else
          handle_unknown_unit(normalize(source_unit))
        end
      end

      def from_kelvin(value, target_unit)
        case normalize(target_unit)
        when "KELVIN" then value
        when "CELSIUS" then value - 273.15
        when "FAHRENHEIT" then (value - 273.15) * 9.0 / 5.0 + 32
        when "RANKINE" then value * 9.0 / 5.0
        else
          handle_unknown_unit(normalize(target_unit))
        end
      end

      def handle_unknown_unit(unit)
        Rails.logger.error("Unknown temperature unit: #{unit}")
        raise ArgumentError, "Unknown temperature unit: #{unit}"
      end
    end
  end
end
