class Measurement < ActiveRecord::Base
belongs_to :user

	def oauth_token(current_user)
		@token = current_user.oauth_token
	end

	def oauth_secret(current_user)
		@secret = current_user.oauth_secret
	end

	def provider(current_user)
		@provider = current_user.provider
	end

	def self.get_fitbit_data(current_user)
		id = current_user.uid
		client = Fitbit::Client.new({consumer_key: ENV["CONSUMER_KEY"], consumer_secret: ENV["CONSUMER_SECRET"], token: current_user.oauth_token, secret: current_user.oauth_secret, user_id: id})
		access_token = client.reconnect(current_user.oauth_token, current_user.oauth_secret)
		activities = client.activities_on_date(Time.now)
		device = client.devices[0]
		Measurement.create(user_id: current_user.id,
												 active_score: activities["summary"]["activeScore"],
												 calories_bmr: activities["summary"]["caloriesBMR"],
												 calories_out: activities["summary"]["caloriesOut"],
												 distances_total_distance: activities["summary"]["distances"][0]["distance"],
												 distances_tracker_distance: activities["summary"]["distances"][1]["distance"],
												 distances_logged_distance: activities["summary"]["distances"][2]["distance"],
												 distances_veryactive_distance: activities["summary"]["distances"][3]["distance"],
												 distances_moderateactive_distance: activities["summary"]["distances"][4]["distance"],
												 distances_lightlyactive_distance: activities["summary"]["distances"][5]["distance"],
												 distances_sedentaryactive_distance: activities["summary"]["distances"][6]["distance"],
												 fairly_active_min: activities["summary"]["fairlyActiveMinutes"],
												 lightly_active_min: activities["summary"]["lightlyActiveMinutes"],
												 marginal_calories: activities["summary"]["marginalCalories"],
												 sedentary_min: activities["summary"]["sedentaryMinutes"],
												 steps_taken: activities["summary"]["steps"],
												 veryActive_min: activities["summary"]["veryActiveMinutes"],
												 device_battery: device["battery"],
												 device_version: device["deviceVersion"],
												 active_minutes_goal: activities["goals"]["activeMinutes"],
												 calories_out_goal: activities["goals"]["caloriesOut"],
												 distance_goal: activities["goals"]["distance"],
												 steps_goal: activities["goals"]["steps"])
	end
end