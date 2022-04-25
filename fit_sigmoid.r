library(tidyverse)
library(quickpsy)

source('./RFPb_functions.r')

fname <- 'RFP_rawData.rds'
ds    <- readRDS(fname) %>%
         filter(!is.element(vp, c('V10', 'V13', 'V15'))) # by visual inspection 
# sanity check
n <- n_distinct(ds$vp)
trialsPerPerson <- ds %>%
  group_by(vp) %>%
  summarize(nperP = length(vp)) %>%
  ungroup()
cat('\n******\n', n, 'participants in data set\n')

# fit without guesses and lapses
fit1 <- ds %>% group_by(vp, nodd, waveform) %>%
       summarize(N = n(),
                  k = sum(isRound == 0)) %>%
       ungroup() %>%
       quickpsy(., nodd, k, N, grouping = .(vp, waveform), 
                bootstrap = 'none')  
plotAndTest(fit1)

# with guess and lapses; restrict parameter space for fitting
fit2 <- ds %>% group_by(vp, nodd, waveform) %>%
        summarize(N = n(),
                  k = sum(isRound == 0)) %>%
        ungroup() %>%
        quickpsy(., nodd, k, N, grouping = .(vp, waveform), 
                 lapses = TRUE, guess = TRUE,
                 parini = list(c(0, 3), c(0, 4), c(0, .2), c(0, 0.3)),
                 bootstrap = 'none')
plotAndTest(fit2)

# export raw data
write_excel_csv2(fit2$par, 'fittedParameters.csv')
write_excel_csv2(fit2$averages, 'fittedData.csv')

dsFull = ds %>% group_by(vp, nodd, waveform, audiofreq) %>%
  summarize(N = n(),
            k = sum(isRound == 0),
            p = mean(isRound == 0)) %>%
  ungroup()

write_excel_csv2(dsFull, 'fullData.csv')


