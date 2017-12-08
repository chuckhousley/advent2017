defmodule Advent2017.Day7 do
  defmodule Node do
    defstruct name: :nil, support: [], weight: 0
  end
  def start() do
    get_file()
    |> Enum.filter(fn(x) -> Regex.match?(~r/->/, x) end) 
    |> split_names()
    |> find_bottom()
  end

  def get_file() do
    "./circus.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\n/, trim: true)
  end

  def split_names(input) do
    re = ~r/^(?<name>.+)\s\(\d+\)\s->\s(?<support>.+$)/
    input
    |> Enum.map(fn(x) -> Regex.named_captures(re,x)  end)
  end
  
  def find_bottom(input) do
    names = Enum.map(input, fn(x) -> Map.get(x, "name") end)
            |> MapSet.new
    supports = 
      Enum.flat_map(input, fn(x) -> 
        String.split(Map.get(x, "support"), ~r/,\s*/, trim: true) 
      end)
      |> MapSet.new

    MapSet.difference(names, supports)
    |> MapSet.to_list
    |> List.first
  end
  # ---- part 2 ----
  def start2() do
    bottom = start()
    input = get_file()
    {sup, no_sup} = 
      Enum.split_with(input, fn(x) -> Regex.match?(~r/->/, x) end)

    sup_re = ~r/^(?<name>.+)\s\((?<weight>\d+)\)\s->\s(?<support>.+$)/
    no_sup_re = ~r/^(?<name>.+)\s\((?<weight>\d+)\)/

    split_data(sup, sup_re) ++ split_data(no_sup, no_sup_re)
    |> find_unbalanced(bottom)
  end
  
  def split_data(input, re) do
    input
    |> Enum.map(fn(x) -> Regex.named_captures(re, x) end)
    |> Enum.map(fn(x) -> row_to_struct(x) end)
    |> Enum.map(fn(x) -> support_list(x) end)
  end

  def row_to_struct(row) do
    name = Map.get(row, "name")
    support = Map.get(row, "support", [])
    weight = Map.get(row, "weight") |> String.to_integer
    %Node{name: name, support: support, weight: weight}
  end

  def support_list(%Node{support: sup} = row) when is_bitstring sup do
    %{row | support: String.split(sup, ~r/,\s/)}
  end

  def support_list(row), do: row

  def find_unbalanced(input, bottom) do
    node = Enum.find(input, fn(%Node{name: x}) -> x == bottom end)
    tree_weight(input, node)
  end

  def tree_weight(_input, %Node{support: [], weight: w}), do: w
  def tree_weight(input, node) do
    support = Map.get(node, :support)
    above_weight = Enum.filter(input, fn(%{name: name}) -> 
      Enum.any?(support, fn(x) ->
        x == name 
      end) 
    end)
    |> Enum.map(fn(x) -> {Map.get(x, :name), tree_weight(input, x)} end)
    |> check_unbalanced
    |> Enum.reduce(0, fn({_k, v}, acc) -> v + acc end) 
    above_weight + Map.get(node, :weight)
  end

  def check_unbalanced(layer) do
    if length(Enum.uniq_by(layer, fn({_, v}) -> v end)) > 1 do
      IO.inspect layer
    end
    layer
  end
end
