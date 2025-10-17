# Class : transform the value with the new unit
module Units
  class VolumeConverter
    FACTORS_TO_LITER = {
      "L" => 1.0,
      "TBSP" => 0.0147868,
      "IN3" => 0.0163871,
      "CUPS" => 0.236588,
      "FT3" => 28.3168,
      "GAL" => 3.78541
    }

    def convert(value, from, to)
      from_u = normalize(from)
      to_u = normalize(to)
      raise ArgumentError, "Unknown volume unit" unless FACTORS_TO_LITER[from_u] && FACTORS_TO_LITER[to_u]

      liters = value * FACTORS_TO_LITER[from_u]
      liters / FACTORS_TO_LITER[to_u]
    end

    private

    def normalize(unit)
      unit.to_s.strip.upcase
    end
  end
end
