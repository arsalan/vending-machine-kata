require_relative 'spec_helper'
require 'vending_machine'
require 'coin'
require 'product'

describe "vending machine can collect money from the customer" do
	before(:all) do
			# Note: The weights and thicknesses are based on US Mint specs
			# Ref: https://www.usmint.gov/about_the_mint/?action=coin_specifications
			@nickel_weight = 5.0
			@nickel_thickness = 1.95
			@dime_weight = 2.268
			@dime_thickness = 1.35
			@quarter_weight = 5.67
			@quarter_thickness = 1.75
			@penny_weight = 2.5
			@penny_thickness = 1.52
			
			@nickel = Coin.new(@nickel_weight, @nickel_thickness)
			@dime = Coin.new(@dime_weight, @dime_thickness)
			@quarter = Coin.new(@quarter_weight, @quarter_thickness)
			@penny = Coin.new(@penny_weight, @penny_thickness)

		end

		before(:each) do
			@vendor = VendingMachine.new
			100.times { @vendor.add_coin(:quarter, @quarter) }
			100.times { @vendor.add_coin(:dime, @dime) }
			100.times { @vendor.add_coin(:nickel, @nickel) }
		end

		it "shows INSERT COIN when no coin is inserted yet" do
			expect(@vendor.display).to eq("INSERT COIN")
		end
		it "will accept valid coins" do
			@vendor.insert(@nickel)
			expect(@vendor.display).to eq("0.05")
			@vendor.insert(@dime)
			expect(@vendor.display).to eq("0.15")
			@vendor.insert(@quarter)
			expect(@vendor.display).to eq("0.40")
		end
		it "will reject invalid coins and return coin" do
			@vendor.insert(@penny)
			expect(@vendor.coin_return).to eq([@penny])
			expect(@vendor.display).to eq("INSERT COIN")
			@vendor.insert(@dime)
			@vendor.insert(@penny)
			expect(@vendor.coin_return).to eq([@penny, @penny])
			expect(@vendor.display).to eq("0.10")
		end
	end

	describe "vending machine allows selection of products and" do
		before(:all) do
			# Note: The weights and thicknesses are based on US Mint specs
			# Ref: https://www.usmint.gov/about_the_mint/?action=coin_specifications
			@nickel_weight = 5.0
			@nickel_thickness = 1.95
			@dime_weight = 2.268
			@dime_thickness = 1.35
			@quarter_weight = 5.67
			@quarter_thickness = 1.75
			@penny_weight = 2.5
			@penny_thickness = 1.52
			
			@nickel = Coin.new(@nickel_weight, @nickel_thickness)
			@dime = Coin.new(@dime_weight, @dime_thickness)
			@quarter = Coin.new(@quarter_weight, @quarter_thickness)
			@penny = Coin.new(@penny_weight, @penny_thickness)

			

		end
		before(:each) do
			@products = {
				:cola => { :product => Product.new("Cola", 1.00), :quantity => 10 },
				:chips => { :product => Product.new("Chips", 0.50), :quantity => 20 },
				:candy => { :product => Product.new("Candy", 0.65), :quantity => 30 }
			}
			@vendor = VendingMachine.new
			100.times { @vendor.add_coin(:quarter, @quarter) }
			100.times { @vendor.add_coin(:dime, @dime) }
			100.times { @vendor.add_coin(:nickel, @nickel) }
			@vendor.load_products(@products)
		end

		it "products can be loaded to vending machine" do
			expect(@vendor.products.keys.length).to eq(3)
		end

		describe "when product should not dispense," do

			it "displays INSERT COIN when no coins have been inserted yet" do
				expect(@vendor.display).to eq("INSERT COIN")
				expect(@vendor.current_value).to eq(0.00)
			end

			it "displays PRICE: 1.00 and then displays INSERT COIN when Cola button pressed when no coins have been inserted yet" do
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("PRICE: 1.00")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.50 and then displays INSERT COIN when Chips button pressed when no coins have been inserted yet" do
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("PRICE: 1.00")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.65 and then displays INSERT COIN when Candy button pressed when no coins have been inserted yet" do
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("PRICE: 1.00")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 1.00 and then displays INSERT COIN when Cola button pressed with invalid coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("PRICE: 1.00")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.50 and then displays INSERT COIN when Chips button pressed with invalid coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("PRICE: 0.50")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.65 and then displays INSERT COIN when Candy button pressed with invalid coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("PRICE: 0.65")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 1.00 and then displays INSERT COIN when Cola button pressed with insufficient coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("PRICE: 1.00")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.50 and then displays INSERT COIN when Chips button pressed with insufficient coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("PRICE: 0.50")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays PRICE: 0.65 and then displays INSERT COIN when Candy button pressed with insufficient coins inserted" do
				@vendor.insert(@penny)
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("PRICE: 0.65")
				expect(@vendor.display).to eq("INSERT COIN")
			end

		end

		describe "when product should dispense," do
			it "displays THANK YOU and then displays INSERT COIN when Cola button pressed with exact amount in coins inserted" do
				4.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays THANK YOU and then displays INSERT COIN when Chips button pressed with exact amount in coins inserted" do
				2.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays THANK YOU and then displays INSERT COIN when Candy button pressed with exact amount in coins inserted" do
				2.times { @vendor.insert(@quarter) }
				1.times { @vendor.insert(@dime) }
				1.times { @vendor.insert(@nickel) }
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
			end
			
		end

		describe "when extra coins should be returned to customer," do
			it "displays THANK YOU and then returns extra coins and then displays INSERT COIN when Cola button pressed with extra amount in coins inserted" do
				5.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
				expect(@vendor.coin_return).to eq([@quarter])
			end

			it "displays THANK YOU and then returns extra coins and then displays INSERT COIN when Chips button pressed with extra amount in coins inserted" do
				4.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
				expect(@vendor.coin_return).to eq([@quarter, @quarter])
			end

			it "displays THANK YOU and then returns extra coins and then displays INSERT COIN when Candy button pressed with extra amount in coins inserted" do
				2.times { @vendor.insert(@quarter) }
				2.times { @vendor.insert(@dime) }
				2.times { @vendor.insert(@nickel) }
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("THANK YOU")
				expect(@vendor.display).to eq("INSERT COIN")
				expect(@vendor.coin_return).to include(@dime)
				expect(@vendor.coin_return).to include(@nickel)
			end

		end

	end

	describe "vending machine allows selection of products and" do
		before(:all) do
			# Note: The weights and thicknesses are based on US Mint specs
			# Ref: https://www.usmint.gov/about_the_mint/?action=coin_specifications
			@nickel_weight = 5.0
			@nickel_thickness = 1.95
			@dime_weight = 2.268
			@dime_thickness = 1.35
			@quarter_weight = 5.67
			@quarter_thickness = 1.75
			@penny_weight = 2.5
			@penny_thickness = 1.52
			
			@nickel = Coin.new(@nickel_weight, @nickel_thickness)
			@dime = Coin.new(@dime_weight, @dime_thickness)
			@quarter = Coin.new(@quarter_weight, @quarter_thickness)
			@penny = Coin.new(@penny_weight, @penny_thickness)

			

		end
		before(:each) do
			@products = {
				:cola => { :product => Product.new("Cola", 1.00), :quantity => 0 },
				:chips => { :product => Product.new("Chips", 0.50), :quantity => 0 },
				:candy => { :product => Product.new("Candy", 0.65), :quantity => 0 }
			}
			@vendor = VendingMachine.new
			100.times { @vendor.add_coin(:quarter, @quarter) }
			100.times { @vendor.add_coin(:dime, @dime) }
			100.times { @vendor.add_coin(:nickel, @nickel) }
			@vendor.load_products(@products)
		end

		describe "when no coins inserted," do

			it "displays SOLD OUT and then INSERT COINS when Cola button pressed and product is out of stock" do
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays SOLD OUT and then INSERT COINS when Chips button pressed and product is out of stock" do
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("INSERT COIN")
			end

			it "displays SOLD OUT and then INSERT COINS when Candy button pressed and product is out of stock" do
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("INSERT COIN")
			end

		end

		describe "when coins inserted," do

			it "displays SOLD OUT and then amount inserted when correct and exact coins inserted and Cola button pressed and product is out of stock" do
				4.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("1.00")
			end

			it "displays SOLD OUT and then amount inserted when correct and exact coins inserted and Chips button pressed and product is out of stock" do
				2.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("0.50")
			end

			it "displays SOLD OUT and then amount inserted when correct and exact coins inserted and Candy button pressed and product is out of stock" do
				2.times { @vendor.insert(@quarter) }
				1.times { @vendor.insert(@dime) }
				1.times { @vendor.insert(@nickel) }
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("0.65")
			end

			it "displays SOLD OUT and then amount inserted when insufficient amount in coins inserted and Cola button pressed and product is out of stock" do
				3.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:cola)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("0.75")
			end

			it "displays SOLD OUT and then amount inserted when insufficient amount in coins inserted and Chips button pressed and product is out of stock" do
				1.times { @vendor.insert(@quarter) }
				displayed = @vendor.press_button(:chips)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("0.25")
			end

			it "displays SOLD OUT and then amount inserted when insufficient amount in coins inserted and Candy button pressed and product is out of stock" do
				1.times { @vendor.insert(@quarter) }
				1.times { @vendor.insert(@dime) }
				1.times { @vendor.insert(@nickel) }
				displayed = @vendor.press_button(:candy)
				expect(displayed).to eq("SOLD OUT")
				expect(@vendor.display).to eq("0.40")
			end

		end

		describe "before coins inserted," do
			before(:each) do
				@products = {
					:cola => { :product => Product.new("Cola", 1.00), :quantity => 10 },
					:chips => { :product => Product.new("Chips", 0.50), :quantity => 20 },
					:candy => { :product => Product.new("Candy", 0.65), :quantity => 30 }
				}
				@vendor = VendingMachine.new
				100.times { @vendor.add_coin(:quarter, @quarter) }
				@vendor.add_coin(:nickel, @nickel)
				@vendor.load_products(@products)
			end

			it "displays EXACT CHANGE ONLY instead of INSERT COIN when less than 1 dime and 2 nickels are available to make change" do
				expect(@vendor.display).to eq("EXACT CHANGE ONLY")
			end

		end
	end
