defmodule Advent2017.Day10 do
  require Bitwise
  def start() do
    lengths = get_file() |> split_to_ints
    process(Enum.to_list(0..255), lengths, 0)
  end

  def get_file() do
    "./knothash.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
  end

  def split_to_ints(lengths) do
    lengths
    |> String.split(",", trim: true)
    |> Enum.map(&(String.to_integer(&1)))
  end

  def process(numbers, lengths, skip) do
    {numbers, skip} = loop(numbers, lengths, skip)
    return = calculate_return(numbers, lengths, skip)
    [x, y | _ ] = rotate(numbers, return)
    x * y
  end

  def loop(numbers, [], skip), do: {numbers, skip-1}
  def loop(numbers, [length | t], skip) do
    Enum.reverse_slice(numbers, 0, length)
    |> rotate(length+skip)
    |> loop(t, skip+1)
  end

  def rotate(l, 0), do: l
  def rotate([h | t], 1), do: t ++ [h]
  def rotate(l, n), do: rotate(rotate(l, 1), n-1)
  def calculate_return(n, l, s, i\\1) do
    length(n) - rem(((Enum.sum(l) * i) + div(s * (s+1), 2)), length(n))
  end

  # ---- part 2 ---- #
  
  def start2() do
    lengths = get_file() |> split_ascii
    process2(Enum.to_list(0..255), lengths, 0, 0)
    |> dense_hash
    |> knot_hash
  end

  def split_ascii(input) do
    input |> to_charlist |> Enum.concat([17, 31, 73, 47, 23])
  end

  def process2(numbers, lengths, skip, 64) do
    return = calculate_return(numbers, lengths, skip-1, 64)
    rotate(numbers, return)
  end

  def process2(numbers, lengths, skip, iter) do
    {numbers, skip} = loop(numbers, lengths, skip)
    process2(numbers, lengths, skip+1, iter+1)
  end

  def dense_hash(sparse_hash) do
    Enum.chunk_every(sparse_hash, 16)
    |> Enum.map(fn(x) ->
      Enum.reduce(x, 0, &Bitwise.bxor/2)
    end)
  end

  def knot_hash(dense_hash) do
    dense_hash
    |> Enum.map(&(Integer.to_string(&1, 16)))
    |> Enum.map(&(String.pad_leading(&1, 2, "0")))
    |> List.to_string
    |> String.downcase
  end
end
