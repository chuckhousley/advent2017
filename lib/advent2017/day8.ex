defmodule Advent2017.Day8 do
  def start() do
    re = ~r/^(?<name>.+)\s(?<inst>(inc|dec))\s(?<amt>.+)\sif\s(?<ireg>.+)\s(?<op>.+)\s(?<iamt>.+)$/
    get_file()
    |> Enum.map(fn(x) -> Regex.named_captures(re, x) end)
    |> Enum.reduce(%{}, fn(x, map) -> 
         Map.put(map, x["name"], process(map, x)) 
       end) 
    |> Enum.max_by(fn({_, y}) -> y end)
  end

  def get_file() do
    "./registers.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim_trailing
    |> String.split(~r/\n/, trim: true)
  end

  def process(registers, row) do
    name = row["name"]
    inst = row["inst"]
    amt  = String.to_integer(row["amt"])

    check_name = row["ireg"]
    check_amt  = String.to_integer(row["iamt"])
    check_op   = row["op"]

    reg_to_return = find_register_value(registers, name)
    reg_to_check  = find_register_value(registers, check_name)

    case check?(reg_to_check, check_op, check_amt) do
      true  -> IO.inspect update(reg_to_return, inst, amt)
      false -> reg_to_return
    end
  end

  def update(value, "inc", amt), do: value + amt
  def update(value, "dec", amt), do: value - amt

  def check?(value, op, amt) do
    case op do
      ">"  -> value  > amt
      "<"  -> value  < amt
      ">=" -> value >= amt
      "<=" -> value <= amt
      "==" -> value == amt
      "!=" -> value != amt
    end
  end

  def find_register_value(registers, name) do
    Map.get(registers, name, 0)
  end
end
