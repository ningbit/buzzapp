require 'eventmachine'

class BuzzController < ApplicationController

	@@teams = {
		"Aztec Tribe" => 0,
		"Inca Empire" => 0,
		"Mayan Ruins"=> 0
	}
	@@buzzed_in = false
	@@game_started = false
	@@active_team = @@teams.keys.first
	@@active_player = "null"
	@@sounds = {
		"wrong" => {
			"sosumi" => "./Sosumi.aiff",
			"pipe" => "./smb_pipe.wav"
		},
		"right" => {
			"1up" => "./smb_1up.wav",
			"coin" => "./smb_coin.wav",
			"powerup" => "./smb_powerup.wav",
			"1up_smw" => "./smw_1up.wav",
			"coin_smw" => "./smw_coin.wav",
			"jump_smw" => "./smw_jump.wav",
			"yoshi" => "./smw_riding_yoshi.wav"
		},
		"pause" => {
			"pause" => "./smb_pause.wav"
		}
	}
	@@speed = 220

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

			if @@buzzed_in == true

				render :text => 'Too Late', :status => '403'

			else
				@@buzzed_in = true

				same_player = @@active_player == params[:name][/[a-zA-Z0-9\s]*/] ?
					true : false

			    @@active_player = params[:name][/[a-zA-Z0-9\s]*/]
			    @@active_team = params[:team][/[a-zA-Z0-9\s]*/]
			    string = !same_player ?
			    	"#{@@active_player} from Team #{@@active_team} has buzzed in" :
			    	"#{@@active_player} from Team #{@@active_team}"

			    respond_to do |format|
			       format.html { redirect_to buzz_url }
			    end

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

	def quiz

	end

	def welcome_player
		if not @@game_started

	    	player = params[:name][/[a-zA-Z0-9\s]*/]
	    	team = params[:team][/[a-zA-Z0-9\s]*/]

	    	speak "Welcome #{player}"

	    end

	    render :text => 'Welcome', :status => '200'
	end

	def welcome_team

		if not @@game_started

	    	player = params[:name][/[a-zA-Z0-9\s]*/]
	    	team = params[:team][/[a-zA-Z0-9\s]*/]

	    	speak "#{player} has joined team #{team}" if not player.empty?

	    end

	    render :text => 'Welcome', :status => '200'
	end

	def scores

		scores_str = @@teams.map do |team_name,score|
			"#{team_name} has #{get_points(team_name)}"
		end.join(",")

		speak "The current standings are as follows, #{scores_str}"

		render :text => 'Welcome', :status => '200'
	end

	def reset

		reset_buzzer
		render :text => 'Reset', :status => '200'

	end

	def right

		if @@buzzed_in

			add_points

			reset_buzzer(1.8);

			play_sound("right");

			string = [
				"Team #{@@active_team} gets 1 point",
				"#{@@active_player} scores a point for Team #{@@active_team}",
				"#{@@active_player} is right",
				"Good job #{@@active_player}, 1 point",
				"That is correct",
				"Team #{@@active_team} now has #{get_points}"
			]
			speak string[rand(string.length)]

		end

		render :text => 'Right', :status => '200'

	end

	def wrong

		if @@buzzed_in

			remove_points

			play_sound("wrong");

			reset_buzzer(1.8);

			string = [
				"Team #{@@active_team} loses 1 point",
				"#{@@active_player} loses a point for Team #{@@active_team}",
				"That is incorrect, minus 1",
				"That is not the right answer",
				"Team #{@@active_team} now has #{get_points}"
			]
			speak string[rand(string.length)]

		end

		render :text => 'Wrong', :status => '200'

	end

	def start

		play_sound("right","yoshi")

		@@game_started = true
		@@buzzed_in = false
		render :text => 'Start', :status => '200'

	end

	def pause

		play_sound("pause")

		@@game_started = false
		render :text => 'Pause', :status => '200'

	end

	def speak(string)

	    EM.run do
	    	EM.defer( proc do
	    		eval "system \"say #{string} -r #{@@speed}\""
	    	end)
		end

	end

	def play_sound(action, specific_sound = false)
		available_sounds = @@sounds[action].keys
		sound = specific_sound != false ?
			@@sounds[action][specific_sound] :
			@@sounds[action][available_sounds[rand(available_sounds.length)]]


	    EM.run do
	    	EM.defer( proc do
	    		eval "system \"afplay #{sound}\""
	    	end)
		end

	end

	def reset_buzzer(delay=0)
	    EM.run do
	    	EM.defer( proc do
	    		sleep delay
	    		@@buzzed_in = false
	    	end)
		end
	end

	def add_points

		@@teams[@@active_team] += 1;

	end

	def remove_points

		@@teams[@@active_team] -= 1;

	end

	def get_points(team=@@active_team)
		points = @@teams[team]

		if ( points == 1 || points == - 1 )
			points_str = "#{points.abs} point"
		else
			points_str = "#{points.abs} points"
		end

		points_str = "negative #{points_str}" if points < 0

		return points_str
	end
end