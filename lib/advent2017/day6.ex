defmodule Advent2017.Day6 do
  def start() do
    input = get_file()
    # input = Map.new([{0, 0}, {1, 2}, {2, 7}, {3, 0}])
    find_infinite_loop(input)
  end

  def get_file() do
    "./memory.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\t/, trim: true)
    |> Enum.map(&(String.to_integer &1))
    |> Enum.with_index
    |> Enum.map(fn({k, v}) -> {v, k} end)
    |> Map.new
  end

  def step(memory) do
    {idx, blocks} = Enum.max_by(memory, fn({_k, v}) -> v end)
    Map.replace(memory, idx, 0)
    |> redistribute(idx + 1, blocks)
  end

  def find_infinite_loop(memory, history\\%MapSet{}) do
    step(memory)
    |> check(history)
  end

  def redistribute(memory, _idx, 0), do: memory

  def redistribute(memory, idx, blocks) when idx == map_size(memory) do
    redistribute(memory, 0, blocks)
  end

  def redistribute(memory, idx, blocks) do
    Map.update!(memory, idx, &(&1 + 1))
    |> redistribute(idx + 1, blocks - 1)
  end

  def check(memory, history) do
    case MapSet.member?(history, memory) do
      # part 1
      # true  -> MapSet.size(history) + 1
      # part 1 and 2
      true  -> 
        {
          MapSet.size(history) + 1, 
          find_chosen_one(step(memory), memory, 1)
        }
      false ->
        history = MapSet.put(history, memory)
        find_infinite_loop(memory, history)
    end
  end

  def find_chosen_one(memory, chosen_one, acc) do
    case memory do
      ^chosen_one -> acc
      _ -> find_chosen_one(step(memory), chosen_one, acc+1)
    end
  end
end
