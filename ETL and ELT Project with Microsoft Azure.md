# Project Documentation

## Introduction
The goal of this project was to stream data from a fictional Vendee Global race. The data was produced by a program, not by actual boats. We used Power BI to plot where the boats were and a program to calculate the place of each boat in the race. Since our data came from the start of the race, it was legitimate to calculate place in the race based on distance from the starting point, which we did in a Python workbook run with a Synapse data pipeline. The code and Power BI report included here are for the batch data, calculated through the workbook. The live-streaming data went directly to Power BI.

## Documentation

### Conducted steps in Azure
- [Link to ETL and ELT Project Document](/Steps%20for%20the%20ETL%20and%20ELT%20Project.pdf)

### Python script for calculating the location of boats

```python
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

```

## Dashboard 
<img src="/PowerBI%20Dashboard%20for%20ETL%20and%20ELT%20Project.png" alt="Dashboard Screenshot" width="900"/>

This live dashboard showcases boat locations, leading positions, top distances traveled, and speeds. The dashboard offers both transparency and ease of access in one centralized location.
