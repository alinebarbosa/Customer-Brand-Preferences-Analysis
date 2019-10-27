# Customer Brand Preferences Analysis

Blackwell' sales team engaged a market research firm to conduct a survey of our existing customers. One of the objectives of the survey was to find out which of two brands of computers our customers prefer. This information was help them decide with which manufacturer they should pursue a deeper strategic relationship. 

Unfortunately, the answer to the brand preference question was not properly captured for all of the respondents. This project is to investigate if customer responses to some survey questions (e.g. income, age, etc.) enable us to predict the answer to the brand preference question.

To do that, we run and optimize two different decision tree classification methods in R - C5.0 and RandomForest - and compare which one works better for this data set. 

The data was the following CSV files: the file labelled CompleteResponses.csv is the data set used to train your model and build the predictive model. It includes 10,000 fully-answered surveys and the key to the survey can be found in survey_key.csv. The file labelled SurveyIncomplete.csv was main test set (the data applied in the optimized model to predict the brand preference).

To understand more and see the results, please read the report.
