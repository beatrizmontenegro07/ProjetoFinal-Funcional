defmodule GerenciadorFinancasWeb.ExpenseController do
  use GerenciadorFinancasWeb, :controller

  alias GerenciadorFinancas.Finance
  alias GerenciadorFinancas.Finance.Expense

  def index(conn, _params) do
    expenses = Finance.list_expenses()
    render(conn, :index, expenses: expenses)
  end

  def new(conn, _params) do
    changeset = Finance.change_expense(%Expense{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"expense" => expense_params}) do
    case Finance.create_expense(expense_params) do
      {:ok, expense} ->
        conn
        |> put_flash(:info, "Expense created successfully.")
        |> redirect(to: ~p"/expenses/#{expense}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    expense = Finance.get_expense!(id)
    render(conn, :show, expense: expense)
  end

  def edit(conn, %{"id" => id}) do
    expense = Finance.get_expense!(id)
    changeset = Finance.change_expense(expense)
    render(conn, :edit, expense: expense, changeset: changeset)
  end

  def update(conn, %{"id" => id, "expense" => expense_params}) do
    expense = Finance.get_expense!(id)

    case Finance.update_expense(expense, expense_params) do
      {:ok, expense} ->
        conn
        |> put_flash(:info, "Expense updated successfully.")
        |> redirect(to: ~p"/expenses/#{expense}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, expense: expense, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    expense = Finance.get_expense!(id)
    {:ok, _expense} = Finance.delete_expense(expense)

    conn
    |> put_flash(:info, "Expense deleted successfully.")
    |> redirect(to: ~p"/expenses")
  end

  def chart(conn, %{"month" => month, "year" => year}) do
    # Converte os parâmetros para inteiro e busca os expenses filtrados
    month = if month == "", do: nil, else: String.to_integer(month)
    year = if year == "", do: nil, else: String.to_integer(year)

    # Agrupa as despesas
    expenses =
      case {month, year} do
        {nil, nil} -> Finance.list_expenses()
        {nil, year} -> Finance.list_expenses_year(year)
        {month, nil} -> Finance.list_expenses_month(month)
        {year, month} -> Finance.list_expenses_month_year(year, month)
      end

    # Agrupa as despesas por categoria
    amount_by_category =
      expenses
      |> Enum.group_by(& &1.category)
      |> Enum.map(fn {category, expenses} ->
        total = Enum.reduce(expenses, Decimal.new(0), fn expense, acc -> Decimal.add(acc, expense.amount) end)
        {category, Decimal.to_float(total)}
      end)

    IO.inspect(amount_by_category, label: "Amount by Category")
    IO.inspect(Enum.map(expenses, & &1.category), label: "Categories")
    IO.inspect(Enum.map(expenses, & Decimal.to_float(&1.amount)), label: "Amounts")


    render(conn, "chart.html", amount_by_category: amount_by_category, month: month, year: year)
  end

  def chart(conn, _params) do
    # Agrupa as despesas
    expenses = Finance.list_expenses()

    # Agrupa as despesas por categoria
    amount_by_category =
      expenses
      |> Enum.group_by(& &1.category)
      |> Enum.map(fn {category, expenses} ->
        total = Enum.reduce(expenses, Decimal.new(0), fn expense, acc -> Decimal.add(acc, expense.amount) end)
        {category, Decimal.to_float(total)}
      end)

    IO.inspect(amount_by_category, label: "Amount by Category")
    IO.inspect(Enum.map(expenses, & &1.category), label: "Categories")
    IO.inspect(Enum.map(expenses, & Decimal.to_float(&1.amount)), label: "Amounts")


    render(conn, "chart.html", amount_by_category: amount_by_category)
  end

  #funcoes para filtrar por ano e data
  def filter(conn, %{"month" => month, "year" => year, "category" => category}) do
    categories = Finance.list_categories()
    # Converte os parâmetros para inteiro e busca os expenses filtrados
    month = if month == "", do: nil, else: String.to_integer(month)
    year = if year == "", do: nil, else: String.to_integer(year)

    expenses =
      case {month, year, category} do
        {nil, nil, ""} -> Finance.list_expenses()
        {nil, nil, category} -> Finance.list_expenses_by_category(category)
        {nil, year,  ""} -> Finance.list_expenses_year(year)
        {month, nil,  ""} -> Finance.list_expenses_month(month)
        {year, month, nil} -> Finance.list_expenses_month_year(year, month)
      {year, month, category} -> Finance.list_expenses_by_month_year_category(year, month, category)
      end

    expenses_data = Enum.map(expenses, fn expense ->
      %{
        date: expense.date,
        description: expense.description,
        category: expense.category,
        amount: expense.amount
      }
    end)

    render(conn, "filter.html", dados: expenses_data)
  end

  def filter(conn, _paramns) do
    expenses = Finance.list_expenses()
    IO.inspect(Finance.list_expenses_month_year(10, 23))
    expenses_data = Enum.map(expenses, fn expense ->
      %{
        date: expense.date,
        description: expense.description,
        category: expense.category,
        amount: expense.amount
      }
    end)

    render(conn, "filter.html", dados: expenses_data)
  end
end
