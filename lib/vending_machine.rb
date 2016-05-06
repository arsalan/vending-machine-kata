require 'coin_evaluator'

class VendingMachine
	attr_accessor :current_value
	attr_accessor :coin_return

	def initialize
		@current_value = 0
		@coin_return = []
	end

	def insert(coin)
		determinedValue = CoinEvaluator.coin_value(coin.weight, coin.thickness)
		if determinedValue.nil? then
			return_coin(coin)
			raise "Invalid Coin Inserted"
		end
		@current_value = (@current_value + determinedValue/100.0).round(2)
	end

	def return_coin(coin)
		@coin_return << coin
	end

	def to_s
		#return "INSERT_COIN" if current_value <= 0
		sprintf "%.2f", @current_value
	end
end