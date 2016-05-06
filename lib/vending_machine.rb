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

	def to_s
		return "INSERT COIN" if @current_value <= 0
		sprintf "%.2f", @current_value
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