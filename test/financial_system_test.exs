defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  import FinancialSystem
  alias FinancialSystem.Money, as: Money
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.Transaction, as: Transaction

  test "User should be able to transfer money to another account" do
    account1 = Account.new(1, [Money.new!(100,0,:USD)])
    account2 = Account.new(2, [Money.new!(0,0,:USD)])
    t1 = Transaction.new(account1, Money.new!(50,0,:USD), [%{:account => account2, :percentage => 1}])
    transaction_result = FinancialSystem.transfer!(t1)

    assert transaction_result[:source].money |> Enum.any?(fn x -> x.currency == :USD && x.int == 50 end) &&
          transaction_result.destinations |> Enum.any?(fn x -> x.id == 2 &&
            x.money |> Enum.any?(fn m -> m.currency == :USD && m.int == 50 end)
          end)
  end

  test "User cannot transfer if not enough money available on the account" do
    account1 = Account.new(1, [Money.new!(0,0,:USD)])
    account2 = Account.new(2, [Money.new!(0,0,:USD)])
    t1 = Transaction.new(account1, Money.new!(50,0,:USD), [%{:account => account2, :percentage => 1}])
    catch_error(FinancialSystem.transfer!(t1))
  end

  test "A transfer should be cancelled if an error occurs" do
    ## Trying to transfer more than 100% of the value transfered
    account1 = Account.new(1, [Money.new!(100,0,:USD)])
    account2 = Account.new(2, [Money.new!(0,0,:USD)])
    t1 = Transaction.new(account1, Money.new!(50,0,:USD), [%{:account => account2, :percentage => 2}])
    catch_error(FinancialSystem.transfer!(t1))
  end

  test "A transfer can be splitted between 2 or more accounts" do
    account1 = Account.new(1, [Money.new!(100,0,:USD)])
    account2 = Account.new(2, [Money.new!(0,0,:USD)])
    account3 = Account.new(3, [Money.new!(0,0,:USD)])
    t1 = Transaction.new(account1, Money.new!(50,0,:USD), [%{:account => account2, :percentage => 0.5}, %{:account => account3, :percentage => 0.5}])
    transaction_result = FinancialSystem.transfer!(t1)

    assert transaction_result[:source].money |> Enum.any?(fn x -> x.currency == :USD && x.int == 50 end) &&
          transaction_result.destinations |> Enum.any?(fn x -> (x.id == 2 &&
            x.money |> Enum.any?(fn m -> m.currency == :USD && m.int == 25 end)) ||
            (x.id == 3 &&
            x.money |> Enum.any?(fn m -> m.currency == :USD && m.int == 25 end))
          end)
  end

  test "User should be able to exchange money between different currencies" do
    account1 = Account.new(1, [Money.new!(100,0,:BRL)])
    exchange_return = FinancialSystem.exchange!(account1, Money.new!(50,0,:BRL), :USD, 0.25)

    assert exchange_return.money |>
    Enum.any?(fn x -> x.currency == :USD && x.int == 12 && x.frac == 50 end)

    assert exchange_return.money |>
    Enum.any?(fn x -> x.currency == :BRL && x.int == 50 && x.frac == 0 end)
  end

  test "Currencies should be in compliance with ISO 4217" do
    catch_error(Money.new!(100,0,:AA))
  end
end
