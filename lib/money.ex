defmodule FinancialSystem.Money do
  @moduledoc """
    Defines a struct that represents a money.

    The int field stores the integer part, the frac field stores the fractional part and
    the currency field stores the currency.
  """
  alias FinancialSystem.Currency, as: Currency

  defstruct int: 0, frac: 0, currency: :USD

  @doc """
    Creates a new Money struct.
  """
  @spec new!(integer, integer, :atom) :: FinancialSystem.Money :: no_return
  def new!(int, frac, currency) do
    case Currency.valid_currency(currency) do
      true ->
        %FinancialSystem.Money{int: int, frac: frac, currency: currency}

      false ->
        raise "not a valid currency"
    end
  end
end
