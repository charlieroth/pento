defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="ml-8">
      <h2 class="font-light text-2xl">Survey Results</h2>
    </section>
    """
  end
end
