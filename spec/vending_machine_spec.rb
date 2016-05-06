require_relative 'spec_helper'
require 'vending_machine'
require 'coin'

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
		@vender = VendingMachine.new
	end

	it "shows INSERT COIN when no coin is inserted yet" do
		expect(@vender.to_s).to eq("INSERT COIN")
	end
	it "will accept valid coins" do
			@vender.insert(@nickel)
			expect(@vender.to_s).to eq("0.05")
			@vender.insert(@dime)
			expect(@vender.to_s).to eq("0.15")
			@vender.insert(@quarter)
			expect(@vender.to_s).to eq("0.40")
	end
	it "will reject invalid coins and return coin" do
			@vender.insert(@penny)
			expect(@vender.coin_return).to eq([@penny])
			expect(@vender.to_s).to eq("INSERT COIN")
			@vender.insert(@dime)
			@vender.insert(@penny)
			expect(@vender.coin_return).to eq([@penny, @penny])
			expect(@vender.to_s).to eq("0.10")
	end
end

describe "vending machine allows selection of products" do
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

			@products = [
				{ :name => :cola, :price => 1.00, :quantity => 10 },
				{ :name => :chips, :price => 0.50, :quantity => 20 },
				{ :name => :candy, :price => 0.65, :quantity => 30 }
			]

	end
	before(:each) do
		@vender = VendingMachine.new
		@vender.load_products(@products)
	end

	it "products can be loaded to vending machine" do
		expect(@vender.products).to eq(3)
	end

	it "displays INSERT COIN when no coins have been inserted yet" do
		expect(@vender.to_s).to eq("INSERT COIN")
		expect(@vender.current_value).to eq(0.00)
	end

	it "displays PRICE:1.00 when Cola button pressed when no coins have been inserted yet" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 1.00")

	end

	it "displays PRICE:0.50 when Chips button pressed when no coins have been inserted yet" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed when no coins have been inserted yet" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.65")
	end

	it "displays PRICE:1.00 when Cola button pressed with invalid coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 1.00")

	end

	it "displays PRICE:0.50 when Chips button pressed with invalid coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed with invalid coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.65")
	end

	it "displays PRICE:1.00 when Cola button pressed with insufficient coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 1.00")

	end

	it "displays PRICE:0.50 when Chips button pressed with insufficient coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed with insufficient coins inserted" do
		@vender.insert(@penny)
		expect(@vender.to_s).to eq("PRICE: 0.65")
	end
end
