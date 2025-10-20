# Service responsible for validating inputs, checking unit compatibility,
# converting values, and determining whether a student's answer is correct, incorrect, or invalid.
# input_value: integer or float or string
# source_unit: string
# target_unit: string
# student_answer: integer or float
class UnitConversionService
  RESULT_CORRECT   = "correct".freeze
  RESULT_INCORRECT = "incorrect".freeze
  RESULT_INVALID   = "invalid".freeze

  attr_reader :input_value, :source_unit, :target_unit, :student_answer

  def initialize(input_value:, source_unit:, target_unit:, student_answer:)
    @input_value = input_value
    @source_unit = source_unit
    @target_unit = target_unit
    @student_answer = student_answer
  end

  def call
    validate_inputs
    correct_rounded, student_rounded = compute_rounded_values
    verdict = determine_verdict(correct_rounded, student_rounded)

    build_response(result: verdict, correct_answer: correct_rounded, student_answer: student_rounded)
  rescue ConversionError => e
    Rails.logger.warn("ConversionError: #{e.reason}")
    build_invalid_response(reason: e.reason)
  end

  private

  def validate_inputs
    raise ConversionError.new(:input_value_not_numeric) unless numeric?(input_value)
    raise ConversionError.new(:units_incompatible) unless units_compatible?
  end

  # accept integer and float
  # Float(73) => 73.0
  # Float("73") => 73.0
  # Float(84.2) => 84.2
  # Float("84.2") => 84.2
  # Float("abc") => ArgumentError
  def numeric?(value)
    Float(value)
    true
  rescue ArgumentError, TypeError
    false
  end

  def units_compatible?
    Units::Registry.compatible?(source_unit, target_unit)
  end

  def compute_rounded_values
    category = Units::Registry.category_of(source_unit)
    converter = Units::Registry.converter_for(category)

    correct_value = converter.convert(input_value.to_f, source_unit, target_unit)
    [ correct_value.round(2), student_answer.to_f.round(2) ]
  end

  def determine_verdict(correct_rounded, student_rounded)
    return RESULT_INCORRECT unless numeric?(student_answer)
    student_rounded == correct_rounded ? RESULT_CORRECT : RESULT_INCORRECT
  end

  def build_response(result:, correct_answer:, student_answer:)
    base_payload.merge(
      correct_answer: correct_answer,
      student_answer: student_answer,
      result: result
    )
  end

  def base_payload
    {
      input_value: input_value,
      source_unit: source_unit,
      target_unit: target_unit
    }
  end

  def build_invalid_response(reason:)
    base_payload.merge(
      student_answer: student_answer,
      result: RESULT_INVALID,
      reason: reason,
      message: ErrorMessages::CONVERSION[reason],
    )
  end
end
