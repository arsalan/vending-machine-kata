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
		return 1, :penny if weight == @penny_weight && thickness == @penny_thickness
		return 5, :nickel if weight == @nickel_weight && thickness == @nickel_thickness
		return 10, :dime if weight == @dime_weight && thickness == @dime_thickness
		return 25, :quarter if weight == @quarter_weight && thickness == @quarter_thickness
	end

	def self.determine_coins_for_making_change(cents)
		centsAsInteger = cents.to_i
		numberOfQuarters = 0
		numberOfDimes = 0
		numberOfNickels = 0

		if centsAsInteger > 0 then
			numberOfQuarters = centsAsInteger / 25
			remainingCents = centsAsInteger % 25
			if remainingCents > 0 then
				numberOfDimes = remainingCents / 10
				remainingCents = remainingCents % 10
			end

			if remainingCents > 0 then
				numberOfNickels = (remainingCents / 5).to_i
				remainingCents = remainingCents % 5
				if remainingCents > 0 then
					raise "An invalid amount has somehow found it's way into the vending machine. Investigate."
				end
			end
		end

		{ :numberOfQuarters => numberOfQuarters, :numberOfDimes => numberOfDimes, :numberOfNickels => numberOfNickels }
	end
end