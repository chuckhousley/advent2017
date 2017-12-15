defmodule Advent2017.Day15 do
  def start() do
    a = 722
    b = 354
    #ta = 65
    #tb = 8921
    loop(a, b, 0, 0)
  end

  #def loop(_, _, acc, 40000000), do: acc
  def loop(_, _, acc, 5000000), do: acc
  def loop(a, b, acc, iter) do
    #na = next(a, :a)
    #nb = next(b, :b)
    na = next(a, :a) |> check(:a)
    nb = next(b, :b) |> check(:b)
    case rem(na, 65536) == rem(nb, 65536) do
      true -> loop(na, nb, acc+1, iter+1)
      false -> loop(na, nb, acc, iter+1)
    end
  end

  def next(val, :a), do: rem(val*16807, 2147483647)
  def next(val, :b), do: rem(val*48271, 2147483647)
  def check(val, :a) do
    cond do
      rem(val, 4) == 0 -> val
      true -> next(val, :a) |> check(:a)
    end
  end
  def check(val, :b) do
    cond do
      rem(val, 8) == 0 -> val
      true -> next(val, :b) |> check(:b)
    end
  end

end

