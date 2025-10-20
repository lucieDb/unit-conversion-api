FactoryBot.define do
  factory :conversion, class: Hash do
    input_value { 100.0 }
    source_unit { "Celsius" }
    target_unit { "Fahrenheit" }
    student_answer { 212.0 }

    initialize_with { attributes }

    trait :invalid_input do
      input_value { "abc" }
    end

    trait :units_incompatible do
      source_unit { "gallons" }
      target_unit { "CelsiuS" }
    end

    trait :incorrect_answer do
      student_answer { "banana" }
    end
  end
end
