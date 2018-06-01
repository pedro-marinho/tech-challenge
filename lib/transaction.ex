defmodule FinancialSystem.Transaction do
  @moduledoc """
    Defines a struct that represents a transaction.

    The source field stores the source account, the amount field stores the amount of money
    that the source account will transfer and the destinations field stores a list of maps
    where each of them has the account property that stores one destination account and the
    percentage property that stores the percentage of the amount money that the related
    account will receive.
  """
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Money, as: Money

  defstruct source: %Account{}, amount: %Money{}, destinations: [%{:account => %Account{}, :percentage => 0}]

  @doc """
    Creates a new Transaction struct.
  """
  @spec new(Account, Money, [%{:account => Account, :percentage => number}]) :: FinancialSystem.Transaction
  def new(source, amount, destinations) do
    %FinancialSystem.Transaction{source: source, amount: amount, destinations: destinations}
  end

  @doc """
    Checks if the sum of each percentage is 1, otherwise raises an exception.
  """
  @spec check_total_percentage!(FinancialSystem.Transaction) :: boolean :: no_return
  def check_total_percentage!(transaction) do
    sum = transaction.destinations |> Enum.reduce(0, fn (x, acc) -> acc + x[:percentage] end)

    if sum != 1, do: raise "Percentage of each destination must sum 1"

    true
  end
end
