defmodule JSONValidator do
  require Logger

  def create(schema_json) when is_map(schema_json) do
    schema_json |> build
  end
  def create(filepath) when is_binary(filepath) do
    filepath |> File.read! |> JSX.decode! |> build
  end

  def is_valid?(json, schema) when is_map(schema) do  
    v = create(schema)
    is_valid?(json, v)
  end

  def is_valid?(json, validator) when is_function(validator) do
    validator.(json)
  end

  defp build(schema) do
    type = schema["type"]
    cond do
      type == "object" ->
        object(schema)
      type == "string" ->
        fn(v) when is_binary(v) -> 
            validate_string(v, schema)
          (_) -> false
        end
      type == "integer" ->
        fn(i) when is_integer(i) ->
            validate_number(i, schema)
          (_) -> false
        end
      type == "number" ->
        fn(n) when is_number(n) ->
            validate_number(n, schema)
          (_) -> false
        end
      type == "boolean" ->
        fn(b) when is_atom(b) ->
            validate_boolean(b, schema)
          (_) -> false
        end
      type == "array" ->
        fn(a) when is_list(a) ->
            validate_array(a, schema)
          (_) -> false
        end
    end    
  end

  defp object(schema) do 
    validators = allOf(schema) ++ oneOf(schema) ++ properties(schema)
    fn(value) when is_map(value) ->
        (for validator <- validators, do: validator.(value))
          |> Enum.all?(&(&1))
      (_) -> false
    end
  end

  defp allOf(schema) do
    case schema["allOf"] do
      nil -> always_valid
      allOfs when is_list(allOfs) ->
        # TODO (alex - 05-27-2015): need to iterate
        always_valid
    end
  end

  defp oneOf(schema) do
    case schema["oneOf"] do
      nil -> fn(_) -> true end
      _oneOfs ->
        # TODO (alex - 05-27-2015): need to iterate
        always_valid
    end
  end

  defp properties(schema) do
    case schema["properties"] do
      nil -> fn(_) -> true end
      props when is_map(props) ->
        required = schema["required"]
        validators = props |> Enum.map(fn({k,v}) -> {k, build(v)} end)
        fn(value) when is_map(value) ->
            result = value 
                  |> Enum.map(fn({k,v}) -> 
                                if Dict.has_key?(validators, k), 
                                  do: validators[k].(v),
                                  else: true
                              end)
                  |> Enum.all?(&(&1))
            result and validate_required(value, required)
          (_) -> false
        end
    end
  end

  defp validate_string(v, schema) do
    enums   = schema["enum"]
    max     = schema["maxLength"]
    min     = schema["minLength"]
    pattern = schema["pattern"]
    _format  = schema["format"]

    enumCheck = if (enums != nil and Enum.count(enums) > 0), 
                  do: (enums |> Enum.member?(v)),
                else: true
    
    maxCheck  = if (max != nil and max > 0),
                  do: (String.length(v) <= max),
                else: true
    
    minCheck  = if (min != nil and min > 0),
                  do: (String.length(v) >= min),
                else: true
    
    patCheck  = if (pattern != nil),
                  do: (pattern |> Regex.compile! |> Regex.match?(v)),
                else: true

    enumCheck and maxCheck and minCheck and patCheck and String.valid?(v)
  end

  defp validate_number(n, schema) do
    multipleOf = schema["multipleOf"]
    maximum    = schema["maximum"]
    exclMax    = schema["exclusiveMaximum"]
    minimum    = schema["minimum"]
    exclMin    = schema["exclusiveMinimum"]

    multCheck = if (multipleOf != nil),
                  do: (rem(n, multipleOf) == 0),
                else: true

    maxCheck  = if (maximum != nil),
                  do: l(n, maximum, exclMax),
                else: true

    minCheck  = if (minimum != nil),
                  do: g(n, minimum, exclMin),
                else: true

    multCheck and maxCheck and minCheck
  end

  defp validate_boolean(b, _schema) do
    (b === true) or (b === false)
  end

  defp validate_array(_a, _schema) do
    true
  end
 
  defp validate_required(_, nil), do: true
  defp validate_required(_, []), do: true
  defp validate_required(obj, required) when is_map(obj) do
    required |> Enum.all?(&(obj[&1] != nil))
  end
  defp validate_required(_, _), do: false

  defp l(val, max, nil), do: l(val, max, false)
  defp l(val, max, false), do: val <= max 
  defp l(val, max, true), do: val < max

  defp g(val, min, nil), do: g(val, min, false)
  defp g(val, min, false), do: val >= min 
  defp g(val, min, true), do: val > min

  defp always_valid, do: fn(_) -> true end

end