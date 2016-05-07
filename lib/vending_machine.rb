require 'coin_evaluator'

class VendingMachine
	attr_accessor :current_value
	attr_accessor :coin_return
	attr_accessor :products
	attr_reader :available_quarters, :available_dimes, :available_nickels

	def initialize(available_quarters = [], available_dimes = [], available_nickels = [])
		@current_value = 0
		@coin_return = []
		@products = {}
		@available_quarters = available_quarters
		@available_dimes = available_dimes
		@available_nickels = available_nickels
	end

	def insert(coin)
		determinedValue, coinType = CoinEvaluator.coin_value(coin.weight, coin.thickness)
		if determinedValue.nil? then
			return_coin(coinType, coin)
			raise "Invalid Coin Inserted"
		elsif determinedValue == 1
			return_coin(coinType, coin)
		else
			@current_value = (@current_value + determinedValue/100.0).round(2)
			add_coin(coinType, coin)
		end
	end

	def make_change(coinsToReturn)
		if coinsToReturn[:numberOfQuarters] > 0 then
					return_coin(:quarter, nil, coinsToReturn[:numberOfQuarters])
				end
				if coinsToReturn[:numberOfDimes] > 0 then
					return_coin(:dime, nil, coinsToReturn[:numberOfDimes])
				end
				if coinsToReturn[:numberOfNickels] > 0 then
					return_coin(:nickel, nil, coinsToReturn[:numberOfNickels])
				end
	end

	def return_coin(coinType, coin = nil, count = 1)
		coinToReturn = coin_to_return!(coinType, coin)
		count.times { @coin_return << coinToReturn }
	end

	def add_coin(coinType, coin)
		case coinType
		when :quarter
			@available_quarters << coin
		when :dime
			@available_dimes << coin
		when :nickel
			@available_nickels << coin
		end
	end

	def press_button(item)
		soldOut = !in_stock(item)
		return display_sold_out_message if soldOut

		didVend = false
		price = @products[item][:price]
		if price <= @current_value then
			if vend(item) then
				amountOfChangeInCents = (@current_value - price) * 100
				coinsToReturn = CoinEvaluator.determine_coins_for_making_change(amountOfChangeInCents)
				make_change(coinsToReturn)
				didVend = true
				@current_value = 0.00
			end
		end
		display(item, didVend)
	end

	def in_stock(item)
		@products[item][:quantity] > 0
	end

	def exact_change_needed
		@available_dimes.length < 1 && @available_nickels.length < 2
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

	def display(item = nil, didVend = nil)
		return to_s if didVend.nil?

		if !didVend then
			show_price(item)
		else
			"THANK YOU"
		end
	end

	def display_sold_out_message
		"SOLD OUT"
	end

	def show_price(item)
		"PRICE: #{format_as_currency(@products[item][:price])}"
	end

	def format_as_currency(price)
		sprintf "%.2f", price
	end

	def to_s
		return "EXACT CHANGE ONLY" if exact_change_needed
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

	# NOTE: The ability to load more coins to replenish available coins is likely to be needed in the future.
	# For now, this is not needed so I am commenting it out. If it turns out we don't need it in initial completed version,
	# this method should be deleted
	#
	# def load_more_coins(quarters, dimes, nickels)
	# 	@available_quarters = @available_dimes << quarters
	# 	@available_dimes = @available_dimes << dimes
	# 	@available_nickels = @available_nickels << nickels
	# end

	private
	def coin_to_return!(coinType, coin = nil)
		coinToReturn = nil
		case coinType
		when :quarter
			coinToReturn = @available_quarters.pop
		when :dime
			coinToReturn = @available_dimes.pop
		when :nickel
			coinToReturn = @available_nickels.pop
		else
			coinToReturn = coin
		end

		coinToReturn
	end

end