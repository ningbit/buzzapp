require 'eventmachine'

@@buzzed_in = false

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
	    string = "#{@name} from Team #{@team}"

	    if Random.rand(2) > 0
	    	string += "has buzzed in"
	    end

		if @@buzzed_in == true

			render :text => 'Too Late', :status => '403'

		else

		    respond_to do |format|
		       format.html { redirect_to buzz_url }
		    end

		    @@buzzed_in = true

		    EM.run do
		    	EM.defer( proc do speak string; end )
		    	# EM.defer { sleep 4; @@buzzed_in = false }
			end



		end

	end

	def reset

		@@buzzed_in = false

	    respond_to do |format|
	      format.html
	    end

	end

	def speak(string)

		eval "system \"say #{string}\""

	end
end