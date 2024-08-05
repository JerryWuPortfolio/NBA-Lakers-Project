# Exploratory Analysis on NBA Lakers Match Data

## Introduction
lakers.csv dataset contains nearly 35,000 rows of data and includes basketball match data for the Los Angeles Lakers and their opponents in 2008-2009. Hence, there is enough data to conduct a post-season review of the 2008-09 Los Angeles Lakers NBA team. Data is collected using LPS, with the location encoded with respect to a real basketball court. To conduct any meaningful analysis, a frame of reference has to be made. The whole review will be centered around shot distribution for every Lakers player, and the key question needing to be answered is: Who is the most effective shooter on this Lakers team?

## Preliminary Actions
### Basketball Court Model
![court](https://github.com/user-attachments/assets/a84013ef-a5e9-4379-9842-28f2d9912dd9)

A half court model of a basketball court using ggplot2, following the exact measurement of a NBA basketball court in feet. This model is essential for mapping shot location data consisting of x and y coordinates to actual location on a basketball court. 

### Data Cleaning and Wrangling
Some data cleaning and wrangling processes are needed before any meaningful result can be obtained. First step is to eliminate all rows with NA values or any expected results. Second step is to check and correct any spelling errors for players' name. Lastly, there are too many categories under shot type which is too confusing and messy when conducting analysis on shot type. Shot types are similar in nature need to be grouped together to reduce the number of categories.

### Analysis
To show the distribution of all shots taken, a faceted plot containing all shot attempted is a good starting point. From the visualisation, amount of shot taken and type of field goal attempted can be easily worked out.

![type_shot](https://github.com/user-attachments/assets/bd9f011b-2234-4729-9158-e929ebbc9853)

Visualisation on Outcome of FG attempted highlights the position of both field goals made and missed. A cluster of large number of misses with less made shot means a player need to find a better position to take a shot, large number of makes with less misses means a player shoots well from a certain spot on the court.

![outcome](https://github.com/user-attachments/assets/815764fd-af93-4038-915e-2e23568d4056)

Each players' true shooting percentage is calculated from relevant percentages and compared against league average that season. Volume of shot taken is taken into account, since high volume of shots taken usually means shots are more difficult.

![True Shooting](https://github.com/user-attachments/assets/ac4bb56e-d821-4021-8f2b-da6125faf5b8)

Similar to True Shooting percentage, effective Field Goal percentage is calculated for every player and compared against league average using bar chart.

![eFG](https://github.com/user-attachments/assets/2029e996-c00b-414b-90a6-b17efc98ba27)

### Conclusion
I decided to split shooting into three categories, separated by location on the court. These three categories are three point shooting, post scoring and overall scoring. The most effective shooter for these three categories are Pau Gasol, Derek Fisher and Kobe Bryant, backed up by amount attempted and field goal percentage from different areas on the court. 
