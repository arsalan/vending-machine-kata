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

			@products = {
				:cola => { :product => Product.new("Cola", 1.00), :quantity => 10 },
				:chips => { :product => Product.new("Chips", 0.50), :quantity => 20 },
				:candy => { :product => Product.new("Candy", 0.65), :quantity => 30 }
			}

	end
	before(:each) do
		@vendor = VendingMachine.new
		@vendor.load_products(@products)
	end

	it "products can be loaded to vending machine" do
		expect(@vendor.products.keys.length).to eq(3)
	end

	it "displays INSERT COIN when no coins have been inserted yet" do
		expect(@vendor.display).to eq("INSERT COIN")
		expect(@vendor.current_value).to eq(0.00)
	end

	it "displays PRICE:1.00 when Cola button pressed when no coins have been inserted yet" do
		displayed = @vendor.press_button(:cola)
		expect(displayed).to eq("PRICE: 1.00")
		expect(@vendor.display).to eq("INSERT COIN")
	end

	it "displays PRICE:0.50 when Chips button pressed when no coins have been inserted yet" do
		@vendor.press_button(:chips)
		expect(@vendor.display).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed when no coins have been inserted yet" do
		@vendor.press_button(:candy)
		expect(@vendor.display).to eq("PRICE: 0.65")
	end

	it "displays PRICE:1.00 when Cola button pressed with invalid coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:cola)
		expect(@vendor.display).to eq("PRICE: 1.00")

	end

	it "displays PRICE:0.50 when Chips button pressed with invalid coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:chips)
		expect(@vendor.display).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed with invalid coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:candy)
		expect(@vendor.display).to eq("PRICE: 0.65")
	end

	it "displays PRICE:1.00 when Cola button pressed with insufficient coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:cola)
		expect(@vendor.display).to eq("PRICE: 1.00")

	end

	it "displays PRICE:0.50 when Chips button pressed with insufficient coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:chips)
		expect(@vendor.display).to eq("PRICE: 0.50")
	end

	it "displays PRICE:0.65 when Candy button pressed with insufficient coins inserted" do
		@vendor.insert(@penny)
		@vendor.press_button(:candy)
		expect(@vendor.display).to eq("PRICE: 0.65")
	end
end
