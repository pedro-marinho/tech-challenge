defmodule FinancialSystem.Account do
  @moduledoc """
    Defines a struct that represents an account.

    An Account has a list of Money structs, each of them represents the balance
    of a specific currency.
  """
  alias FinancialSystem.Money, as: Money

  defstruct id: nil, money: [%Money{}]

  @doc """
    Creates a new Account struct.

    ### Parameters:
      - integer: An identification number for the account.
      - money: A list of Money structs where each of them represents a balance of one currency.
  """
  @spec new(integer, [Money]) :: FinancialSystem.Account
  def new(id, money) do
    %FinancialSystem.Account{id: id, money: money}
  end

  @doc """
    Determines wheter a Account has enough balance to the operation or not.

    ### Parameters:
      - account: The account to be tested.
      - amount: The amount of money wanted.
  """
  @spec enough_balance(FinancialSystem.Account, Money) :: boolean
  def enough_balance(account, amount) do
    currency_balance = check_for_currency(account, amount.currency)

    if currency_balance == nil do
      false
    else
      cond do
        currency_balance.int > amount.int ->
          true

        currency_balance.int == amount.int && currency_balance.frac >= amount.frac ->
          true

        true ->
          false
      end
    end
  end

  @doc """
    Checks the balance of one specific currency.

    ### Parameters:
      - account: The account.
      - currency: The currency to be tested.
  """
  @spec check_for_currency(FinancialSystem.Account, :atom) :: Money | nil
  def check_for_currency(account, currency) do
    account.money
    |> Enum.filter(fn x -> x.currency == currency end)
    |> List.first()
  end

  @doc """
    Create a Money struct for a specific currency if this currency is not in the original list.

    ### Parameters:
      - account: The account where the balance of this currency will be created.
      - amount: The currency.
  """
  @spec create_currency(FinancialSystem.Account, :atom) :: FinancialSystem.Account
  def create_currency(account, currency) do
    case check_for_currency(account, currency) do
      nil ->
        %{account | money: [Money.new!(0, 0, currency) | account.money]}

      _ ->
        account
    end
  end
end
