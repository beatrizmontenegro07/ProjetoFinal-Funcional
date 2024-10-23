defmodule GerenciadorFinancas.FinanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GerenciadorFinancas.Finance` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        category: "some category",
        date: ~D[2024-10-20],
        description: "some description"
      })
      |> GerenciadorFinancas.Finance.create_expense()

    expense
  end
end
