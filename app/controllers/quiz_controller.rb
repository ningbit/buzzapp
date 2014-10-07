class QuizController < ApplicationController

	def index
		@topics = Topic.all
		@questions = Question.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @questions }
		end
	end

end
