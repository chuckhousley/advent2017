defmodule Advent2017.Day11 do
  def start() do
    get_file()
    |> calc_coords
    |> calc_distance({0, 0, 0})
  end

  def start2() do
    get_file() |> find_max_distance
  end

  def get_file() do
    "./hex.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(",")
  end

  def calc_coords(input) do
    Enum.reduce(input, {0, 0, 0}, &step/2)
  end

  def calc_distance({x1, y1, z1}, {x2, y2, z2}) do
    div(abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2), 2)
  end

  def find_max_distance(input) do
    {_, max} = Enum.reduce(input, {{0, 0, 0}, 0}, fn(x, {c, m}) ->
      new_coord = step(x, c)
      {new_coord, max(m, calc_distance(new_coord, {0, 0, 0}))}
    end)
    max
  end

  def step("nw", {x, y, z}), do: {x - 1, y + 1, z}
  def step("n",  {x, y, z}), do: {x, y + 1, z - 1}
  def step("ne", {x, y, z}), do: {x + 1, y, z - 1}
  def step("sw", {x, y, z}), do: {x - 1, y, z + 1}
  def step("s",  {x, y, z}), do: {x, y - 1, z + 1}
  def step("se", {x, y, z}), do: {x + 1, y - 1, z}
end
