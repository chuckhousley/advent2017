defmodule Advent2017.Day5 do
  def start() do
    input = get_file()
    loop(input, 0, 0)
  end
    
  def get_file() do
    "./jumps.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&(String.to_integer &1))
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({jmp, idx}, map) -> Map.put(map, idx, jmp) end)
  end

  def loop(inst, idx, acc) do
    jmp = Map.get(inst, idx)
    case jmp do
      nil -> acc
      ^jmp when jmp < 3 -> 
        loop(Map.replace(inst, idx, jmp+1), idx+jmp, acc+1)
      ^jmp ->
        loop(Map.replace(inst, idx, jmp-1), idx+jmp, acc+1)
    end
  end
end
