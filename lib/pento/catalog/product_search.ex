defmodule Pento.Catalog.ProductSearch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Catalog.ProductSearch

  embedded_schema do
    field :name, :string
    field :description, :string
  end

  @doc false
  @spec changeset(product_search :: %ProductSearch{}, attrs :: map()) :: Ecto.Changeset.t()
  def changeset(product_search, attrs \\ %{}) do
    product_search
    |> cast(attrs, [:name, :description])
  end
end
