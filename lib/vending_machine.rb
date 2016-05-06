require 'coin_evaluator'

class VendingMachine
	attr_accessor :current_value

	def initialize
		@current_value = 0
	end

	def insert(coin)
		@current_value = @current_value + CoinEvaluator.coin_value(coin.weight, coin.thickness)
	end

	def to_s
		#return "INSERT_COIN" if current_value <= 0
		@current_value.to_s
	end
end