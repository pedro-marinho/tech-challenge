defmodule FinancialSystem.Currency do
  @moduledoc """
    Currency module.
  """

  @doc """
    Splits a file by new line.

    ### Parameters:
      - file: The path of the file to be parsed.
  """
  @spec parse_file(String.t()) :: [:atom]
  def parse_file(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.map(fn x -> String.trim(x, "\r") end)
    |> Enum.map(fn x -> String.to_atom(x) end)
  end

  @doc """
    Tests if a currency is valid, i.e., in compliance with ISO 4217.

    ### Parameters:
      - currency: Atom that represents the currency
  """
  @spec valid_currency(:atom) :: boolean
  def valid_currency(currency) do
    parse_file("currencies.txt")
    |> Enum.any?(fn x -> x == currency end)
  end
end
