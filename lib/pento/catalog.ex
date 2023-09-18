defmodule Pento.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Pento.Repo
  alias Pento.Catalog.{Product, ProductSearch}
  alias Pento.Accounts.User

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  @spec list_products() :: [Product.t()]
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Returns the list of products with user ratings.

  ## Examples

      iex> list_products_with_user_rating(%User{})
      [%Product{}, ...]

  """
  @spec list_products_with_user_rating(user :: %User{}) :: [Product.t()]
  def list_products_with_user_rating(user) do
    Product.Query.with_user_ratings(user) |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_product!(id :: String.t()) :: Product.t()
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_product(attrs :: map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_product(product :: Product.t(), attrs :: map()) ::
          {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Markdown the unit price of a product.

  If the markdown amount is less than the current price

  ## Examples

      iex> markdown_product(product, amount)
      {:ok, %Product{}}

      iex> markdown_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec markdown_product(product :: Product.t(), amount :: float()) ::
          {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def markdown_product(%Product{} = product, amount) do
    product
    |> Ecto.Changeset.change()
    |> Product.change_unit_price(product.unit_price, product.unit_price - amount)
    |> Repo.update()
  end

  @doc """
  Search for products.

  Currently only supports search by name and description.

  ## Examples

      iex> search_products(%ProductSearch{})
      [%Product{}, ...]

  """
  @spec search_products(product_search_params :: map()) :: [%Product{}]
  def search_products(%{name: _name, description: _description} = product_search_params) do
    search_products_by(product_search_params)
  end

  defp search_products_by(%{name: nil, description: nil}), do: []
  defp search_products_by(%{name: "", description: ""}), do: []

  defp search_products_by(%{name: name, description: ""}) do
    from(p in Product, where: ilike(p.name, ^"%#{name}%")) |> Repo.all()
  end

  defp search_products_by(%{name: "", description: description}) do
    from(p in Product, where: ilike(p.description, ^"%#{description}%")) |> Repo.all()
  end

  defp search_products_by(%{name: name, description: description}) do
    from(
      p in Product,
      where: ilike(p.name, ^"%#{name}%"),
      or_where: ilike(p.description, ^"%#{description}%")
    )
    |> Repo.all()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_product(product :: Product.t()) ::
          {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  @spec change_product(product :: Product.t(), attrs :: map()) :: Ecto.Changeset.t()
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product search changes.

  ## Examples

      iex> change_product_search(product_search)
      %Ecto.Changeset{data: %ProductSearch{}}

  """
  @spec change_product_search(product_search :: %ProductSearch{}, attrs :: map()) ::
          Ecto.Changeset.t()
  def change_product_search(%ProductSearch{} = product_search, attrs \\ %{}) do
    ProductSearch.changeset(product_search, attrs)
  end

  @doc """
  Returns the list of products with average ratings.

  ## Examples

      iex> list_products_with_average_ratings()
      [
        {"Checkers", 4.0},
        {"Table Tennis", 1.0},
        ...
      ]

  """
  @spec list_products_with_average_ratings() :: [%Product{}]
  def list_products_with_average_ratings do
    Product.Query.with_average_ratings() |> Repo.all()
  end
end
