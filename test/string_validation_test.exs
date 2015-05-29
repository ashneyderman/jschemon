defmodule StringValidationTest do
  use ExUnit.Case
  import JSchemonHelper
  require Logger

  setup do
    {:ok, %{schemas: schemas_json("./schemas/string_schemas.json")}}
  end

  test "enumerated strings", %{schemas: schemas} do
    name = "enumerated strings"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["location", "department", "role", "user", "contact"],
              invalid_values: ["blah", "", nil]
  end

  test "string with maxLength", %{schemas: schemas} do
    name = "string with maxLength"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["1", "22", "333", "0000000000"],
              invalid_values: ["INVALIDLENGTHSTRING"]
  end

  test "patterned date-time", %{schemas: schemas} do
    name = "patterned date-time"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["2013-04-25T14:25:01.638Z"],
              invalid_values: ["INVALIDLENGTHSTRING"]
  end

  test "strings with minLength", %{schemas: schemas} do
    name = "strings with minLength"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["123", "12"],
              invalid_values: ["", nil, "1"]
  end

  test "minAndMaxLength", %{schemas: schemas} do
    name = "minAndMaxLength"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["123", "12", "1234567890"],
              invalid_values: ["", nil, "1", "12345678901"]
  end

  test "composite", %{schemas: schemas} do
    Logger.info "keys: #{ schemas |> Dict.keys |> Enum.join(", ") }"
    name = "composite"
    validate name, validator: JSONValidator.create(schemas[name]),
                valid_values: ["123a2b", "123a2b456", "abc"],
              invalid_values: ["", nil, "1", "12345678901", "ABCTRE"]
  end

end