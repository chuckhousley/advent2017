defmodule Advent2017.Day9 do
  def start() do
    get_file()
    |> step(0, 0, 0)
  end

  def get_file() do
    "./stream.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r{}, trim: true)
  end

  def step([], _layer, acc, garb), do: {acc, garb}
  def step([h | t], layer, acc, garb) do
    case h do
      "{" -> step(t, layer+1, acc, garb)
      "}" -> step(t, layer-1, acc+layer, garb)
      "<" -> garbage(t, layer, acc, garb)
       _  -> step(t, layer, acc, garb)
    end
  end

  def garbage([h | t], layer, acc, garb) do
    case h do
      ">" -> step(t, layer, acc, garb)
      "!" -> garbage(tl(t), layer, acc, garb)
       _  -> garbage(t, layer, acc, garb+1)
    end
  end
end
