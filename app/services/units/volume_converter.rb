# Class : transform the value with the new unit
# Pivot unit => unit reference : Liter. Any unit is converted to this unit,
# then from this unit. Avoid multiplying calculations
# L => Liter
# TBSP => Tablespoon
# IN3 => Cubic-inch
# CUPS => Cups
# FT3 => Cubic-foot
# GAL => Gallon
module Units
  class VolumeConverter
    # Conversion factors to the base unit (1 unit = X liters)
    FACTORS_TO_LITER = {
      "L" => 1.0,
      "TBSP" => 0.0147868,
      "IN3" => 0.0163871,
      "CUPS" => 0.236588,
      "FT3" => 28.3168,
      "GAL" => 3.78541
    }

    def convert(input_value, source_unit, target_unit)
      from_unit = normalize(source_unit)
      to_unit = normalize(target_unit)
      raise ArgumentError, "Unknown volume unit" unless FACTORS_TO_LITER[from_unit] && FACTORS_TO_LITER[to_unit]

      liters = input_value * FACTORS_TO_LITER[from_unit]
      liters / FACTORS_TO_LITER[to_unit]
    end

    private

    def normalize(unit)
      unit.to_s.strip.upcase
    end
  end
end
