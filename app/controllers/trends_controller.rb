require 'twitter'


class TrendsController < ApplicationController

	before_action :setup
	

	def index
		@trends_available = City.all

		if @trends_available.empty?
			@trends_available = @client.trends_available

			@trends_available.each do |c| 
				City.create(name: c.name, woeid: c.woeid)
			end
		end

		render :json => @trends_available
	end

	def place
		@city = City.find_by_woeid(params[:woe_id])


		if @city && !@city.trendlist.nil?
			render :json => @city.trendlist
		else


			# if @trends_place && @trends_place.trendlist.blank?
					@city.trendlist = JSON.generate(@client.trends(params[:woe_id]))
					@city.save
			
			render :json => @city.trendlist
			# else
		end
			# 	render :json => []
			# end
		
	end

	def search 
		# I should cache this too
										# change this to params
		@search_results = @client.search(params[:query], options = {:result_type => "popular"})

		render :json => @search_results
	end

	
	private 

	def setup

		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = 'aIuwlG52XoW9MU4KIR8TJw2n3'
			config.consumer_secret     = '5m4I2UMJlaqb45AjwTw4nBYQ9VXVjaXnK7m2cU5KurD1O7nAV0'
			config.access_token        = '404807959-m70NjOcjVAY7R8LImhtlFSItn8VjbZajqIOVnOT3'
			config.access_token_secret = 'RvWcEcQWI6SHrojsbw8HVCCTrMKwmOemUksel0a22Bb6F'
		end

	end

end
