defmodule Advent2017.Day12 do
  def start() do
    get_file()
    |> find_group_membership(0)
    |> MapSet.size
  end

  def start2() do
    input = get_file()
    Enum.reduce(input, %MapSet{}, fn({x,_}, acc) -> 
      MapSet.put(acc, find_group_membership(input, x))
    end)
    |> MapSet.size
  end

  def get_file() do
    "./pipes.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, " <-> ")))
    |> Enum.map(fn([x, y]) -> {String.to_integer(x), String.split(y, ", ")} end)
    |> Enum.map(fn({x, y}) -> {x, Enum.map(y, &(String.to_integer(&1)))} end)
    |> Map.new
  end

  def find_group_membership(input, program) do
    connect = Map.get(input, program)
    loop(input, connect, MapSet.new())
  end

  def loop(_input, [], members), do: members
  def loop(input, connect, members) do
    {current, connect} = List.pop_at(connect, 0)
    {members, connect} = case MapSet.member?(members, current) do
      true -> {members, connect} 
      false ->
        {
          MapSet.put(members, current), 
          connect ++ Map.get(input, current)
        }
      end
    loop(input, connect, members)
  end
end
