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

  test "numbers with maximum (23.0)", %{schemas: schemas} do
    name = "numbers with maximum (23.0)"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [22.99, 1.0, 22, -10, 0.0, 23.0, 23],
              invalid_values: [nil, true, "asdfas", 34, 23.1]
  end  

  test "numbers with exclusive maximum (23.0)", %{schemas: schemas} do
    name = "numbers with exclusive maximum (23.0)"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [22.99, 1.0, 22, -10, 0.0],
              invalid_values: [nil, true, "asdfas", 34, 23.1, 23.0, 23]
  end

  test "numbers with minimum (23.0)", %{schemas: schemas} do
    name = "numbers with minimum (23.0)"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [34, 23.1, 23.0, 23],
              invalid_values: [22.99, 1.0, 22, -10, 0.0, nil, true, "asdfas"]
  end

  test "numbers with exclusive minimum (23.0)", %{schemas: schemas} do
    name = "numbers with exclusive minimum (23.0)"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [34, 23.1],
              invalid_values: [23, 23.0, 22.99, 1.0, 22, -10, 0.0, nil, true, "asdfas"]
  end

  test "numbers multiplesOf (5)", %{schemas: schemas} do
    name = "numbers multiplesOf (5)"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [-5, 5, 5.0, 10.0, 0],
              invalid_values: [3, 3.0, -5.2, 5.1, 7, 8.0, nil, true, "asdfas"]
  end

  test "numbers composite min 5 and max 23", %{schemas: schemas} do
    name = "numbers composite min 5 and max 23"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: [6, 5.1, 22.99, 10, 13.4],
              invalid_values: [4, 4.9, 5, 5.0, 23, 23.0, 23.1, 24, 43, nil, true, "asdfas"]
  end

end