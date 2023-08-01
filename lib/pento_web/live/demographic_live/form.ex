defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    demographic = %Demographic{}
    changeset = Survey.change_demographic(demographic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic(demographic)
     |> assign_form(changeset)}
  end

  def handle_event("demographic-form-change", %{"demographic" => demographic_params}, socket) do
    demographic_params = params_with_user(socket, demographic_params)

    changeset =
      socket.assigns.demographic
      |> Survey.change_demographic(demographic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("demographic-form-submit", %{"demographic" => demographic_params}, socket) do
    demographic_params = params_with_user(socket, demographic_params)
    {:noreply, save_demographic(socket, demographic_params)}
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:demographic_created, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp params_with_user(socket, demographic_params) do
    Map.put(demographic_params, "user_id", socket.assigns.current_user.id)
  end

  defp assign_demographic(socket, demographic) do
    assign(socket, :demographic, %{demographic | user_id: socket.assigns.current_user.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id={@id}
        phx-target={@myself}
        phx-change="demographic-form-change"
        phx-submit="demographic-form-submit"
      >
        <.input
          field={@form[:gender]}
          type="select"
          label="Gender"
          options={["female", "male", "other", "prefer not to say"]}
        />
        <.input
          field={@form[:year_of_birth]}
          type="select"
          label="Year of Birth"
          options={Enum.reverse(1920..2022)}
        />
        <.input field={@form[:user_id]} type="hidden" />

        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
