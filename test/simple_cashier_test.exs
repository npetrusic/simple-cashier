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

      run_test_cases(cases)
    end

    @tag :list_items
    test "returns correct price for list baskets" do
      cases = [
        %{input: ["GR1", "SR1", "GR1", "GR1", "CF1"], result: 22.45},
        %{input: ["GR1", "GR1"], result: 3.11},
        %{input: ["SR1", "SR1", "GR1", "SR1"], result: 16.61},
        %{input: ["GR1", "CF1", "SR1", "CF1", "CF1"], result: 30.57}
      ]

      run_test_cases(cases)
    end

    @tag :invalid_item
    test "returns :invalid_item atom when item not in prices" do
      items = ["GR1", "SR1", "not_in_prices"]

      assert SimpleCashier.calculate_price(items) == :invalid_item
    end

    @tag :x_for_the_price_of_one
    test "returns correct price for an 'x for the price of one' deal" do
      prices = %{"test" => 5.00}
      deals = %{"test" => %{type: :x_for_the_price_of_one, multiplyer: 2}}

      cases = [
        %{input: ["test"], result: 5.00},
        %{input: ["test", "test"], result: 5.00},
        %{input: ["test", "test", "test"], result: 10.00},
        %{input: ["test", "test", "test", "test"], result: 10.00}
      ]

      run_test_cases(cases, prices, deals)
    end

    @tag :bulk
    test "returns correct price for bulk deals" do
      prices = %{"test1" => 5.00, "test2" => 6.00}

      deals = %{
        "test1" => %{type: :bulk, min_bought: 2, modify_price_fn: fn _ -> 4.00 end},
        "test2" => %{type: :bulk, min_bought: 2, modify_price_fn: fn price -> price / 2 end}
      }

      cases = [
        %{input: ["test1"], result: 5.00},
        %{input: ["test1", "test1"], result: 8.00},
        %{input: ["test2"], result: 6.00},
        %{input: ["test2", "test2"], result: 6.00}
      ]

      run_test_cases(cases, prices, deals)
    end
  end

  defp run_test_cases(cases, prices \\ nil, deals \\ nil) do
    Enum.each(cases, fn %{input: input, result: result} ->
      assert SimpleCashier.calculate_price(input, prices, deals) == result
    end)
  end
end
