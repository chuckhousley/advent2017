defmodule Advent2017.Day1 do
  def start() do
    [left | input] = get_numbers()
    {num, acc} = recurse(left, input, 0)
    acc = acc + check(left, num)
    acc
  end

  def start2() do
    input = get_numbers()
    acc = Enum.chunk_every(input, div(length(input), 2))
          |> List.zip
          |> Enum.filter(fn({x, y}) -> x == y end)
          |> Enum.flat_map(fn({x, x}) -> [String.to_integer(x)] end)
          |> Enum.sum
    acc * 2
  end

  def get_numbers() do
    "./captcha.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r//, trim: true)
  end

  def recurse(num, [], acc), do: {num, acc}

  def recurse(left, list, acc) do
    [right | list] = list
    acc = acc + check(left, right)
    recurse(right, list, acc)
  end

  def check(left, right) when left == right do
    String.to_integer(left)
  end

  def check(_, _), do: 0
end
