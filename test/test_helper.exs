defmodule JSchemonHelper do
  require Logger
  import ExUnit.Assertions

  def schemas_json(filename) do
    json_file = Path.absname(filename, __DIR__)
    json_file |> File.read! |> Poison.decode!
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

# {
#     "id": "http://json-schema.org/draft-04/schema#",
#     "$schema": "http://json-schema.org/draft-04/schema#",
#     "description": "Core schema meta-schema",
#     "definitions": {
#         "schemaArray": {
#             "type": "array",
#             "minItems": 1,
#             "items": { "$ref": "#" }
#         },
#         "positiveInteger": {
#             "type": "integer",
#             "minimum": 0
#         },
#         "positiveIntegerDefault0": {
#             "allOf": [ { "$ref": "#/definitions/positiveInteger" }, { "default": 0 } ]
#         },
#         "simpleTypes": {
#             "enum": [ "array", "boolean", "integer", "null", "number", "object", "string" ]
#         },
#         "stringArray": {
#             "type": "array",
#             "items": { "type": "string" },
#             "minItems": 1,
#             "uniqueItems": true
#         }
#     },
#     "type": "object",
#     "properties": {
#         "id": {
#             "type": "string",
#             "format": "uri"
#         },
#         "$schema": {
#             "type": "string",
#             "format": "uri"
#         },
#          "title": {
#              "type": "string"
#          },
#          "description": {
#              "type": "string"
#          },
#          "default": {},
#          "multipleOf": {
#              "type": "number",
#              "minimum": 0,
#              "exclusiveMinimum": true
#          },
#          "maximum": {
#              "type": "number"
#          },
#          "exclusiveMaximum": {
#              "type": "boolean",
#              "default": false
#          },
#          "minimum": {
#              "type": "number"
#          },
#          "exclusiveMinimum": {
#              "type": "boolean",
#              "default": false
#          },
#          "maxLength": { "$ref": "#/definitions/positiveInteger" },
#          "minLength": { "$ref": "#/definitions/positiveIntegerDefault0" },
#          "pattern": {
#              "type": "string",
#              "format": "regex"
#          },
#          "additionalItems": {
#              "anyOf": [
#                  { "type": "boolean" },
#                  { "$ref": "#" }
#              ],
#              "default": {}
#          },
#          "items": {
#              "anyOf": [
#                  { "$ref": "#" },
#                  { "$ref": "#/definitions/schemaArray" }
#              ],
#              "default": {}
#          },
#          "maxItems": { "$ref": "#/definitions/positiveInteger" },
#          "minItems": { "$ref": "#/definitions/positiveIntegerDefault0" },
#          "uniqueItems": {
#              "type": "boolean",
#              "default": false
#          },
#          "maxProperties": { "$ref": "#/definitions/positiveInteger" },
#          "minProperties": { "$ref": "#/definitions/positiveIntegerDefault0" },
#          "required": { "$ref": "#/definitions/stringArray" },
#          "additionalProperties": {
#              "anyOf": [
#                  { "type": "boolean" },
#                  { "$ref": "#" }
#              ],
#              "default": {}
#          },
#          "definitions": {
#              "type": "object",
#              "additionalProperties": { "$ref": "#" },
#              "default": {}
#          },
#          "properties": {
#              "type": "object",
#              "additionalProperties": { "$ref": "#" },
#              "default": {}
#          },
#          "patternProperties": {
#              "type": "object",
#              "additionalProperties": { "$ref": "#" },
#              "default": {}
#          },
#          "dependencies": {
#              "type": "object",
#              "additionalProperties": {
#                  "anyOf": [
#                      { "$ref": "#" },
#                      { "$ref": "#/definitions/stringArray" }
#                  ]
#              }
#          },
#          "enum": {
#              "type": "array",
#              "minItems": 1,
#              "uniqueItems": true
#          },
#          "type": {
#              "anyOf": [
#                  { "$ref": "#/definitions/simpleTypes" },
#                  {
#                      "type": "array",
#                      "items": { "$ref": "#/definitions/simpleTypes" },
#                      "minItems": 1,
#                      "uniqueItems": true
#                  }
#              ]
#          },
#          "allOf": { "$ref": "#/definitions/schemaArray" },
#          "anyOf": { "$ref": "#/definitions/schemaArray" },
#          "oneOf": { "$ref": "#/definitions/schemaArray" },
#          "not": { "$ref": "#" }
#      },
#      "dependencies": {
#          "exclusiveMaximum": [ "maximum" ],
#          "exclusiveMinimum": [ "minimum" ]
#      },
#      "default": {}
# }
