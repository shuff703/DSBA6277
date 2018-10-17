if (!"devtools" %in% installed.packages()) {install.packages("devtools")}
devtools::install_github("mkearney/rtweet")

library(rtweet)
appname <- ""
key <- ""
secret <- ""
token <- ''
auth_secret <- ''
twitter_token <- create_token(app = appname,
                              consumer_key = key,
                              consumer_secret = secret,
                              access_token=token, 
                              access_secret=auth_secret)

search_term <- "to:Wendys OR @Wendys"
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

#this is just documentation on the search call
?search_tweets

install.packages(c("wordcloud","RColorBrewer","quanteda"))

#read file
file_name = "to_wendys"
d <- read.csv(paste(file_name,".csv",sep=""))

#clean tweet
unclean_tweet <- tolower(d$text)
#remove ampersand
clean_tweet <- gsub("&amp", "", unclean_tweet)
#remove mentions
clean_tweet <- gsub("@\\w+", "", clean_tweet)
#remove punctuation
clean_tweet <- gsub("[[:punct:]]", "", clean_tweet)
#remove digits
clean_tweet <- gsub("[[:digit:]]", "", clean_tweet)
#remove URLS
clean_tweet <- gsub("http\\w+", "", clean_tweet)
#not sure
clean_tweet <- gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet <- gsub("^\\s+|\\s+$", "", clean_tweet)
#remove gnarly unicode (emojis & stuff)
clean_tweet = gsub("â","",clean_tweet)

require(quanteda)
tokensAll = tokens(clean_tweet, remove_punct = TRUE)
tokensNoStopwords = tokens_remove(tokensAll, c(stopwords("english"),"Wendys"))
tokensNgramsNoStopwords = tokens_ngrams(tokensNoStopwords, c(2))
#create Document frequency matrix
myDFM = dfm(tokensNgramsNoStopwords)
#create top terms in the tweets
topfeatures(myDFM, 20)

term = "chicken_nuggets"
corpus(unclean_tweet)[which(as.numeric(myDFM[,term])>0)]

require(wordcloud)
textplot_wordcloud(myDFM,
                   min_count = 3,
                   random_order = F,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(10,"Dark2"))