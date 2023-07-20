defmodule Pento.ForumTest do
  use Pento.DataCase

  alias Pento.Forum

  describe "questions" do
    alias Pento.Forum.Question

    import Pento.ForumFixtures

    @invalid_attrs %{question: nil, answer: nil, vote_count: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Forum.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Forum.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{question: "some question", answer: "some answer", vote_count: 42}

      assert {:ok, %Question{} = question} = Forum.create_question(valid_attrs)
      assert question.question == "some question"
      assert question.answer == "some answer"
      assert question.vote_count == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer", vote_count: 43}

      assert {:ok, %Question{} = question} = Forum.update_question(question, update_attrs)
      assert question.question == "some updated question"
      assert question.answer == "some updated answer"
      assert question.vote_count == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_question(question, @invalid_attrs)
      assert question == Forum.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Forum.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Forum.change_question(question)
    end
  end
end
