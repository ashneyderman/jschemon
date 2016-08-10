defmodule ObjectValidationTest do
  use ExUnit.Case
  import JSchemonHelper
  require Logger

  setup do
    {:ok, %{schemas: schemas_json("./schemas/object_schemas.json")}}
  end

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

  test "with required properties", %{schemas: schemas} do
    name = "with required properties"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [%{ "test" => "asdf" },
                               %{ "test" => "asdf", "asdfasd" => "Asdfasd" }],
              invalid_values: [%{ "test" => 23 },
                               %{ "zip" => true },
                               %{ "turtle" => 234 },
                               %{ "test" => "asdf", "zip" => "asdfasd" },
                               %{ "test" => "asdf", "turtle" => "asdfads" }]
  end

end
