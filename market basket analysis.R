############################################Market Basket Analysis######################################
options(java.parameters = "-Xmx8000m")

# Loading Libraries
library(urltools)
library(dplyr)
library(RPostgreSQL)
library(sqldf)
library(DBI)
library(lubridate)
library(stringr)
library(reshape2)
library(aws.s3)
library(fasttime)
library(urltools)
library(reconstructr)
library(arules)
library(arulesViz)
library(splitstackshape)
# Disabling Exponential Notation
options(scipen = 999,digits = 19)


Data  <- read.csv("mba(march).csv")

Data <-  cSplit(Data, "V1", ",")
# Total Number of DFS Items  = 563 and Number of Transaction 26,833 
  
summary(Data)
# #Support is how frequently a item occur in the whole table 
# #(what proportion of the data contains that particular item )
# 
# #confidence 
# #(is a  measure of the proportion of trasaction were the presence of items 
# #or set of items results in presence of other set of item )
# #Like Conditional Probability 
# #If I buy item A and B how likely it is that I will buy C too 
# # confidence {(A,B)} -> {C} = Support({A,B,C}) / Support({A,B})
# 
#Lift is confidence/Support of RHS (Y)
#Think about LIft as it is like #How much more likely an 
#item is going to purchase relative to its general purchase rate, given that you know 
#that an other item is purchase
# itemFrequency(DFS_Item[,1:6])
# 0.000149070174784779946 * 26833
# 
# itemFrequencyPlot(DFS_Item, support = 0.02)
# 
# itemFrequencyPlot(DFS_Item, topN = 30)
Transactions <- apriori(Data, parameter = list(support = 0.001, confidence = 0.01, target="rules", minlen = 2, maxlen = 5))
#Minimum Support is 0.10 and Confidence 0.80 so lower themselves                                                        minlen=2))
df = data.frame(
  lhs = labels(lhs(Transactions)),
  rhs = labels(rhs(Transactions)),
 Transactions@quality)
write.csv(df,"mba-march-output.csv")
