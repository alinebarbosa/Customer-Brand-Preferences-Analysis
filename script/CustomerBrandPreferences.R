##### Data analytics II - Task 2
#### Classification: Predict which Brand of Products Customers Prefer

#### Load packages and set seed
pacman::p_load(caret, 
               readr, 
               ggplot2, 
               C50, 
               DataExplorer)
set.seed(123)

#### Upload the data with the Complete Responses
CompleteResponses <- read_csv("/home/aline/Documentos/Ubiqum/Data analytics II/M2T2/CustomerBrandPreferences/data/CompleteResponses.csv")

##### Preprocessing
#### Get to know the data
summary(CompleteResponses)
sum(is.na(CompleteResponses))
#### Convert numeric variables to factor
CompleteResponses$elevel <- as.factor(CompleteResponses$elevel)
CompleteResponses$car <- as.factor(CompleteResponses$car)
CompleteResponses$zipcode <- as.factor(CompleteResponses$zipcode)
CompleteResponses$brand <- factor(CompleteResponses$brand, 
                                  labels=c("Acer","Sony"))

#### Split training dataset in 75% and 25%
index <- createDataPartition(CompleteResponses$brand, 
                             p = 0.75, 
                             list = F)
TrainSet <- CompleteResponses[index,]
TestSet <- CompleteResponses[-index,]

#### 10 fold cross validation
fitControl <- trainControl(method = "repeatedcv", 
                           number = 10, 
                           repeats = 1)


##### C5.0 Model
#### Build a model using C5.0 with Automatic Tuning Grid and tuneLength = 2
c50Fit <- train(brand~., 
                data = TrainSet, 
                method = "C5.0", 
                trControl = fitControl, 
                tuneLength = 2)
c50Fit
varImp(c50Fit)
#### A model with only salary and age
c50FeaturedFit <- train(brand~age+salary, 
                data = TrainSet, 
                method = "C5.0", 
                trControl = fitControl, 
                tuneLength = 2)
c50FeaturedFit
varImp(c50FeaturedFit)


##### Random Forest Model #####
#### Build a model using Random Forest with Manual Grid and 5 mtry values ####
rfGrid <- expand.grid(mtry = c(11, 12, 13, 14, 15))
rfFit <- train(brand~., 
               data = TrainSet, 
               method = "rf", 
               trControl = fitControl, 
               tuneGrid = rfGrid)
rfFit
varImp(rfFit)
#### A model with only salary and age
rfFeaturedFit <- train(brand~salary+age, 
               data = TrainSet, 
               method = "rf", 
               trControl = fitControl, 
               tuneGrid = rfGrid)
rfFeaturedFit
varImp(rfFeaturedFit)

#### Upload the data with the Incomplete Responses
SurveyIncomplete <- read_csv("/home/aline/Documentos/Ubiqum/Data analytics II/M2T2/CustomerBrandPreferences/data/SurveyIncomplete.csv")
#### Convert numeric variables to factor
SurveyIncomplete$elevel <- as.factor(SurveyIncomplete$elevel)
SurveyIncomplete$car <- as.factor(SurveyIncomplete$car)
SurveyIncomplete$zipcode <- as.factor(SurveyIncomplete$zipcode)
SurveyIncomplete$brand <- as.factor(SurveyIncomplete$brand)


##### Predictions
#### Predictions on the Test Set
predictionsTest <- predict(rfFit, TestSet)
summary(predictionsTest)
postResample(predictionsTest, TestSet$brand)

#### Predictions on the Survey Incomplete
predictions <- predict(rfFit, SurveyIncomplete)
plot(predictions)
summary(predictions)

#### Put all brands (from the survey and predicted) together
allBrands <- data.frame(factor(c(CompleteResponses$brand, predictions), 
                               labels=c("Acer","Sony")))
names(allBrands) <- c('brand')
summary(allBrands)
ggplot(allBrands, aes(x="",fill=brand)) + 
  geom_bar() + 
  coord_polar(theta="y") +
  theme_minimal()
