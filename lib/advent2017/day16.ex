defmodule Advent2017.Day16 do
  def start() do
    input = get_file()
    dancers = get_dancers()
    dance(input, dancers)
  end

  def start2() do
    input = get_file()
    dancers = get_dancers()
    dance_lots(input, dancers)
  end

  def get_file() do
    "./dance.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(",")
  end

  def get_dancers() do
    "abcdefghijklmnop"
    |> String.split(~r//, trim: true)
    |> list_dancers
  end

  def list_dancers(d) do
    d
    |> Enum.with_index
    |> Map.new(fn {y, x} -> {x, y} end)
  end


  def dance([], dancers), do: dancers
  def dance([inst | input], dancers) do
    dancers = step(dancers, String.split(inst, ~r//, parts: 2))
    dance(input, dancers)
  end

  def dance_lots(instruction, dancers, iter\\0)
  def dance_lots(_, dancers, 1000000000), do: dancers
  def dance_lots(instruction, dancers, iter) do
    dancers = dance(instruction, dancers)
    dance_lots(instruction, dancers, iter+1)
  end

  def step(dancers, ["s", x]) do
    spin(Map.values(dancers), String.to_integer(x))
  end
  def step(dancers, ["x", x]) do
    exchange(dancers, String.split(x, "/"))
  end
  def step(dancers, ["p", x]) do
    partner(dancers, String.split(x, "/"))
  end

  def spin(dancers, 0), do: list_dancers(dancers)
  def spin(dancers, n) do
    [last | rest] = Enum.reverse(dancers)
    spin([last] ++ Enum.reverse(rest), n-1)
  end

  def exchange(dancers, pos) do
    [a, b] = Enum.map(pos, &String.to_integer/1)
    %{^a => da, ^b => db} = dancers
    %{ dancers | a => db, b => da }
  end

  def partner(dancers, [a, b]) do
    {pa, _} = Enum.find(dancers, fn {_, v} -> v == a end)
    {pb, _} = Enum.find(dancers, fn {_, v} -> v == b end)
    %{ dancers | pa => b, pb => a}
  end
end
