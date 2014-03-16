#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json


provinces = {}

# Read geojson file
json_data=open('../app/data/govt_valdistrikt2010.geojson')
geodata = json.load(json_data)
for feature in geodata['features']:
    province = feature['properties']['LKFV'][0:2]
    if province not in provinces:
    	provinces[province] = { "type": "FeatureCollection", "features": [] }
    provinces[province]["features"].append(feature)

for province, data in provinces.iteritems():
	with open('../app/data/provinces/%s.geojson' % (province), 'w') as outfile:
  		json.dump(data, outfile)