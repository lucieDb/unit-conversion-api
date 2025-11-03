# Class : transform the value with the new unit
# Pivot unit => unit reference : Liter. Any unit is converted to this unit,
# then from this unit. Avoid multiplying calculations
# input_value: float or integer
# source_unit: string
# target_unit: string
module Units
  module Converters
    class VolumeConverter
      include NormalizationHelper

      # Conversion factors to the base unit (1 unit = X liters)
      FACTORS_TO_LITER = {
        "LITERS" => 1.0,
        "TABLESPOONS" => 0.0147868,
        "CUBIC-INCHES" => 0.0163871,
        "CUPS" => 0.236588,
        "CUBIC-FEET" => 28.3168,
        "GALLONS" => 3.78541
      }

      def convert(input_value, source_unit, target_unit)
        value = input_value.to_f
        from_unit = normalize(source_unit)
        to_unit = normalize(target_unit)

        unless FACTORS_TO_LITER[from_unit] && FACTORS_TO_LITER[to_unit]
          Rails.logger.error("Unknown volume unit conversion: #{source_unit} -> #{target_unit}")
          raise ArgumentError, "Unknown volume unit: #{source_unit} or #{target_unit}"
        end

        liters = value * FACTORS_TO_LITER[from_unit]
        liters / FACTORS_TO_LITER[to_unit]
      end
    end
  end
end
