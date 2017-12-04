defmodule Advent2017.Day4 do
  def start() do
    input = get_file()
    recurse(input, 0)
  end

  def start2() do
    input = get_file()
    recurse2(input, 0)
  end

  def get_file() do
    "./passphrase.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\n/, trim: true)
  end
    
  def recurse([], acc), do: acc
  def recurse(list, acc) do
    [head | tail] = list
    acc = acc + check(String.split(head,~r/ /))
    recurse(tail, acc)
  end

  def recurse2([], acc), do: acc
  def recurse2(list, acc) do
    [head | tail] = list
    head = head
           |> String.split(~r/ /, trim: true)
           |> Enum.flat_map(fn(x) -> [String.codepoints(x)] end)
           |> Enum.map(fn(x) -> Enum.sort(x) end)
    acc = acc + check(head)
    recurse2(tail, acc)
  end

  def check(row) do
    if(length(row) == MapSet.size(MapSet.new(row)), do: 1, else: 0)
  end
end
