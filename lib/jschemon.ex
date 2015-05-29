defmodule JSchemon do

  def create_validator(schema_json) when is_map(schema_json) do
    JSONValidator.create(schema_json)
  end

  def create_validator(filepath) when is_binary(filepath) do
    JSONValidator.create(filepath)
  end

  def is_valid?(json, schema) when is_map(schema) do
    JSONValidator.is_valid?(json, schema)
  end

  def is_valid?(json, validator) when is_function(validator) do
    JSONValidator.is_valid?(json, validator)
  end

end
