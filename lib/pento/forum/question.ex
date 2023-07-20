defmodule Pento.Forum.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question, :string
    field :answer, :string
    field :vote_count, :integer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :answer, :vote_count])
    |> validate_required([:question, :answer, :vote_count])
  end
end
