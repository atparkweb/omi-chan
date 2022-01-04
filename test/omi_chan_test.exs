defmodule OmiChanTest do
  use ExUnit.Case
  doctest OmiChan

  test "greets the world" do
    assert OmiChan.hello() == :world
  end
end
