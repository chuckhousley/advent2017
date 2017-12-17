defmodule Advent2017.Day17 do
  def start(mode\\:aoc) do
    input = case mode do
      :aoc -> 386
      :test -> 3
    end

    spinlock(input)
    |> short_circuit
  end

  def spinlock(input) do
    Enum.reduce(1..2017, %{map: {0}, index: 0}, fn n, acc ->
      build_buffer(acc, n, input)
    end)
  end

  def build_buffer(%{map: map, index: index}, n, input) do
    new_index = rem(index + input, n) + 1
    new_map = Tuple.insert_at(map, new_index, n)
    %{map: new_map, index: new_index}
  end

  def short_circuit(%{map: map, index: index}) do
    map
    |> Tuple.to_list
    |> Enum.with_index
    |> Map.new(fn {y, x} -> {x, y} end)
    |> Map.get(index+1)
  end

  def spinlock2(input\\386, iter\\50000000) do
    %{map: answer} = Enum.reduce(
      1..iter, 
      %{map: 0, index: 0}, 
      fn n, acc -> find_after_zero(acc, n, input) end
    )
    answer
  end

  def find_after_zero(%{map: map, index: index}, n, input) do
    check(map, n, rem(index + input, n) + 1)
  end

  def check(_map, n, 1), do: %{map: n, index: 1}
  def check(map, _n, new_index), do: %{map: map, index: new_index}
end
