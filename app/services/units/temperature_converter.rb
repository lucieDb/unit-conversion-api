# Class : transform the value with the new unit
# Pivot unit => unit reference : Kelvin. Any unit is converted to this unit,
# then from this unit. Avoid multiplying calculations
# K => Kelvin
# C => Celsius
# F => Fahrenheit
# R => Rankine
module Units
  class TemperatureConverter
    def convert(value, from, to)
      k = to_kelvin(value, from)
      from_kelvin(k, to)
    end

    private

    def to_kelvin(value, from)
      case normalize(from)
      when "K" then value
      when "C" then value + 273.15
      when "F" then (value - 32) * 5.0 / 9.0 + 273.15
      when "R" then value * 5.0 / 9.0
      else raise ArgumentError, "Unknown temperature unit: #{from}"
      end
    end

    def from_kelvin(value, to)
      case normalize(to)
      when "K" then value
      when "C" then value - 273.15
      when "F" then (value - 273.15) * 9.0 / 5.0 + 32
      when "R" then value * 9.0 / 5.0
      else raise ArgumentError, "Unknown temperature unit: #{to}"
      end
    end

    def normalize(unit)
      unit.to_s.strip.upcase
    end
  end
end
