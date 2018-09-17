defmodule Scenic.Battery.Components do
  alias Scenic.Battery.Monitor
  alias Scenic.Graph
  alias Scenic.Primitive

  @moduledoc """
  A set of helper functions to make it easy to add battery monitors to a graph.
  """

  # --------------------------------------------------------
  @doc """
  Add a battery monitor to a graph.

  ### Data

  Data is required. It can be nil or a map.
  It can contain the following keys:

  * `:charge_level` - An integer 0..3, indicating the number of 
    segments to display inside the battery monitor. Defaults to 3.
  * `:charging` - A boolean value. Controls a lightning bolt on the image.
    Defaults to true.

  ### Additional Styles

  To pass in a custom theme, supply a map with at least the following entries:
  * `:border` - the color of the battery monitor's borders and charge segments
  * `:background` - the color of the battery monitor's internal background and 
    line around the lightning bolt

  ### Examples

  The following example creates a battery monitor at (20, 20) on the screen
  with a charge level of 2 and a charging indicator.

      graph
      |> battery_monitor(%{charge_level: 2, charging: true}, translate: {20, 20})

  The next example creates a default battery monitor with a theme.
  Being a better designer than the author is recommended.

      graph
      |> battery_monitor(%{}, theme: %{background: :yellow, border: :green},)
  """

  def battery_monitor(graph, data, options \\ [])

  def battery_monitor(%Graph{} = g, data, options) do
    Monitor.verify!(data)
    Monitor.add_to_graph(g, data, options)
  end

  def battery_monitor(%Primitive{module: Primitive.SceneRef} = p, data, options) do
    Monitor.verify!(data)
    Primitive.put(p, {Monitor, data}, options)
  end
end
