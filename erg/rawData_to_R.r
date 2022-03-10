library(tidyverse)
library(R.matlab)
# test for version contol with git
fpath = 'C:/Users/LocalAdmin/Filr/Meine Dateien/ExpVI_RFPa/raw/'
flist = sort(dir(fpath, pattern = 'S*_*.mat'))

tmp = data.frame()
for (k in 1:length(flist)){
df    = readMat(paste(fpath, flist[k], sep='')) 
tmp2 = data.frame(df$RFP[[5]], df$RFP[[1]], df$RFP[[2]], df$RFP[[3]], df$RFP[[4]])
tmp = rbind(tmp, tmp2)
}

ds = as_tibble(tmp) %>%
     mutate(vp       = as_factor(df.RFP..1..),
            mapping  = fct_recode(as_factor(df.RFP..2..), rund_links = '1', rund_rechts = '2'),
            date     = as.POSIXct(df.RFP..3.., format='%Y%m%dT%H%M%S'),
            waveform = fct_recode(as_factor(X5), sine = '1', tria = '2'),) %>%
     rename(trial       = X1,
            block       = X2,
            origTrial   = X3,
            nodd        = X4,
            rfpbase     = X6,
            rfpfreq     = X7,
            audiofreq   = X8,
            phi         = X9,
            rt          = X10,
            keycode     = X11,
            isRound     = X12,
            ISI         = X13,
            size        = X14) %>%
    select(vp, block, trial, rt, isRound, rfpbase,
           rfpfreq, nodd, waveform, audiofreq , size,
           origTrial, mapping, date)

fname = 'RFP_rawData.rds'
saveRDS(ds, file = paste(fpath, fname, sep = ''))
