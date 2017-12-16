defmodule Advent2017.Day14 do
  alias Advent2017.Day10, as: KN
  alias String, as: S
  def start(which\\:aoc) do
    input = case which do
      :test -> "flqrgnkx" # 8108
      :aoc -> "hfdlxzhv"  # 8230
    end
    make_hash_map(input)
    |> make_binary_grid
    |> calc_used
  end

  def start2() do
    input = "hfdlxzhv"
    make_hash_map(input)
    |> make_binary_grid
    |> calc_groups
    |> loop
  end

  def make_hash_map(input) do
    for n <- 0..127, do: KN.make_knot_hash(
      KN.split_ascii(input <> "-" <> Integer.to_string(n))
    )
  end

  def make_binary_grid(hash_map) do
    hash_map
    |> Enum.map(&S.codepoints(&1) |> Enum.flat_map(fn x ->
      S.to_integer(x, 16)
      |> Integer.digits(2)
      |> hex_bytes
    end))
  end

  def calc_used(binary_grid) do
    binary_grid
    |> List.flatten
    |> Enum.sum
  end

  def calc_groups(binary_grid) do
    binary_grid
    |> List.flatten
    |> Enum.with_index
    |> Map.new(fn {y, x} -> {{div(x, 128), rem(x, 128)}, y} end)
  end

  def loop(map, v\\0, acc\\0)
  def loop(map, _, acc) when map == %{}, do: acc
  def loop(map, v, acc) do
    coords = {div(v, 128), rem(v, 128)}
    case Map.has_key?(map, coords) do
      true -> 
        acc = acc + Map.get(map, coords)
        loop(dfs(map,coords), v+1, acc)
      false -> loop(dfs(map,coords), v+1, acc)
    end
  end

  def dfs(map, v) do
    check(Map.pop(map, v, nil), v)
  end

  def check({1, map}, {x, y} = v) do 
    cond do
      x == 0 ->
        map |> up(v) |> down(v) |> right(v)
      y == 0 ->
        map |> left(v) |> right(v) |> down(v)
      x == 127 ->
        map |> up(v) |> down(v) |> left(v)
      y == 127 ->
        map |> left(v) |> right(v) |> up(v)
      true ->
        map |> left(v) |> up(v) |> right(v) |> down(v)
    end
  end

  def check({_, map}, _), do: map

  def left(map, {x, y}),  do: dfs(map, {x-1, y})
  def right(map, {x, y}), do: dfs(map, {x+1, y})
  def up(map, {x, y}),    do: dfs(map, {x, y-1})
  def down(map, {x, y}),  do: dfs(map, {x, y+1})

  def hex_bytes(hex) when length(hex) < 4, do: hex_bytes([0] ++ hex)
  def hex_bytes(hex), do: hex
end
