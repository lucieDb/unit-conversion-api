# Service responsible for validating inputs, checking unit compatibility,
# converting values, and determining whether a student's answer is correct, incorrect, or invalid.
class ConversionService
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
    return invalid(reason: "input_value_not_numeric") unless numeric?(input_value)
    return invalid(reason: "units_incompatible") unless units_compatible?
    return incorrect(reason: "student_answer_not_numeric") unless numeric?(student_answer)

    correct_rounded, student_rounded = compute_rounded_values
    verdict = (student_rounded == correct_rounded) ? RESULT_CORRECT : RESULT_INCORRECT

    success(result: verdict, correct_answer: correct_rounded, student_answer: student_rounded)
  end

  private

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

  def base_payload
    {
      input_value: input_value.to_f,
      source_unit: source_unit,
      target_unit: target_unit
    }
  end

  def success(result:, correct_answer:, student_answer:)
    base_payload.merge(
      correct_answer: correct_answer,
      student_answer: student_answer,
      result: result
    )
  end

  def incorrect(reason:)
    base_payload.merge(
      student_answer: student_answer,
      result: RESULT_INCORRECT,
      reason: reason
    )
  end

  def invalid(reason:)
    base_payload.merge(
      student_answer: student_answer,
      result: RESULT_INVALID,
      reason: reason
    )
  end
end
