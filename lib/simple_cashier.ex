defmodule SimpleCashier do
  @moduledoc false

  def calculate_price(items, prices \\ nil, deals \\ nil)

  def calculate_price(items, prices, deals) when is_binary(items) do
    items
    |> String.split(",")
    |> calculate_price(prices, deals)
  end

  def calculate_price(items, prices, deals) do
    prices = prices || default_prices()
    deals = deals || default_deals()

    items
    |> Enum.frequencies()
    |> Enum.reduce(0.0, &(&2 + price_for_item(&1, prices, deals)))
  end

  def default_deals,
    do: %{
      "GR1" => %{type: :x_for_the_price_of_one, multiplyer: 2},
      "SR1" => %{type: :bulk, min_bought: 3, modify_price_fn: fn _ -> 4.50 end},
      "CF1" => %{type: :bulk, min_bought: 3, modify_price_fn: fn price -> 2 / 3 * price end}
    }

  def default_prices,
    do: %{
      "GR1" => 3.11,
      "SR1" => 5.00,
      "CF1" => 11.23
    }

  defp price_for_item({item, item_frequency}, prices, deals) do
    deal = Map.get(deals, item)
    original_price_per_item = Map.get(prices, item)

    apply_deal(item_frequency, deal, original_price_per_item)
  end

  defp apply_deal(
         item_frequency,
         %{type: :x_for_the_price_of_one, multiplyer: _} = deal,
         original_price
       ),
       do:
         (div(item_frequency, deal.multiplyer) + rem(item_frequency, deal.multiplyer)) *
           original_price

  defp apply_deal(
         item_frequency,
         %{type: :bulk, min_bought: min_bought, modify_price_fn: _} = deal,
         original_price
       )
       when item_frequency >= min_bought do
    price_per_item =
      deal
      |> Map.get(:modify_price_fn)
      |> apply([original_price])

    item_frequency * price_per_item
  end

  defp apply_deal(item_frequency, _deal, original_price),
    do: item_frequency * original_price
end
