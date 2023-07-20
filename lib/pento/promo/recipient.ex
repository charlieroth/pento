defmodule Pento.Promo.Recipient do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :first_name, :string
    field :email, :string
  end

  def changeset(recipient, attrs) do
    recipient
    |> cast(attrs, [:first_name, :email])
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
