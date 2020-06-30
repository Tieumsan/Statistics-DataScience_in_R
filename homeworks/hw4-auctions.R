#Preliminary work
rm(list=ls())

#Uniform valuations
nb_bidders <- 3
nb_simulations <- 100000

set.seed(1)
#Auction
valuations <- matrix(runif(nb_bidders * nb_simulations, min=0, max=1), nrow=nb_simulations)

max_valuation <- apply(valuations, 1, max)
optimal_price <- (1/(nb_bidders+1))^(1/nb_bidders)
expected_revenue_posted <- (nb_bidders/(nb_bidders+1)) * optimal_price
revenue <- optimal_price * (max_valuation >= optimal_price)

mean(revenue)
print('Expected revenue in Auction: ')
expected_revenue_posted

#Posted price
rank_valuations <- apply(valuations, 1, rank)
price_english_auction <- apply(valuations, 1, function(x) x[rank(x) == nb_bidders-1])
expected_revenue_english <- (nb_bidders-1)/(nb_bidders+1)

mean(price_english_auction)
expected_revenue_english

########################

cartier_data <- read.csv('../14.310 - Data Analysis in Social Science/Datasets/Cartier+3-day+auctions.csv')

cartier_data$auctionid <- as.character(cartier_data$auctionid)
unique_bids <- unique(cartier_data$auctionid)

ratio <- rep(NA, times=length(unique_bids))
nb_bidders <- rep(NA, times=length(unique_bids))
nb_bids <- rep(NA, times=length(unique_bids))

for (i in seq_along(unique_bids)) {
  temp <- filter(cartier_data, auctionid == unique_bids[i])
  bid2 <- temp$bid[rank(temp$bid, ties.method='last') == (length(temp$bid)-1)]
  bid3 <- temp$bid[rank(temp$bid, ties.method='last') == (length(temp$bid)-2)]
  ratio[i] <- bid2 / bid3
  nb_bidders[i] <- length(unique(temp$bidder))
  nb_bids[i] <- length(temp$bid)
}

data_clean <- data.frame(unique_bids, ratio, nb_bidders, nb_bids)
data_clean
summary(data_clean)
