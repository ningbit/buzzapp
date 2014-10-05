require 'eventmachine'

class BuzzController < ApplicationController

	def index
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: @welcomes }
	    end
	end

	def buzz

	    @name = params[:name][/[a-zA-Z0-9\s]*/]
	    @team = params[:team][/[a-zA-Z0-9\s]*/]
	    string = "#{@name} from Team #{@team} has buzzed in"

		if Buzz.count == 0

			buzz = Buzz.create!

		    respond_to do |format|
		       format.html { redirect_to buzz_url }
		    end

		    EM.run do
		    	EM.defer( proc do speak string; end )
		    	EM.defer { sleep 5; Buzz.destroy_all }
			end
		end

	end

	def speak(string)

		eval "system \"say #{string}\""

	end
end