defmodule Advent2017.Day19 do
  def start() do
    get_file()
    |> start_maze()
  end

  def get_file() do
    "./maze.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r//, trim: true)
    |> Enum.with_index
    |> Map.new(fn {x, y} -> {{rem(y, 202), div(y, 202)}, x} end)
  end

  def start_maze(input, coords\\{0,0}) do
    case Map.get(input, coords) do
      " " -> start_maze(input, move(coords, :right))
      "|" -> step(input, coords, :down)
      _ -> IO.puts "huh"
    end
  end

  def step(input, coords, direction, letters\\[], acc\\0) do
    current = Map.get(input, coords)
    new_pos = move(coords, direction)
    acc = acc + 1
    case current do 
      "|" -> step(input, new_pos, direction, letters, acc)
      "-" -> step(input, new_pos, direction, letters, acc)
      "+" -> switch(input, coords, direction, letters, acc)
      "N" -> {letters, acc}
      _   -> step(input, new_pos, direction, letters ++ [current], acc)
    end
  end

  def move({x, y}, :left),  do: {x-1, y}
  def move({x, y}, :right), do: {x+1, y}
  def move({x, y}, :up),    do: {x, y-1}
  def move({x, y}, :down),  do: {x, y+1}

  def switch(input, coords, direction, letters, acc) do
    {new_coord, new_dir} = case Enum.any?(
      [:left, :right], fn x -> x == direction end) do
      true -> switch_vertical(input, coords)
      false -> switch_horizontal(input, coords)
    end
    step(input, new_coord, new_dir, letters, acc)
  end

  def switch_vertical(input, coords) do
    case Map.get(input, move(coords, :up)) == "|" do
      true -> {move(coords, :up), :up}
      false -> {move(coords, :down), :down}
    end
  end

  def switch_horizontal(input, coords) do
    case Map.get(input, move(coords, :left)) == "-" do
      true -> {move(coords, :left), :left}
      false -> {move(coords, :right), :right}
    end
  end
end
