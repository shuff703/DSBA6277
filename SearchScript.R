if (!"devtools" %in% installed.packages()) {install.packages("devtools")}
devtools::install_github("mkearney/rtweet")

library(rtweet)
appname <- "CryptoAnalysisDataCollection"
key <- "lTA20MJEb20rcqDvkmotLWs1y"
secret <- "MDjpodUS1d1I5IlbGyJx2oxN1dldwfOjdGM8V2uEjrvOB7hOid"
token <- '422576534-OiztHLivMmBWltiIqyz34eR9DTR48mv7fHF2Z8th'
auth_secret <- 'J8mLey6D2DdtRRPk1LWN9Tn1x4xbJVyOcVKJOCbFKat9Z'
twitter_token <- create_token(app = appname,
                              consumer_key = key,
                              consumer_secret = secret,
                              access_token=token, 
                              access_secret=auth_secret)

search_term <- "to:Wendys"
srch <- search_tweets(q = search_term,
                      type = "recent",
                      lang = "en",
                      include_rts = FALSE,
                      retryonratelimit = TRUE,
                      token = twitter_token,
                      parse = TRUE,
                      since = "2018-10-12",
                      until = "2018-10-14")

getwd()
setwd('Documents/R/CSV')
save_term <- "to_wendys"
write_as_csv(srch,paste(save_term,".csv",sep=""))
write_as_csv(users_data(srch),paste(save_term,"_users.csv",sep=""))

?search_tweets

