require 'eventmachine'

class BuzzController < ApplicationController

	@@buzzed_in = false
	@@game_started = false
	@@active_team = 'null'
	@@active_player = 'null'
	@@teams = {
		'Aztec Tribe' => 5,
		'Blue' => 0,
		'Yellow'=> 0
	}

	def index

		@teams = @@teams
		@name = params[:name][/[a-zA-Z0-9\s]*/] if params[:name]
		@team = params[:team][/[a-zA-Z0-9\s]*/] if params[:team]

	    respond_to do |format|
	      format.html # index.html.erb
	    end
	end

	def buzz

		if @@game_started

		    @@active_player = params[:name][/[a-zA-Z0-9\s]*/]
		    @@active_team = params[:team][/[a-zA-Z0-9\s]*/]
		    string = "#{@@active_player} from Team #{@@active_team}"

		    string += "has buzzed in" if Random.rand(2) > 0

			if @@buzzed_in == true

				render :text => 'Too Late', :status => '403'

			else

			    respond_to do |format|
			       format.html { redirect_to buzz_url }
			    end

			    @@buzzed_in = true

			    speak string

			end

		else

			render :text => 'Wait', :status => '401'

		end

	end

	def controls

		@game_started = @@game_started

	    respond_to do |format|
	      format.html
	    end
	end

	def results
		@teams = @@teams
		highscore = @teams.map { |key,value| value }.sort.reverse.first
		@highscore = highscore > 0 ? highscore : 999

	    respond_to do |format|
	      format.html
	    end

	end

	def reset

		reset_buzzer
		render :text => 'Reset', :status => '200'

	end

	def right

		reset_buzzer

		add_points

		string = [
			"Team #{@@active_team} gets 1 point",
			"#{@@active_player} scores a point for Team #{@@active_team}",
			"#{@@active_player} is right",
			"Good job #{@@active_player}, 1 point",
			"That is correct",
			"Team #{@@active_team} now has #{get_points} points"
		]
		speak string[rand(string.length)]

		render :text => 'Right', :status => '200'

	end

	def wrong

		remove_points

		reset_buzzer
		string = [
			"Team #{@@active_team} loses 1 point",
			"#{@@active_player} loses a point for Team #{@@active_team}",
			"That is incorrect, minus 1",
			"That is not the right answer",
			"Team #{@@active_team} now has #{get_points} points"
		]
		speak string[rand(string.length)]

		render :text => 'Wrong', :status => '200'

	end

	def start

		@@game_started = true
		@@buzzed_in = false
		render :text => 'Start', :status => '200'

	end

	def pause

		@@game_started = false
		render :text => 'Pause', :status => '200'

	end

	def speak(string)

	    EM.run do
	    	EM.defer( proc do
	    		eval "system \"say #{string}\""
	    	end)
		end

	end

	def reset_buzzer
		@@buzzed_in = false
	end

	def add_points

		@@teams[@@active_team] += 1;

	end

	def remove_points

		@@teams[@@active_team] -= 1;

	end

	def get_points
		points = @@teams[@@active_team]
		return points > 0 ? points : "negative #{points.abs}"
	end
end