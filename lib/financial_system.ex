defmodule FinancialSystem do
  @moduledoc """
    Provides functions that perform financial operations.
  """
  alias FinancialSystem.Money, as: Money
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Transaction, as: Transaction

  @doc """
    Adds an amount of money to an account.

    ### Parameters:
      - account: The account that will receive de amount.
      - amount: The amount.
  """
  @spec add!(Account, Money) :: Account :: no_return
  def add!(account, amount) do
    currency_balance = Account.check_for_currency(account, amount.currency)

    if currency_balance == nil do
      raise "Operating with different currencies"
    else
      %{account | money: Enum.map(account.money, fn x ->
        if x.currency == amount.currency do
          if x.frac + amount.frac >= 100 do
            %{x | int: x.int + amount.int + 1, frac: x.frac + amount.frac - 100}
          else
            %{x | int: x.int + amount.int, frac: x.frac + amount.frac}
          end
        else
          x
        end
      end)}
    end
  end

  @doc """
    Subtracts an amount of an account.

    ### Parameters:
      - account: The account that will lose the money.
      - amount: The amount.
  """
  @spec sub!(Account, Money) :: Account :: no_return
  def sub!(account, amount) do
    currency_balance = Account.check_for_currency(account, amount.currency)

    if currency_balance == nil do
      raise "Operating with different currencies"
    else
      %{account | money: Enum.map(account.money, fn x ->
        if x.currency == amount.currency do
          if x.frac - amount.frac < 0 do
            %{x | int: x.int - amount.int - 1, frac: 100 + (x.frac - amount.frac)}
          else
            %{x | int: x.int - amount.int, frac: x.frac - amount.frac}
          end
        else
          x
        end
      end)}
    end
  end

  @doc """
    Multiplies a amount of money by a rate.

    ### Parameters:
      - amount: The amount.
      - rate: The rate that will be used in the multiplication.
  """
  @spec multiply(Money, number) :: Money
  def multiply(amount, rate) do
    if amount.frac * rate >= 100 do
      %Money{int: Kernel.trunc(amount.int * rate + 1), frac: Kernel.trunc(Kernel.trunc(amount.frac * rate - 100) + (amount.int * rate - Kernel.trunc(amount.int * rate))*100), currency: amount.currency}
    else
      %Money{int: Kernel.trunc(amount.int * rate), frac: Kernel.trunc(Kernel.trunc(amount.frac * rate) + (amount.int * rate - Kernel.trunc(amount.int * rate))*100), currency: amount.currency}
    end
  end

  @doc """
    Exchanges money of a currency to another currency.

    ### Parameters:
      - account: The account that will perform the exchange operation.
      - amount: The amount of money of the original currency that will be exchanged.
      - currency: The currency that will be transferred to.
      - rate: The exchange rate.
  """
  @spec exchange!(Account, Money, :atom, number) :: Account :: no_return
  def exchange!(account, amount, currency, rate) do
    case Account.enough_balance(account, amount) do
      true ->
        account = sub!(account, amount)
        if Account.check_for_currency(account, currency) != nil do
          add!(account, multiply(Money.new!(amount.int, amount.frac, currency), rate))
        else
          account = Account.create_currency(account, currency)
          add!(account, multiply(Money.new!(amount.int, amount.frac, currency), rate))
        end
      false ->
        raise "There's not enough balance for exchange operation"
    end
  end

  @doc """
    Performs a transaction.

    ### Parameters:
      - transaction: The transaction.
  """
  @spec transfer!(Transaction) :: %{source: Account, destinations: [Account]}
  def transfer!(transaction) do
    case Transaction.check_total_percentage!(transaction) do
      true ->
        if !Account.enough_balance(transaction.source, transaction.amount), do: raise "There's not enough balance on source account"
        source = sub!(transaction.source, transaction.amount)

        destinations = transaction.destinations |> Enum.map(fn x ->
          destination =
          if Account.check_for_currency(x[:account], transaction.amount.currency) == nil do
            Account.create_currency(x[:account], transaction.amount.currency)
          else
            x[:account]
          end
          add!(destination, multiply(transaction.amount, x[:percentage]))
        end)

        %{source: source, destinations: destinations}
    end
  end
end
