defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  @spec change_recipient(recipient :: %Recipient{}, attrs :: map()) :: Ecto.Changeset.t()
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  @spec send_promo(recipient :: %Recipient{}, attrs :: map()) :: {:ok, %Recipient{}}
  def send_promo(_recipient, _attrs) do
    # TODO: send email to promo recipient
    {:ok, %Recipient{}}
  end
end
