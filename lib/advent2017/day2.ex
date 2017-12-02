defmodule Advent2017.Day2 do
  def start() do
    input = get_numbers()
    recurse(input, 0)
  end

  def start2() do
    input = get_numbers()
    recurse2(input, 0)
  end

  def get_numbers() do
    "./spreadsheet.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\n/, trim: true)
  end

  def row_to_int(row) do
    String.split(row, ~r/\t/, trim: true)
    |> Enum.map(fn(x) -> String.to_integer(x) end)
    |> Enum.sort(&(&1 >= &2))
  end

  def div_loop(row) do
    res = find_divisable(row)
    case res do
      0 -> div_loop(tl(row))
      _ -> res
    end
  end

  def find_divisable(row) do
    [head | tail] = row
    Enum.reduce(tail, 0, fn(x, acc) -> acc + check_divisable(head, x) end)
  end

  def check_divisable(num, denom) when rem(num, denom) == 0, do: div(num, denom)

  def check_divisable(_, _), do: 0

  def recurse([], acc), do: acc
  def recurse(list, acc) do
    [head | tail] = list
    row = row_to_int(head)
    acc = acc + Enum.max(row) - Enum.min(row)
    recurse(tail, acc)
  end

  def recurse2([], acc), do: acc
  def recurse2(list, acc) do
    [head | tail] = list
    row = row_to_int(head)
    acc = acc + div_loop(row)
    recurse2(tail, acc)
  end
end
