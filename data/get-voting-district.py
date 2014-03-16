# This function takes lat-lng coordinates and returns a geojson object of the 
# correspoing voting district accordring to 2010. 
# Province is the län of the district. This argument is not mandatory. It is only used
# to reduce the amount of parcing somewhat.

# Example: getVotingDistrict(59.33, 18.11, "Stockholms län")
def getVotingDistrict(lat, lng, province):
    province = province.encode("utf-8")

    # Open geodata either a province, or if no province given the whole country
    if province in provinces:
    	fileName = "provinces/%s" % provinces[province]
    else:
    	fileName = "govt_valdistrikt2010"
    json_data = open('data/%s.geojson' % fileName)
    geodata = json.load(json_data)

    # Check each polygon in the geodata set to see if it contains the point
    point = Point(lng, lat)
    for feature in geodata['features']:
        polygon = shape(feature['geometry'])
        if polygon.contains(point):
            return feature

