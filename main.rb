#main.rb - executable code using pcr api

require './gsr.rb'
require 'json'
require 'date'
require 'sinatra/base'

class App < Sinatra::Base
	post '/' do
		gsr = GSR.new(ENV['username'], ENV['password'])
		requestData = JSON.parse(request.body.read)
		#Expect email body to be:
		#year, month, day, hour, minute, duration
		reservation = requestData['title'].split(',')
		year = reservation[0]
		month = reservation[1]
		day = reservation[2]
		hour = reservation[3]
		minute = reservation[4]
		duration = reservation[5]
		gsr.reserve('floor' => '', 
	            'start_time' => Time.new(year, month, day, hour, minute), 
	            'duration' => duration.to_i)
	end

	post '/calendarreserve' do
		#Here, we expect a POST request from IFTTT, triggered by
		#a new calendar event.  If the event is a GSR reservation,
		#the title of the request will be [StartTime]-[EndTime]
		#where a time looks like "August 31, 2013 at 10:00PM".
		#
		#We will detect GSR reservation events through the categories mechanism.
		#A GSR reservation will be titled "GSR", so we will look for that title in the
		#categories array.
		postRequest = JSON.parse(request.body.read)
		postCategories = postRequest['categories']
		if postCategories.include? "GSR"
			reservationDatetimes = postRequest['title'].split('-')
			startDatetime = DateTime.parse(reservationDatetimes[0])
			endDatetime = DateTime.parse(reservationDatetimes[1])
			duration = ((endDatetime - startDatetime) * 24 * 60).to_i
			year = startDatetime.year
			month = startDatetime.month
			day = startDatetime.day
			hour = startDatetime.hour
			minute = startDatetime.minute

			gsr = GSR.new(ENV['username'], ENV['password'])
			gsr.reserve('floor' => '', 
		            'start_time' => Time.new(year, month, day, hour, minute), 
		            'duration' => duration)
		end
	end

	post '/cancel' do
		gsr = GSR.new(ENV['username'], ENV['password'])
		gsr.cancel
	end
end