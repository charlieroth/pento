# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Pento.Catalog
alias Pento.Forum

products = [
  %{
    name: "Chess",
    description: "A classic strategy game",
    sku: 5_678_910,
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and Os",
    sku: 11_121_314,
    unit_price: 3.00
  },
  %{
    name: "Table Tennis",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_324,
    unit_price: 12.00
  }
]

Enum.each(products, fn product ->
  Catalog.create_product(product)
end)

questions = [
  %{
    question: "Has anyone completed level 7 of Tic-Tac-Toe?",
    answer: "No",
    vote_count: 10
  },
  %{
    question: "Can someone explain to me how the rook moves in Chess?",
    answer: "The rook moves vertically and horizontal as many spaces as it can",
    vote_count: 15
  }
]

Enum.each(questions, fn question ->
  Forum.create_question(question)
end)
