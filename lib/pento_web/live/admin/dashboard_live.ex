defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  alias PentoWeb.Endpoint
  alias PentoWeb.Admin.SurveyResultsLive

  @survey_results_topic "survey_results"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="row">
      <h1 class="font-heavy text-3xl">Admin Dashboard</h1>
    </section>

    <.live_component id={@survey_results_component_id} module={PentoWeb.Admin.SurveyResultsLive} />
    """
  end
end
