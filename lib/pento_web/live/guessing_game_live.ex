defmodule PentoWeb.GuessingGameLive do
  use PentoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    random_number = Enum.random(1..15)

    {:ok,
     assign(socket,
       session_id: session["live_socket_id"],
       guesses: 5,
       state: :guessing,
       message: "",
       random_number: random_number
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p class="text-sm">Current User: <%= @current_user.email %></p>
    <p class="text-sm">Session ID: <code><%= @session_id %></code></p>
    <br />
    <h2 class="text-xl font-semibold">Guessing Game</h2>
    <br />
    <p>Guesses Remaining: <%= @guesses %></p>
    <p><%= @message %></p>
    <%= if @state == :guessing do %>
      <h2>
        <%= for n <- 1..15 do %>
          <button
            class="text-lg border border-zinc-900 py-1 px-3 hover:bg-black hover:text-white"
            phx-click="guess"
            phx-value-number={n}
          >
            <%= n %>
          </button>
        <% end %>
      </h2>
    <% end %>

    <%= if @state == :won do %>
      <button
        class="border border-zinc-900 py-1 px-2 hover:bg-black hover:text-white"
        phx-click="reset"
      >
        Play Again
      </button>
    <% end %>

    <%= if @state == :lost do %>
      <button
        class="border border-zinc-900 py-1 px-2 hover:bg-black hover:text-white"
        phx-click="reset"
      >
        Play Again
      </button>
    <% end %>

    <%= if @state == :error do %>
      <button
        class="border border-zinc-900 py-1 px-2 hover:bg-black hover:text-white"
        phx-click="reset"
      >
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

    has_won = guesses >= 0 and guess == socket.assigns.random_number
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
