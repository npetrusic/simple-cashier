defmodule SimpleCashierTest do
  use ExUnit.Case

  describe "calculate_price/3" do
    @tag :string_items
    test "returns correct price for string items" do
      cases = [
        %{input: "GR1,SR1,GR1,GR1,CF1", result: 22.45},
        %{input: "GR1,GR1", result: 3.11},
        %{input: "SR1,SR1,GR1,SR1", result: 16.61},
        %{input: "GR1,CF1,SR1,CF1,CF1", result: 30.57}
      ]

      Enum.each(cases, fn %{input: input, result: result} ->
        assert SimpleCashier.calculate_price(input) == result
      end)
    end

    @tag :list_items
    test "returns correct price for list baskets" do
      cases = [
        %{input: ["GR1", "SR1", "GR1", "GR1", "CF1"], result: 22.45},
        %{input: ["GR1", "GR1"], result: 3.11},
        %{input: ["SR1", "SR1", "GR1", "SR1"], result: 16.61},
        %{input: ["GR1", "CF1", "SR1", "CF1", "CF1"], result: 30.57}
      ]

      Enum.each(cases, fn %{input: input, result: result} ->
        assert SimpleCashier.calculate_price(input) == result
      end)
    end

    @tag :invalid_item
    test "returns :invalid_item atom when item not in prices" do
      items = ["GR1", "SR1", "not_in_prices"]

      assert SimpleCashier.calculate_price(items) == :invalid_item
    end
  end
end
