require 'coin_evaluator'

class VendingMachine
	attr_accessor :current_value
	attr_accessor :coin_return
	attr_accessor :products

	def initialize
		@current_value = 0
		@coin_return = []
		@products = {}
	end

	def insert(coin)
		determinedValue = CoinEvaluator.coin_value(coin.weight, coin.thickness)
		if determinedValue.nil? then
			return_coin(coin)
			raise "Invalid Coin Inserted"
		elsif determinedValue == 1
			return_coin(coin)
		else
			@current_value = (@current_value + determinedValue/100.0).round(2)
		end
	end

	def return_coin(coin)
		@coin_return << coin
	end

	def press_button(item)
		shouldVend = false
		price = @products[item][:price]
		if price <= @current_value then
			if vend(item) then
				@current_value = @current_value - price
			end
		end
		display(item, shouldVend)
	end

	def in_stock(item)
		@products[item][:quantity] > 0
	end

	def vend(item)
		didVend = false
		if in_stock(item) then
			dispense(item)
			didVend = true
		end
		didVend
	end

	def dispense(item)
		@products[item][:quantity] = @products[item][:quantity] - 1
	end

	def display(item = nil, shouldVend = nil)
		return to_s if shouldVend.nil?

		if !shouldVend then
			show_price(item)
		else
			"THANK YOU"
		end
	end

	def show_price(item)
		"PRICE: #{format_as_currency(@products[item][:price])}"
	end

	def format_as_currency(price)
		sprintf "%.2f", price
	end

	def to_s
		return "INSERT COIN" if @current_value <= 0
		format_as_currency(@current_value)
	end
	
	def load_products(products)
		products.keys.each do |key|
			if !@products[key].nil? then
				quantity = @products[key][:quantity] + products[key][:quantity]
			else
				quantity = products[key][:quantity]
			end
			@products[key] = { price: products[key][:product].price, quantity: quantity }

		end
	end
end