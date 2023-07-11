library(ggplot2)
library(corrplot)
library(Hmisc)
library(RSNNS)
library(partykit)
library(rpart)
library(e1071)
library(prediction)
library(ROCR)


# Load the data into a data frame
data_raw <- read.csv("data/creditworthiness.csv")

dim(data_raw)
#2500 rows, 46 columns

summary(data_raw)
#some columns with 0-1 ranges, 1-5, one with 1-6, class label with 0-3

sapply(data_raw, function(x) sum(is.na(x)))
#no missing values

#remove rows where class label has no credit rating
data <- subset(data_raw, data_raw[,46] > 0)
data2 <- subset(data_raw, data_raw[,46] > 0)

rawClasses <- table(data_raw[46])
rawClasses
rawClasses/sum(rawClasses)

classes <- table(data[46])
classes
classes/sum(classes)

data['credit.rating'][data['credit.rating'] == 1] <- 'A'
data['credit.rating'][data['credit.rating'] == 2] <- 'B'
data['credit.rating'][data['credit.rating'] == 3] <- 'C'
data$credit.rating


## Visualizations ##
theme_set(theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                panel.background = element_blank(), axis.line = element_line(colour = "black"),
                legend.position = 'top'))

#functionary
ggplot(data, aes(x=functionary, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=0.5) +
  labs(title="Functionary per Credit Rating", color="Credit Rating", fill="Credit Rating")

#re-balanced (paid back) a recently overdrawn current account
ggplot(data, aes(x=re.balanced..paid.back..a.recently.overdrawn.current.acount, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=0.5) +
  labs(title="re-balanced account per Credit Rating", x="re-balanced account", color="Credit Rating", fill="Credit Rating")

#FICO score
ggplot(data, aes(x=FI3O.credit.score, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=0.5) +
  labs(title="FICO Score per Credit Rating", x="FICO Score", color="Credit Rating", fill="Credit Rating")

#gender
ggplot(data, aes(x=gender, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=0.5) +
  labs(title="Gender per Credit Rating", x="Gender", color="Credit Rating", fill="Credit Rating")

#accounts at other banks
ggplot(data, aes(x=X0..accounts.at.other.banks, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Accounts at other banks per Credit Rating", x="Accounts at other banks", color="Credit Rating", fill="Credit Rating")

#credit refused in past
ggplot(data, aes(x=credit.refused.in.past., color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Credit refused in past per Credit Rating", x="Credit refused in past", color="Credit Rating", fill="Credit Rating")

#years employed
ggplot(data, aes(x=years.employed, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="No. of years employed per Credit Rating", x="Years Employed", color="Credit Rating", fill="Credit Rating")

#savings in other accounts
ggplot(data, aes(x=savings.on.other.accounts, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Savings in other accounts per Credit Rating", x="Savings in other accounts", color="Credit Rating", fill="Credit Rating")

#self employed
ggplot(data, aes(x=self.employed., color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Self Employed per Credit Rating", x="Self Employed", color="Credit Rating", fill="Credit Rating")

#max acc balance 12 months ago
ggplot(data, aes(x=max..account.balance.12.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account Balance 12 months ago per Credit Rating", x="Max Account balance 12 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 12 months ago
ggplot(data, aes(x=min..account.balance.12.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account Balance 12 months ago per Credit Rating", x="Min Account balance 12 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 12 months ago
ggplot(data, aes(x=avrg..account.balance.12.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account Balance 12 months ago per Credit Rating", x="Avg Account balance 12 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 11 months ago
ggplot(data, aes(x=max..account.balance.11.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account Balance 11 months ago per Credit Rating", x="Max Account balance 11 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 11 months ago
ggplot(data, aes(x=min..account.balance.11.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account Balance 11 months ago per Credit Rating", x="Min Account balance 11 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 11 months ago
ggplot(data, aes(x=avrg..account.balance.11.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account Balance 11 months ago per Credit Rating", x="Avg Account balance 11 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 10 months ago
ggplot(data, aes(x=max..account.balance.10.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account Balance 10 months ago per Credit Rating", x="Max Account balance 10 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 10 months ago
ggplot(data, aes(x=min..account.balance.10.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account Balance 10 months ago per Credit Rating", x="Min Account balance 10 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 10 months ago
ggplot(data, aes(x=avrg..account.balance.10.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account Balance 10 months ago per Credit Rating", x="Avg Account balance 10 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 9 months ago
ggplot(data, aes(x=max..account.balance.9.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 9 months ago per Credit Rating", x="Max Account balance 9 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 9 months ago
ggplot(data, aes(x=min..account.balance.9.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 9 months ago per Credit Rating", x="Min Account balance 9 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 9 months ago
ggplot(data, aes(x=avrg..account.balance.9.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 9 months ago per Credit Rating", x="Avg Account balance 9 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 8 months ago
ggplot(data, aes(x=max..account.balance.8.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 8 months ago per Credit Rating", x="Max Account balance 8 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 8 months ago
ggplot(data, aes(x=min..account.balance.8.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 8 months ago per Credit Rating", x="Min Account balance 8 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 8 months ago
ggplot(data, aes(x=avrg..account.balance.8.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 8 months ago per Credit Rating", x="Avg Account balance 8 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 7 months ago
ggplot(data, aes(x=max..account.balance.7.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 7 months ago per Credit Rating", x="Max Account balance 7 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 7 months ago
ggplot(data, aes(x=min..account.balance.7.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 7 months ago per Credit Rating", x="Min Account balance 7 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 7 months ago
ggplot(data, aes(x=avrg..account.balance.7.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 7 months ago per Credit Rating", x="Avg Account balance 7 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 6 months ago
ggplot(data, aes(x=max..account.balance.6.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 6 months ago per Credit Rating", x="Max Account balance 6 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 6 months ago
ggplot(data, aes(x=min..account.balance.6.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 6 months ago per Credit Rating", x="Min Account balance 6 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 6 months ago
ggplot(data, aes(x=avrg..account.balance.6.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 6 months ago per Credit Rating", x="Avg Account balance 6 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 5 months ago
ggplot(data, aes(x=max..account.balance.5.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 5 months ago per Credit Rating", x="Max Account balance 5 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 5 months ago
ggplot(data, aes(x=min..account.balance.5.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 5 months ago per Credit Rating", x="Min Account balance 5 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 5 months ago
ggplot(data, aes(x=avrg..account.balance.5.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 5 months ago per Credit Rating", x="Avg Account balance 5 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 4 months ago
ggplot(data, aes(x=max..account.balance.4.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 4 months ago per Credit Rating", x="Max Account balance 4 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 4 months ago
ggplot(data, aes(x=min..account.balance.4.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 4 months ago per Credit Rating", x="Min Account balance 4 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 4 months ago
ggplot(data, aes(x=avrg..account.balance.4.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 4 months ago per Credit Rating", x="Avg Account balance 4 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 3 months ago
ggplot(data, aes(x=max..account.balance.3.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 3 months ago per Credit Rating", x="Max Account balance 3 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 3 months ago
ggplot(data, aes(x=min..account.balance.3.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 3 months ago per Credit Rating", x="Min Account balance 3 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 3 months ago
ggplot(data, aes(x=avrg..account.balance.3.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 3 months ago per Credit Rating", x="Avg Account balance 3 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 2 months ago
ggplot(data, aes(x=max..account.balance.2.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 2 months ago per Credit Rating", x="Max Account balance 2 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 2 months ago
ggplot(data, aes(x=min..account.balance.2.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 2 months ago per Credit Rating", x="Min Account balance 2 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 2 months ago
ggplot(data, aes(x=avrg..account.balance.2.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 2 months ago per Credit Rating", x="Avg Account balance 2 months ago", color="Credit Rating", fill="Credit Rating")

#max acc balance 1 months ago
ggplot(data, aes(x=max..account.balance.1.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Max Account balance 1 months ago per Credit Rating", x="Max Account balance 1 months ago", color="Credit Rating", fill="Credit Rating")

#min acc balance 1 months ago
ggplot(data, aes(x=min..account.balance.1.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Min Account balance 1 months ago per Credit Rating", x="Min Account balance 1 months ago", color="Credit Rating", fill="Credit Rating")

#avg acc balance 1 months ago
ggplot(data, aes(x=avrg..account.balance.1.months.ago, color=credit.rating, fill=credit.rating)) +
  geom_histogram(alpha=.6, position="dodge", binwidth=.5) +
  labs(title="Avg Account balance 1 months ago per Credit Rating", x="Avg Account balance 1 months ago", color="Credit Rating", fill="Credit Rating")



## Correlation Matrix ##
data2 <- subset(data_raw, data_raw[,46] > 0)
data2_relevant <- data2[,1:9]
credit_rating <- data2[,46]

data2 <- cbind(data2_relevant, credit_rating)
colnames(data2)
colnames(data2)[10] <- 'credit.rating'
head(data2)

corrdata <- cor(data2)
corrdata
round(corrdata, 3)
corrplot.mixed(corrdata, lower.col = "black", number.cex = .7)

corrMat <- rcorr(as.matrix(data2))
corrMat

### Predictive Modeling ###

## Multilayer Perceptron ##

#select all entries for which the credit rating is known
knownData <- subset(data_raw, data_raw[,46] > 0)

#select all entries for which the credit rating is unknown
unknownData <- subset(data_raw, data_raw[,46] == 0)

#separate value from targets
trainValues <- knownData[,1:45]
trainTargets <- decodeClassLabels(knownData[,46])
unknownsValues <- unknownData[,1:45]

#split dataset into training, validation and test sets 80%-20%-20% 
#split into 80%-20% first.
trainset <- splitForTrainingAndTest(trainValues, trainTargets, ratio=0.2)
trainset <- normTrainingAndTestSet(trainset)
trainset
#test set (20%)
X_test <- trainset$inputsTest
y_test <- trainset$targetsTest

#train set (80%)
trainValues2 <- trainset$inputsTrain
trainTarget2 <- trainset$targetsTrain

#split train set again (now 80% of total data) to get 20% of total data for validation set (0.2*1962 = 0.25*(1962 - 0.2(1962) ))
trainset2 <- splitForTrainingAndTest(trainValues2, trainTarget2, ratio=0.25)

#train set (60%)
X_train <- trainset2$inputsTrain
y_train <- trainset2$targetsTrain

#validation set (20%)
X_valid <- trainset2$inputsTest
y_valid <- trainset2$targetsTest

accuracy <- function(x){
  sum(diag(x) / sum(rowSums(x))) * 100
}


#15 - lr0.01(47-52), lr0.05(46-50)
#20 - lr0.01(46-52), lr0.05(44-49), lr0.1(46-50), lr0.5(43-48)
#33 - lr0.01(46-52), lr0.05(48-53), lr0.1(46-51), lr0.5(46-52)
#75 - lr0.01(47-52), lr0.05(47-51), lr0.1(49-54), lr0.5(49-53)
#90 - lr0.01(48 - 52), lr0.05(49-53), lr0.1(48 - 52), lr0.5(48 - 52)
#(75,33) - lr0.01(48-53), lr0.05(47-53), lr0.1(45-53), lr0.5(47-51)
#(75,33,13) - lr0.01(47-49), lr0.05(48-51), lr0.1(50-51), lr0.5(47-49)
#(33,13) - lr0.01(46-50), lr0.05(46-51), lr0.1(45-50), lr0.5(47-49)

model <- mlp(X_train, y_train, size=33, learnFuncParams=c(0.05), maxit=500, inputsTest=X_valid, targetsTest=y_valid)
pred <- predict(model,X_valid)

confusionMatrix(pred, y_valid)
accuracy(confusionMatrix(pred, y_valid))

plotIterativeError(model)
plotRegressionError(pred[,2], y_valid[,2])

#show detailed information of the model
summary(model)
model
weightMatrix(model)
extractNetInfo(model)


## try training another MLP with only the first 9 attributes ##
trainValues <- knownData[,1:9]
trainTargets <- decodeClassLabels(knownData[,46])
unknownsValues <- unknownData[,1:9]

#split dataset into training, validation and test sets 80%-20%-20% 
#split into 80%-20% first.
trainset <- splitForTrainingAndTest(trainValues, trainTargets, ratio=0.2)
trainset <- normTrainingAndTestSet(trainset)

#test set (20%)
X_test <- trainset$inputsTest
y_test <- trainset$targetsTest

#train set (80%)
trainValues2 <- trainset$inputsTrain
trainTarget2 <- trainset$targetsTrain

#split again (now 80% of total data) to get 20% of total data for validation set (0.2*1962 = 0.25*(1962 - 0.2(1962) ))
trainset2 <- splitForTrainingAndTest(trainValues2, trainTarget2, ratio=0.25)

#train set (60%)
X_train <- trainset2$inputsTrain
y_train <- trainset2$targetsTrain

#validation set (20%)
X_valid <- trainset2$inputsTest
y_valid <- trainset2$targetsTest

accuracy <- function(x){
  sum(diag(x) / sum(rowSums(x))) * 100
}

#15 - lr0.01(47-52), lr0.05(46-50)
#20 - lr0.01(46-52), lr0.05(44-49), lr0.1(46-50), lr0.5(43-48)
#33 - lr0.01(46-52), lr0.05(48-53), lr0.1(46-51), lr0.5(46-52)
#75 - lr0.01(47-52), lr0.05(47-51), lr0.1(49-54), lr0.5(49-53)
#90 - lr0.01(48 - 52), lr0.05(49-53), lr0.1(48 - 52), lr0.5(48 - 52)
#(75,33) - lr0.01(48-53), lr0.05(47-53), lr0.1(45-53), lr0.5(47-51)
#(75,33,13) - lr0.01(47-49), lr0.05(48-51), lr0.1(50-51), lr0.5(47-49)
#(33,13) - lr0.01(46-50), lr0.05(46-51), lr0.1(45-50), lr0.5(47-49)


model <- mlp(X_train, y_train, size=33, learnFuncParams=c(0.01), maxit=500, inputsTest=X_valid, targetsTest=y_valid)
pred_valid <- predict(model,X_valid)

confusionMatrix(pred_valid, y_valid)
accuracy(confusionMatrix(pred_valid, y_valid))

plotIterativeError(model)
plotRegressionError(pred_valid[,2], y_valid[,2])


#we see that the test sum of squared errors (red line) starts increasing after the initial plateau post
#300 training iterations, which looks like overfitting.
#Lets reduce the iterations to see if we can get better results
model <- mlp(X_train, y_train, size=33, learnFuncParams=c(0.01), maxit=300, inputsTest=X_valid, targetsTest=y_valid)
pred <- predict(model,X_valid)

confusionMatrix(pred, y_valid)
accuracy(confusionMatrix(pred, y_valid))

plotIterativeError(model)
plotRegressionError(pred[,2], y_valid[,2])

#prediction on test set
pred_test <- predict(model,X_test)

confusionMatrix(pred_test, y_test)
accuracy(confusionMatrix(pred_test, y_test))

plotIterativeError(model)
plotRegressionError(pred_test[,2], y_test[,2])

## Decision Tree ##
data <- read.csv('data/creditworthiness.csv')

data.known <- subset(data, credit.rating > 0)
data.unknown <-subset(data, credit.rating == 0)

#train/test split of 50-50 for known credit_rating data
data.train <- data.known[1:(nrow(data.known)/2),]
data.test <- data.known[-(1:(nrow(data.known)/2)),]

dtree <- rpart(factor(credit.rating)~., data=data.train)
dtree

dtree_confusionMatrix <- table(truth = data.test$credit.rating,
                               prediction = predict(dtree, data.test[, -46], type='class'))
dtree_confusionMatrix

sum(diag(dtree_confusionMatrix))/sum(dtree_confusionMatrix)


## Support Vector Machine ##
svm <- svm(factor(credit.rating)~., data=data.train)
svm

svm_confusionMatrix <- table(truth=data.test$credit.rating,
                             prediction = predict(svm, data.test[,-46], type='class'))
svm_confusionMatrix
sum(diag(svm_confusionMatrix))/sum(svm_confusionMatrix)

##hypertune model parameters
svm.tuned <- tune.svm(factor(credit.rating)~., data = data.train,
                      gamma = 0.0222222 * c(0.01, 0.1, 1, 10, 100), cost = c(0.01, 0.1, 1, 10))
svm.tuned
svm.tuned$best.model


svm_new_confusionMatrix <- table(truth=data.test$credit.rating,
                                 prediction = predict(svm.tuned$best.model, data.test[,-46], type='class'))
svm_new_confusionMatrix
sum(diag(svm_new_confusionMatrix))/sum(svm_new_confusionMatrix)

## Naive Bayes ##
nb <- naiveBayes(factor(credit.rating)~., data = data.train)
nb

# distribution of classes in data.train
table(data.train[46])/sum(table(data.train[46]))

# functionary X credit.rating
table(data.train[,c(1,46)])

# example: probability of credit.rating = 1 & functionary = 0
# posterior prob =  prior prob * conditional prob / evidence
# P(Y=1 | X=0)
(funcMean <- mean(data.train$functionary[data.train[,46] == 1]))
(funcSd <- sd(data.train$functionary[data.train[,46] == 1]))

#prior prob
cr1Prior <- 0.2303772
cr2Prior <- 0.5127421
cr3Prior <- 0.2568807

#conditional prob
(cond_y1x0 <- cr1Prior * dnorm(0, funcMean, funcSd) / funcSd)
(cond_y2x0 <- cr2Prior * dnorm(0, funcMean, funcSd) / funcSd)
(cond_y3x0 <- cr3Prior * dnorm(0, funcMean, funcSd) / funcSd)

# evidence
(total_prob = cond_y1x0 + cond_y2x0 + cond_y3x0)

# posterior prob
(prob_y1x0 <- cond_y1x0 / total_prob)
(prob_y2x0 <- cond_y2x0 / total_prob)
(prob_y3x0 <- cond_y3x0 / total_prob)

probabilities <- c(prob_y1x0, prob_y2x0, prob_y3x0)
probabilities

nb_confusionMatrix <- table(truth=data.test$credit.rating,
                            prediction = predict(nb, data.test[,-46], type='class'))
nb_confusionMatrix
sum(diag(nb_confusionMatrix))/sum(nb_confusionMatrix)
