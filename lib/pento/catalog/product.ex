defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    has_many :ratings, Rating

    timestamps()
  end

  @doc false
  @spec changeset(product :: %Product{}, attrs :: map()) :: Ecto.Changeset.t()
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  @spec change_unit_price(
          changeset :: Ecto.Changeset.t(),
          current_unit_price :: float(),
          new_unit_price :: float()
        ) :: Ecto.Changeset.t()
  def change_unit_price(changeset, current_unit_price, new_unit_price) do
    if new_unit_price > current_unit_price do
      add_error(changeset, :unit_price, "cannot be increased")
    else
      change(changeset, unit_price: new_unit_price)
    end
  end
end
