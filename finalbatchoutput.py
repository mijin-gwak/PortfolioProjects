# -*- coding: utf-8 -*-
"""
Created on Mon Apr  3 12:16:01 2023

@author: hgiff
"""

#SELECT
#	Boat, Lat, Long;
#line for max time by boat
#Group By Boat;

import pandas as pd
from math import sin, cos, sqrt, atan2, radians, pi

df = pd.read_csv("testbatchdata_witherrors.csv", header=0) 

print(df.columns)

def dist_fromCas (lat, lon):
    # Approximate radius of earth in km
    R = 6373.0

    latr = lat*pi/180
    lonr = lon*pi/180
    latC = 38.69225437789037*pi/180
    lonC = -9.419236159278585*pi/180

    dlon = lonC - lonr
    dlat = latC - latr

    #a = sin(dlat / 2)**2 + cos(latr) * cos(latC) * sin(dlon / 2)**2
    #c = 2 * atan2(sqrt(a), sqrt(1 - a))
    c = dlat * dlon * R #made up function to test; a above throws error

    distance = R * c
    return distance

# checking the data types
print(df.dtypes)

for i in range(len(df)):
    a = df['lat']
    b = df['lon']
    df['distance']=dist_fromCas(a, b)

cols=['boat', 'timecreated']

grouped = df.groupby(cols)['distance'].max() #list is a list?

# print df1.groupby(["Name", "City"]).size().reset_index(name='count')

print(grouped.dtype)

print(grouped.head(5))