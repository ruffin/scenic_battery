defmodule Scenic.Battery.Monitor do
  @moduledoc """
  A component that displays battery charge in four segments, including empty.
  """

  use Scenic.Component, has_children: false

  alias Scenic.Graph
  alias Scenic.Primitive.Style.Theme

  import Scenic.Primitives

  @default_theme :dark
  @default_data %{charge_level: 3, charging: false}

  def verify(nil), do: {:ok, nil}

  def verify(data) when is_map(data) do
    %{charge_level: charge_level, charging: charging} = merge_defaults(data)
    verify_charge_level(charge_level)
    verify_charging(charging)
    {:ok, data}
  end

  def verify(_), do: :invalid_data

  def init(data, opts) do
    %{charge_level: charge_level, charging: charging} = merge_defaults(data)
    styles = opts[:styles]

    # theme is passed in as an inherited style
    theme =
      (styles[:theme] || Theme.preset(@default_theme))
      |> Theme.normalize()

    graph =
      Graph.build()
      # Background inside the battery
      |> rect({59, 33},
        fill: theme.background
      )
      # Battery border
      |> rect({59, 33},
        stroke: {2, theme.border}
      )
      # Positive terminal
      |> rect({8, 10},
        stroke: {2, theme.border},
        fill: theme.border,
        t: {60, 11}
      )
      # Charge segments, low to high
      |> rect({17, 27},
        id: :charge_1,
        hidden: charge_level < 1,
        stroke: {1, theme.background},
        fill: theme.border,
        t: {3, 3}
      )
      |> rect({17, 27},
        id: :charge_2,
        hidden: charge_level < 2,
        stroke: {1, theme.background},
        fill: theme.border,
        t: {21, 3}
      )
      |> rect({17, 27},
        id: :charge_3,
        hidden: charge_level < 3,
        stroke: {1, theme.background},
        fill: theme.border,
        t: {39, 3}
      )

      # Charging symbol
      |> path(
        [
          {:move_to, 36, 5},
          {:line_to, 30, 15},
          {:line_to, 43, 15},
          {:line_to, 22, 29},
          {:line_to, 26, 18},
          {:line_to, 16, 18},
          :close_path
        ],
        id: :charging_symbol,
        stroke: {1, theme.background},
        fill: theme.border,
        hidden: !charging
      )
      |> push_graph()

    {:ok, %{graph: graph}}
  end

  def handle_info({:charge_level, charge}, state) when charge in 0..3 do
    charge_values = %{
      charge_1: charge < 1,
      charge_2: charge < 2,
      charge_3: charge < 3
    }

    new_graph =
      Enum.reduce(charge_values, state[:graph], fn {id, charged}, acc ->
        Graph.modify(acc, id, &update_opts(&1, hidden: charged))
      end)
      |> push_graph()

    {:noreply, %{state | graph: new_graph}}
  end

  def handle_info({:charging, charging}, state) when is_boolean(charging) do
    new_graph =
      Graph.modify(state[:graph], :charging_symbol, &update_opts(&1, hidden: !charging))
      |> push_graph()

    {:noreply, %{state | graph: new_graph}}
  end

  ## Internal
  defp merge_defaults(nil), do: @default_data

  defp merge_defaults(map) do
    Map.merge(@default_data, map, fn _key, default, val -> val || default end)
  end

  defp verify_charge_level(charge_level) when charge_level in 0..3 do
    {:ok}
  end

  defp verify_charge_level(bad_charge_level) do
    raise ":charge_level must be an integer 0..3. Received #{bad_charge_level}"
  end

  defp verify_charging(charging) when is_boolean(charging) do
    {:ok}
  end

  defp verify_charging(_) do
    raise ":charging must be a boolean"
  end
end
