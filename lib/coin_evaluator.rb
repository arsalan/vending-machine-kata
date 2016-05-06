class CoinEvaluator
	@nickel_weight = 5.0
	@nickel_thickness = 1.95
	@dime_weight = 2.268
	@dime_thickness = 1.35
	@quarter_weight = 5.67
	@quarter_thickness = 1.75
	@penny_weight = 2.5
	@penny_thickness = 1.52

	def self.coin_value(weight, thickness)
		return 1 if weight == @penny_weight && thickness == @penny_thickness
		return 5 if weight == @nickel_weight && thickness == @nickel_thickness
		return 10 if weight == @dime_weight && thickness == @dime_thickness
		return 25 if weight == @quarter_weight && thickness == @quarter_thickness
	end
end