defmodule PentoWeb.GuessingGameLive do
  use PentoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    random_number = Enum.random(1..15)

    {:ok,
     assign(socket,
       guesses: 5,
       state: :guessing,
       message: "",
       random_number: random_number
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold">Guessing Game</h1>

    <%= if @state == :guessing do %>
      <h2>Guesses Remaining: <%= @guesses %></h2>
      <h2><%= @message %></h2>
      <h2>
        <%= for n <- 1..15 do %>
          <button class="border border-zinc-900 py-1 px-2" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </button>
        <% end %>
      </h2>
    <% end %>

    <%= if @state == :won do %>
      <h2><%= @message %></h2>
      <button class="border border-zinc-900 py-1 px-2" phx-click="reset">
        Play Again
      </button>
    <% end %>

    <%= if @state == :lost do %>
      <h2><%= @message %></h2>
      <button class="border border-zinc-900 py-1 px-2" phx-click="reset">
        Play Again
      </button>
    <% end %>

    <%= if @state == :error do %>
      <h2><%= @message %></h2>
      <button class="border border-zinc-900 py-1 px-2" phx-click="reset">
        Play Again
      </button>
    <% end %>
    """
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, socket) do
    guess = String.to_integer(guess)

    guesses = socket.assigns.guesses - 1

    higher = guess < socket.assigns.random_number

    has_won = guesses > 0 and guess == socket.assigns.random_number
    has_lost = guesses == 0 and guess != socket.assigns.random_number
    still_playing = guesses > 0 and guess != socket.assigns.random_number

    cond do
      has_won == true ->
        message = "You guessed: #{guess}. Correct!"
        {:noreply, assign(socket, state: :won, guesses: guesses, message: message)}

      has_lost == true ->
        message = "You failed to guess the number. It was #{socket.assigns.random_number}."
        {:noreply, assign(socket, state: :lost, guesses: guesses, message: message)}

      still_playing == true ->
        if higher == true do
          message = "You guessed: #{guess}. Wrong. Guess higher."
          {:noreply, assign(socket, state: :guessing, guesses: guesses, message: message)}
        else
          message = "You guessed: #{guess}. Wrong. Guess lower."
          {:noreply, assign(socket, state: :guessing, guesses: guesses, message: message)}
        end

      true ->
        message = "Something went wrong."
        {:noreply, assign(socket, state: :error, guesses: guesses, message: message)}
    end
  end

  @impl true
  def handle_event("reset", _params, socket) do
    random_number = Enum.random(1..1)

    {:noreply,
     assign(socket,
       guesses: 5,
       state: :guessing,
       message: "",
       random_number: random_number
     )}
  end
end
