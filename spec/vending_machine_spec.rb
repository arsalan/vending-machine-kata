require_relative 'spec_helper'
require 'vending_machine'
require 'coin'

describe "vending machine can collect money from the customer" do
	before(:all) do

			@vender = VendingMachine.new
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
end
