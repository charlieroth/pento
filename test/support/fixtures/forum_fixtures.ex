defmodule Pento.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Forum` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        question: "some question",
        answer: "some answer",
        vote_count: 42
      })
      |> Pento.Forum.create_question()

    question
  end
end
