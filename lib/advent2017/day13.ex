defmodule Advent2017.Day13 do
  alias String, as: S
  def start() do
    get_file()
    |> calc_severity()
  end

  def start2() do
    get_file()
    |> calc_delay(0)
  end

  def get_file() do
    "./firewall.txt"
    #"./testfirewall.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(fn(x) ->
      x 
      |> S.split(": ") 
      |> Enum.map(&S.to_integer/1)
      |> List.to_tuple
    end)
  end

  def caught?(ps, depth) do
    rem(ps, 2 * (depth - 1)) == 0
  end

  def calc_severity(input) do
    input
    |> Enum.filter(fn {x, y} -> caught?(x, y) end)
    |> Enum.reduce(0, fn {x, y}, acc -> acc + x * y end)
  end

  def calc_delay(input, delay) do
    case Enum.any?(input, fn {x, y} -> caught?(x+delay, y) end) do
      true -> calc_delay(input, delay + 1)
      false -> delay
    end
  end
end
