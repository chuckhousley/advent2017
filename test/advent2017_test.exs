defmodule Advent2017Test do
  use ExUnit.Case
  doctest Advent2017

  test "Day 10 test 1" do
    ans = Advent2017.Day10.process([0,1,2,3,4], [3,4,1,5], 0)
    assert ans == 12
  end

  test "Day 10 test 2" do
    lengths = [] |> Advent2017.Day10.split_ascii
    ans = Enum.to_list(0..255)
          |> Advent2017.Day10.process2(lengths, 0, 0)
          |> Advent2017.Day10.dense_hash
          |> Advent2017.Day10.knot_hash
    assert ans == "a2582a3a0e66e6e86e3812dcb672a272"
  end

  test "Day 10 test 3" do
    lengths = "AoC 2017" |> Advent2017.Day10.split_ascii
    ans = Enum.to_list(0..255)
          |> Advent2017.Day10.process2(lengths, 0, 0)
          |> Advent2017.Day10.dense_hash
          |> Advent2017.Day10.knot_hash
    assert ans == "33efeb34ea91902bb2f59c9920caa6cd"
  end

  test "Day 10 test 4" do
    lengths = "1,2,3" |> Advent2017.Day10.split_ascii
    ans = Enum.to_list(0..255)
          |> Advent2017.Day10.process2(lengths, 0, 0)
          |> Advent2017.Day10.dense_hash
          |> Advent2017.Day10.knot_hash
    assert ans == "3efbe78a8d82f29979031a4aa0b16a9d"
  end

  test "Day 10 test 5" do
    lengths = "1,2,4" |> Advent2017.Day10.split_ascii
    ans = Enum.to_list(0..255)
          |> Advent2017.Day10.process2(lengths, 0, 0)
          |> Advent2017.Day10.dense_hash
          |> Advent2017.Day10.knot_hash
    assert ans == "63960835bcdc130f0b66d7ff4f6a5a8e"
  end

  test "Day 11 test 1" do
    ans = ["ne", "ne", "ne"]
            |> Advent2017.Day11.calc_coords
            |> Advent2017.Day11.calc_distance({0, 0, 0})
    assert ans == 3
  end

  test "Day 11 test 2" do
    ans = ["ne", "ne", "sw", "sw"]
            |> Advent2017.Day11.calc_coords
            |> Advent2017.Day11.calc_distance({0, 0, 0})
    assert ans == 0
  end

  test "Day 11 test 3" do
    ans = ["ne", "ne", "s", "s"]
            |> Advent2017.Day11.calc_coords
            |> Advent2017.Day11.calc_distance({0, 0, 0})
    assert ans == 2
  end

  test "Day 11 test 4" do
    ans = ["se", "sw", "se", "sw", "sw"]
            |> Advent2017.Day11.calc_coords
            |> Advent2017.Day11.calc_distance({0, 0, 0})
    assert ans == 3
  end
end
