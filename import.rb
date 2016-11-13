# This file can be invoked by installing ruby 2.3.x and invoked by
# changing directory to the root of the project and entering:
# >ruby import.rb 

require 'json'
require 'csv'
IMPORT_JSON_FILE = 'resources/dataset/restaurants_list.json'
IMPORT_CSV_FILE = 'resources/dataset/restaurants_info.csv'
EXPORT_JSON_FILE = 'export_for_algolia.json'

# import the json and csv files
json_object = JSON.parse(IO.read(IMPORT_JSON_FILE, encoding:'utf-8'))    
csv_object = CSV.parse(File.read(IMPORT_CSV_FILE), headers: true, col_sep: ";")

json_object.map do | json_row |
	objectID =  json_row['objectID']
	# retrieve the first matching csv row - to simulate a join
	csv_row = csv_object.detect{|csv_row| csv_row['objectID'] == objectID.to_s }
	json_row['food_type'] = csv_row['food_type']
	# coerce the stars_count to a float (so results can be ordered)
	json_row['stars_count'] = csv_row['stars_count'].to_f
	# coerce the reviews_count to an integer
	json_row['reviews_count'] = csv_row['reviews_count'].to_i
	json_row['neighborhood'] = csv_row['neighborhood']
	json_row['phone_number'] = csv_row['phone_number']
	# todo: could later refine this to a min & max price_range
	json_row['price_range'] = csv_row['price_range']
	json_row['dining_style'] = csv_row['dining_style']
end

# export_json = JSON.dump(json_object, IO.write(EXPORT_JSON_FILE, json_object))
File.open(EXPORT_JSON_FILE,"w") {|f| f.write(json_object.to_json) }

