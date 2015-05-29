defmodule JSchemonHelper do
  require Logger
  import ExUnit.Assertions

  def schemas_json(filename) do
    json_file = Path.absname(filename, __DIR__)
    json_file |> File.read! |> JSX.decode!
  end

  def validate(name, opts) do
    validator = opts |> Keyword.get(:validator)
    valids    = opts |> Keyword.get(:valid_values)
    invalids  = opts |> Keyword.get(:invalid_values)

    Logger.debug "#{name} => valid values: #{inspect valids} ; invalid values: #{inspect invalids}"
    for valid <- valids do
      assert true == validator.(valid), "Value #{inspect valid} supposed to be valid"
    end

    for invalid <- invalids do
      assert false == validator.(invalid), "Value #{inspect invalid} has to be invalid"
    end
  end
end

ExUnit.start()
