defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")}
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
