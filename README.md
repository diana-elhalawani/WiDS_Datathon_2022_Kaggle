## READ ME 
# Women in Data Science WiDS Datathon 2022 posted on Kaggle

# Data Preparation | Linear regresssion model planning, building and evaluation in R Studio

Climate change is a pressing issue facing our species. Climate change mitigation measures are actions taken by national and local governments and businesses to 
reduce greenhouse gas emissions. According to the International Energy Agency (IEA), in 2021, the operation of buildings for heating, cooling and other electricity
consumption produced 27% of the emissions in the energy sector.

To mitigate these emissions, several measures can be implemented; such as improving a building’s envelope to reduce its thermal energy needs, thus consumption. 
In fact, retrofitting existing and relatively old buildings can reduce their energy consumption by 50 to 90%. This not only results in less greenhouse gas
emissions but also in cost savings and better living conditions for the residents.

In order to achieve net zero emissions by 2030, it is projected that the energy consumed per square meter in 2030 must be at least 35% less than that in 2021.
Prioritizing retrofitting interventions is valuable for decision-makers at local and national levels. Therefore, using data to predict the energy consumption of buildings
is useful.

The dataset for the WiDS Datathon was created in collaboration with Climate Change AI (CCAI) and Lawrence Berkeley National Laboratory (Berkeley Lab). It contains
data on 75757 buildings in the United States of America. It contains two groups of information, one related to the building characteristics and the other to observed
weather patterns at each building. In the datathon they had a train dataset and a test dataset to run the model on and submit the answers. 

In this project, only the train dataset file will be used and consequently, it will be split into train and test datasets to validate the linear regression model. 

It is assumed that the dataset has enough information to predict the output without the need for external data. 

Hypothesis: 

- The variables related to the building characteristics have a higher impact on energy consumption than the variables related to weather conditions observed. 
- The most important variable is energy star rating because it is a rating given based on the energy efficiency of the building.

The goal is to predict the energy consumption of buildings and then we will identify the buildings with the highest predicted energy consumption. This would support
policy makers in targeting retrofitting efforts, thus maximizing emission reductions from the building sector.
