defmodule GerenciadorFinancas.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :category, :string
      add :description, :string
      add :amount, :decimal
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
