module BuzzHelper

	def speak(string)

		eval "system \"say #{string}\""

	end

end
