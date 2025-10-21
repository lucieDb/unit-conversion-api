# README

## Unit Conversion Api

A clean, production-ready Rails API designed to validate and grade unit conversions automatically.  
Built with scalability and maintainability in mind, following service-oriented and test-driven principles.

Unit Conversion Api allows teachers to enter unit conversion exercises and automatically correct them.

User can convert:
* Temperatures: Kelvin, Celsius, Fahrenheit, Rankine
* Volumes: Liters, Tablespoons, Cubic-inches, Cubic-feet, Cups, Gallons

The project consists of two separate applications: a Rails backend for the API and a React frontend for the user interface.

## Prerequisites

* Ruby: v.3.4.4
* Rails: v.8.0.3

## Installation

* `git clone https://github.com/lucieDb/unit-conversion-api.git`
* `cd unit-conversion-api`
* `bundle install`

## Run the API

⚠️The server must point to port 3001 to avoid frontend conflict. The react frontend runs on port 3000.
* `bundle exec rails server -p 3001`
The API will be available on http://localhost:3001

## Using the API

Endpoints : POST `/api/v1/convert_batch`
Payload example:
```
{ 
  "studentId" => 0,
  "responses": [
    { "input_value": 84.2, "source_unit": "Fahrenheit", "target_unit": "Rankine", "student_answer": 543.87 },
    { "input_value": 317.33, "source_unit": "Kelvin", "target_unit": "Fahrenheit", "student_answer": 111.554 },
    { "input_value": 73, "source_unit": "Gallons", "target_unit": "Celsius", "student_answer": 83.56 },
    { "input_value": "chat", "source_unit": "Liters", "target_unit": "Cups", "student_answer": 8 }
  ]
}
```

Expected response :
```
{ 
  studentId: 0,
  results:[
    {
      input_value: "84.2",
      source_unit: "Fahrenheit",
      target_unit: "Rankine",
      correct_answer: 543.87,
      student_answer: 543.87,
      result: "correct"
    },
    {
      input_value: "317.33",
      source_unit: "Kelvin",
      target_unit: "Fahrenheit",
      correct_answer: 111.52,
      student_answer: 76.0,
      result: "incorrect"
    },
    {
      input_value: "73",
      source_unit: "Gallons",
      target_unit: "Celsius",
      student_answer: "83.56",
      result: "invalid",
      reason: :units_incompatible,
      message: "Source and target units are not compatible."
    },
    { 
      input_value: "chat",
      source_unit: "Liters",
      target_unit: "Cups",
      student_answer: "8",
      result: "invalid",
      reason: :input_value_not_numeric,
      message: "Input value must be a valid number."
    }
  ]
}
```

## Testing and coverage

With Mac/Linux<br>
`COVERAGE=true bundle exec rspec`

With Windows PowerShell<br>
`$env:COVERAGE="true"`<br>
`bundle exec rspec`<br>
`Remove-Item Env:\COVERAGE`

## Architecture

```
UNIT_CONVERSION_API/
├── app/
│ ├── controllers/
│ │ └── api/
│ │   └── v1/
│ ├── errors/
│ ├── services/
│ │ └── units/
│ │ └── converters/
├── lib/
├── spec/
│ ├── errors/
│ ├── factories/
│ ├── helpers/
│ ├── requests/
│ │ └── api/
│ │   └── v1/
│ └── services/
│ └── units/
│ └── converters/
```

## Architecture Overview

```
+------------------------------------+
|         FRONTEND                   |
|  React App (unit_conversion_front) |
+------------+-----------------------+
             |
             |  POST /api/v1/convert_batch
             v
+----------------------------------------+
|            RAILS BACKEND               |
|         unit_conversion_api            |
|----------------------------------------|
| Controllers                            |
|   ↳ Api::V1::ConversionsController     |
|                 ↓ ↑                    |
|           ConversionService            |
|          ↓ ↑             ↓ ↑           |
|   Unit::Registry     Unit::Converters  |
|          ↓ ↑                           |
|   ↳ Unit::Categories                   |
+------------+---------------------------+
             |
             |  JSON response
             v
+---------------------------+
|     React Frontend UI     |
+---------------------------+
```

## Technical points

* **Separate frontend/backend**: React and Rails are two separate projects, facilitating development, testing and maintenance.
* **Student ID included**: Even if not used for grading, it is returned to maintain a consistent structure and prepare for future tracking.
* **Context-aware responses**: The API returns only relevant fields for each result type. `correct`/`incorrect` include the computed `correct_answer`. `invalid` responses omit it but include `reason` and `message` for clarity. 
* **Centralized service**: `UnitConversionService` handles validation, compatibility, conversion, and verdict (`correct`, `incorrect`, `invalid`) for each response.
* **Dedicated converters**: `TemperatureConverter` and `VolumeConverter` use a pivot unit (Kelvin or Liters) for reliable conversions.
* **Normalization helper**: `NormalizationHelper` (in lib/) provides a `normalize` method to standardize unit strings (`strip` + `upcase`), reducing repetition.
* **Error handling**: Standardized exceptions, clear messages for the frontend, mapping to appropriate HTTP codes.
* **Customizable error messages**: Centralized dictionary (`ErrorMessage`) allows easy addition of new error types or categories.
* **Comprehensive testing**: Unit testing for converters and service cover all cases(`correct`, `incorrect`, `invalid`, unexpected errors).

## Limitations / Possible Improvements

* **Add new units and categories**: The architecture allows easy extension — new units or even entirely new categories (e.g., weight, length) could be integrated through the `Units::Categories`.
* **CSV upload for bulk grading**: Allow teachers to upload student answers in CSV format to speed up grading.
* **Student scoring system**: Compute an overall grade per student based on correct/incorrect answers.
* **Persist data**: Currently, results are not saved. Adding a database would enable tracking of students and past sessions.
* **Internationalization (i18n)**: Support multiple languages for both frontend tooltips and backend messages.

## Author

Lucie Debrabandere
