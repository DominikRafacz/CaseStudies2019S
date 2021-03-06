#:# libraries
library(OpenML)
library(caret)
library(digest)

#:# config
set.seed(1)

#:# data
auto_price <- getOMLDataSet(data.id = 745)
auto <- auto_price$data

#:# model
regr_lm <- train(length ~ ., data = auto, method = "lm", tuneGrid = expand.grid(
  intercept=TRUE))

#:# hash 
#:# f43eac1d8cca3d365c54df528994169a
hash <- digest(list(length ~ .,auto,"lm",expand.grid(intercept=TRUE)))
hash
#:# audit
train_control <- trainControl(method="cv", number=5)
regr_lm_cv <- train(length ~ ., data = auto, method = "lm", tuneGrid = expand.grid(
  intercept=TRUE),trControl=train_control)
RMSE <-regr_lm_cv$results$RMSE
MSE <- RMSE^2
MSE <- data.frame(MSE=MSE)
result <- regr_lm_cv$results[c(2,3,4)]
result <- cbind(result,MSE)

#:# session info
sink(paste0("sessionInfo.txt"))
sessionInfo()
sink()