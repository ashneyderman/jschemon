defmodule ObjectValidationTest do
  use ExUnit.Case
  import JSchemonHelper
  require Logger

  setup do
    {:ok, %{schemas: schemas_json("./schemas/object_schemas.json")}}
  end

  # "with properties": {
  #   "$schema": "http://json-schema.org/draft-04/schema#",
  #   "type": "object",
  #   "properties": {
  #       "test"  : { "type": "string" },
  #       "zip"   : { "type": "boolean" },
  #       "turtle": { "type": "integer" }
  #   }
  # }
  test "with properties", %{schemas: schemas} do
    name = "with properties"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [%{ "test" => "asdf" },
                               %{ "zip" => true },
                               %{ "turtle" => 234 },
                               %{ "asdfasd" => "Asdfasd" }],
              invalid_values: [%{ "test" => 23 },
                               %{ "zip" => "asdfasd" },
                               %{ "turtle" => "asdfads" }]
  end

  # "with properties": {
  #   "$schema": "http://json-schema.org/draft-04/schema#",
  #   "type": "object",
  #   "properties": {
  #       "test"  : { "type": "string" },
  #       "zip"   : { "type": "boolean" },
  #       "turtle": { "type": "integer" }
  #   },
  #   "required": ["test"]
  # }
  test "with required properties", %{schemas: schemas} do
    name = "with properties"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [%{ "test" => "asdf" },
                               %{ "zip" => true },
                               %{ "turtle" => 234 },
                               %{ "test" => "asdf", "asdfasd" => "Asdfasd" }],
              invalid_values: [%{ "test" => 23 },
                               %{ "test" => "asdf", "zip" => "asdfasd" },
                               %{ "test" => "asdf", "turtle" => "asdfads" }]
  end

end