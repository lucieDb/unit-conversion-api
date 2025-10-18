# Class : transform the value with the new unit
# Pivot unit => unit reference : Liter. Any unit is converted to this unit,
# then from this unit. Avoid multiplying calculations
module Units
  module Converters
    class VolumeConverter
      include NormalizationHelper

      # Conversion factors to the base unit (1 unit = X liters)
      FACTORS_TO_LITER = {
        "LITER" => 1.0,
        "TABLESPOONE" => 0.0147868,
        "CUBIC-INCH" => 0.0163871,
        "CUPS" => 0.236588,
        "CUBIC-FOOT" => 28.3168,
        "GALLON" => 3.78541
      }

      def convert(input_value, source_unit, target_unit)
        from_unit = normalize(source_unit)
        to_unit = normalize(target_unit)
        raise ArgumentError, "Unknown volume unit" unless FACTORS_TO_LITER[from_unit] && FACTORS_TO_LITER[to_unit]

        liters = input_value * FACTORS_TO_LITER[from_unit]
        liters / FACTORS_TO_LITER[to_unit]
      end
    end
  end
end
