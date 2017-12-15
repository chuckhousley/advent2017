defmodule Advent2017.Day14 do
  alias Advent2017.Day10, as: KN
  alias String, as: S
  def start() do
    #test_input = "flqrgnkx"
    input = "hfdlxzhv"
    make_hash_map(input)
    |> make_binary_grid
    |> calc_used
  end

  def start2() do
    input = "hfdlxzhv"
    make_hash_map(input)
    |> make_binary_grid
    |> calc_groups
    # 1106 too high
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
    |> Map.new(fn {y, x} -> {x, y} end)
  end

  def loop(map, v, acc) do
    case Map.get(map, v) do
      nil -> acc
      val -> loop(dfs(map,v), v+1, acc + val)
    end
  end

  def dfs(map, v) do
    check(Map.get_and_update(map, v, fn node -> {node, 0} end), v)
  end

  def check({1, map}, v) do 
    cond do
      v == 0 ->
        map |> dfs(v+1) |> dfs(v+128) 
      v == 127 ->
        map |> dfs(v-1) |> dfs(v+128)
      v == 16256 ->
        map |> dfs(v+1) |> dfs(v-128) 
      v == 16383 ->
        map |> dfs(v-1) |> dfs(v-128) 
      v < 127 ->
        map |> dfs(v-1) |> dfs(v+1) |> dfs(v+128)
      v > 16256 ->
        map |> dfs(v-1) |> dfs(v-128) |> dfs(v+1)
      rem(v, 127) == 0 ->
        map |> dfs(v-1) |> dfs(v-128) |> dfs(v+128)
      rem(v, 128) == 0 ->
        map |> dfs(v+1) |> dfs(v-128) |> dfs(v+128)
      true ->
        map |> dfs(v-1) |> dfs(v-128) |> dfs(v+1) |> dfs(v+128)
    end
  end

  def check({_, map}, _), do: map

  def hex_bytes(hex) when length(hex) < 4, do: hex_bytes([0] ++ hex)
  def hex_bytes(hex), do: hex
end
