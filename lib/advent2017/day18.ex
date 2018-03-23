defmodule Advent2017.Day18 do
  defmodule Reg do
    defstruct a: 0, b: 0, f: 0, i: 0, p: 0, next: 0, master: 0, oth: 0
  end
  alias String, as: S
  def start() do
    get_file()
    |> duet()
  end

  def start2() do
    input = get_file()

    cpu_0 = spawn_link(__MODULE__, :start_cpu, [input, %Reg{p: 0}, self()])
    cpu_1 = spawn_link(__MODULE__, :start_cpu, [input, %Reg{p: 1}, self()])

    send(cpu_0, {:run, cpu_1})
    send(cpu_1, {:run, cpu_0})

    detect_deadlock(cpu_1, 0)
  end

  def start_cpu(input, register, pid) do
    other = receive do
      {:run, other} -> other
    end

    register = %{register | master: pid, oth: other}
    duet(input, 0, register)
  end

  defp detect_deadlock(cpu_1, count) do
    receive do
      {^cpu_1, :snd} -> detect_deadlock(cpu_1, count + 1)
    after
      500 -> count
    end
  end

  def get_file() do
    "./duet.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&S.split(&1, " ", trim: true))
    |> Enum.with_index
    |> Map.new(fn {y, x} -> {x, y} end)
  end

  def duet(input, inst\\0, reg\\%Reg{})
  def duet(input, inst, reg) do
    instruction = Map.get(input, inst)
    {new_reg, offset} = op(reg, instruction)
    duet(input, inst + offset, new_reg)
  end

  def op(reg, ["snd", x]) do
    # IO.puts "Playing #{x}: #{Map.get(reg, S.to_atom(x))}"
    send(reg.master, {self(), :snd})
    send(reg.oth, {:snd, Map.get(reg, S.to_atom(x))})
    {reg, 1}
  end

  def op(reg, ["set", x, y]) do
    a_y = S.to_atom(y)
    case Map.has_key?(reg, a_y) do
      true  -> {%{reg | S.to_atom(x) => Map.get(reg, a_y)}, 1}
      false -> {%{reg | S.to_atom(x) => S.to_integer(y)}, 1}
    end
  end

  def op(reg, ["add", x, y]) do
    a_x = S.to_atom(x)
    a_y = S.to_atom(y)
    val_x = Map.get(reg, a_x)
    case Map.has_key?(reg, a_y) do
      true  -> 
        val_y = Map.get(reg, a_y)
        {%{reg | S.to_atom(x) => val_x + val_y}, 1}
      false -> 
        {%{reg | S.to_atom(x) => val_x + S.to_integer(y)}, 1}
    end
  end

  def op(reg, ["mul", x, y]) do
    a_x = S.to_atom(x)
    a_y = S.to_atom(y)
    val_x = Map.get(reg, a_x)
    case Map.has_key?(reg, a_y) do
      true  -> 
        val_y = Map.get(reg, a_y)
        {%{reg | S.to_atom(x) => val_x * val_y}, 1}
      false -> 
        {%{reg | S.to_atom(x) => val_x * S.to_integer(y)}, 1}
    end
  end

  def op(reg, ["mod", x, y]) do
    a_x = S.to_atom(x)
    a_y = S.to_atom(y)
    val_x = Map.get(reg, a_x)
    case Map.has_key?(reg, a_y) do
      true  -> 
        val_y = Map.get(reg, a_y)
        {%{reg | S.to_atom(x) => rem(val_x, val_y)}, 1}
      false -> 
        {%{reg | S.to_atom(x) => rem(val_x, S.to_integer(y))}, 1}
    end
  end

  def op(reg, ["rcv", x]) do
    receive do
      {:snd, value} -> {%{reg | S.to_atom(x) => value}, 1}
    end
  end

  def op(reg, ["jgz", x, y]) do
    a_x = S.to_atom(x)
    a_y = S.to_atom(y)
    val_x = Map.get(reg, a_x)
    cond do
      val_x <= 0 -> {reg, 1}
      Map.has_key?(reg, a_y) -> {reg, Map.get(reg, a_y)}
      true -> {reg, S.to_integer(y)}
    end
  end
end
