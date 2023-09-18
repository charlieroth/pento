defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component

  alias Pento.Catalog

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_products_with_average_ratings(socket) do
    assign(
      socket,
      :products_with_average_ratings,
      Catalog.list_products_with_average_ratings()
    )
  end

  defp assign_dataset(
         %{assigns: %{products_with_average_ratings: products_with_average_ratings}} = socket
       ) do
    assign(socket, :dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  defp render_bar_chart(chart) do
    Contex.Plot.new(500, 400, chart)
    |> Contex.Plot.titles(title(), subtitle())
    |> Contex.Plot.axis_labels(x_axis(), y_axis())
    |> Contex.Plot.to_svg()
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "Average star ratings per product"
  defp x_axis, do: "Products"
  defp y_axis, do: "Stars"

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  def render(assigns) do
    ~H"""
    <section class="ml-8">
      <h2 class="font-light text-2xl">Survey Results</h2>

      <div id="survey-results-chart">
        <%= @chart_svg %>
      </div>
    </section>
    """
  end
end
