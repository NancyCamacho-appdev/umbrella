## 
##- Ask the user for their location.
##- Get and store the user's location.
## Get the user's latitude and longitude from the Google Maps API.
##- Get the weather at the user's coordinates from the Pirate Weather API.
##- Display the current temperature and summary of the weather for the next hour.
### For each of the next twelve hours, check if the precipitation probability is greater than 10%.
    ##If so, print a message saying how many hours from now and what the precipitation probability is.
##If any of the next twelve hours has a precipitation probability greater than 10%, print "You might want to carry an umbrella!"

  ## If not, print "You probably won't need an umbrella today."



require("json")
require("open-uri")

puts "what is your location?"

user_location = gets.chomp

puts "Checking the weather at #{user_location}.."

gmaps_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

# p "getting coordinates from"
# p gmaps_url

raw_gmaps_data = URI.open(gmaps_url).read

parsed_gmaps_data = JSON.parse(raw_gmaps_data)

lat_lng = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location")

results_array = parsed_gmaps_data.fetch("results")

first_result_hash = results_array.at(0)

geometry_hash = first_result_hash.fetch("geometry")

location_hash = geometry_hash.fetch("location")

latitude = location_hash.fetch("lat")

longitude = location_hash.fetch("lng")



pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")


pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

raw_pirate_weather_data = URI.open(pirate_weather_url).read



parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data)

currently_hash = parsed_pirate_weather_data.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "It is currently #{current_temp} F"

minutely_hash = parsed_pirate_weather_data.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")

  puts "Next hour: #{next_hour_summary}"
end

hourly_hash = parsed_pirate_weather_data.fetch("hourly")

hourly_data_array = hourly_hash.fetch("data")

next_twelve_hours = hourly_data_array[1..12]

precip_prob_threshold = 0.10

any_precipitation = false

next_twelve_hours.each do |hour_hash|

  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end

coordinates = parsed_gmaps_data.fetch("results").at(0).fetch("geometry").fetch("location")

lat = coordinates.fetch("lat")
lng = coordinates.fetch("lng")


## weather_url = https://api.pirateweather.net/forecast/3RrQrvLmiUayQ84JSxL8D2aXw99yRKlx1N4qFDUE/41.8887,-87.6355

raw_pirate_weather_data = URI.open(pirate_weather_url).read





temperature = parsed_pirate_weather_data.fetch("currently").fetch("temperature")

puts temperature
