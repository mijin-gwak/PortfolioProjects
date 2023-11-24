# Project Documentation

## Introduction
The goal of this project was to stream data from a fictional Vendee Global race. The data was produced by a program, not by actual boats. We used Power BI to plot where the boats were and a program to calculate the place of each boat in the race. Since our data came from the start of the race, it was legitimate to calculate place in the race based on distance from the starting point, which we did in a Python workbook run with a Synapse data pipeline. The code and Power BI report included here are for the batch data, calculated through the workbook. The live-streaming data went directly to Power BI.

## Documentation

### Conducted steps in Azure
- [Link to ETL and ELT Project Document](/Steps%20for%20the%20ETL%20and%20ELT%20Project.pdf)

### Python Script for calculating the location of boats
- [Link to Python Script](/finalbatchoutput.py)

### Dashboard 
<img src="/PowerBI%20Dashboard%20for%20ETL%20and%20ELT%20Project.png" alt="Dashboard Screenshot" width="900"/>

This live dashboard showcases boat locations, leading positions, top distances traveled, and speeds. The dashboard offers both transparency and ease of access in one centralized location.
