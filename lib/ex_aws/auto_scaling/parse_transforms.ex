defmodule AwsDetective.AutoScaling.ParseTransforms do
  @moduledoc """
    Helper functions for parsing some AWS API fields
  """

  def to_boolean(str) do
    case str do
      "false" -> false
      "true" -> true
      _ -> false
    end
  end

  def to_string_nil(""), do: nil
  def to_string_nil(val), do: val

  def to_list(list) when is_list(list) do
    case Enum.empty?(list) do
      true ->
        nil

      _ ->
        Enum.map(list, fn val -> "#{val}" end)
    end
  end

  def next_token(""), do: nil
  def next_token(marker), do: marker
end
