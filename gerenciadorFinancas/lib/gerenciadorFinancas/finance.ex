defmodule GerenciadorFinancas.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias GerenciadorFinancas.Repo

  alias GerenciadorFinancas.Finance.Expense

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses do
    Repo.all(Expense)
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  #lista despesas com base no ano e mes
  def list_expenses_month_year(month, year) do
    from(e in Expense,
      where: fragment("EXTRACT(MONTH FROM ?)", e.date) == ^month and fragment("EXTRACT(YEAR FROM ?)", e.date) == ^year
    )
    |> Repo.all()
  end

  #lista despesas com base no mes
  def list_expenses_month(month) do
    from(e in Expense,
      where: fragment("EXTRACT(MONTH FROM ?)", e.date) == ^month)
    |> Repo.all()
  end


  #lista despesas com base no ano
  def list_expenses_year(year) do
    from(e in Expense,
      where: fragment("EXTRACT(YEAR FROM ?)", e.date) == ^year)
    |> Repo.all()
  end

  @doc """
  Returns a list of expenses filtered by category.

  ## Examples

      iex> list_expenses_by_category("Food")
      [%Expense{}, ...]
  """
  def list_expenses_by_category(category) do
    from(e in Expense,
      where: e.category == ^category
    )
    |> Repo.all()
  end

  @doc """
  Returns a list of expenses filtered by month, year, and category.

  ## Examples

      iex> list_expenses_by_month_year_category(10, 2023, "Food")
      [%Expense{}, ...]
  """
  def list_expenses_by_month_year_category(year, month, category) do
    from(e in Expense,
      where: fragment("EXTRACT(MONTH FROM ?)", e.date) == ^month and
           fragment("EXTRACT(YEAR FROM ?)", e.date) == ^year and
           e.category == ^category
    )
    |> Repo.all()
  end

  @doc """
  Returns a list of all unique categories.

  ## Examples

    iex> list_categories()
    ["Food", "Transport", "Health", ...]
  """
  def list_categories do
    Expense
    |> select([e], e.category)
    |> distinct(true)
    |> Repo.all()
end

end
