defmodule NumberValidationTest do
  use ExUnit.Case
  import JSchemonHelper
  require Logger

  setup do
    {:ok, %{schemas: schemas_json("./schemas/number_schemas.json")}}
  end

  test "integers", %{schemas: schemas} do
    name = "integers"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [1, 2, 3],
              invalid_values: [nil, 3.4, "asdfas"]
  end

  test "numbers", %{schemas: schemas} do
    name = "numbers"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [1, 2, 3, 3.4, 76.0],
              invalid_values: [nil, true, "asdfas"]
  end

end