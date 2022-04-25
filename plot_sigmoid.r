library(tidyverse)
library(R.matlab)

fpath   = './'
PngPath = './png/'
fname = 'RFP_rawData.rds'
ds = readRDS(file = paste(fpath, fname, sep = ''))
    

# sanity check
n = n_distinct(ds$vp)

trialsPerPerson = ds %>%
  group_by(vp) %>%
  summarize(nperP = length(vp)) %>%
  ungroup()


vpnames = unique(ds$vp)

# get fraction 'spiky' responses  
prz1all = ds %>% group_by(vp, nodd, waveform) %>%
      summarize(f_spikey = mean(isRound == 0)) %>%
      filter(waveform == 'sine') %>% 
      ungroup()

prz2all = ds %>% group_by(vp, nodd, waveform) %>%
       summarize(f_spikey = mean(isRound == 0)) %>%
       filter(waveform == 'tria') %>% 
       ungroup()

for (k in 1:length(vpnames)){
PngFileName = paste(PngPath, 'RFPb-', vpnames[k], '.png', sep = '')
png(filename = PngFileName,
    width  = 360,
    height = 360)

prz1  = prz1all %>% filter(vp == vpnames[k])  
spike = prz1$f_spikey
spike[spike == 0] = 0.01
spike[spike == 1] = 0.99
z_spike = qnorm(spike)
erg = lm(z_spike ~ prz1$nodd)
m = -(coef(erg)[1])/coef(erg)[2]
s = 1 / coef(erg)[2]
curve(pnorm(x,m,s), 0,3, col = 'red', xlim=c(0,3), ylim=c(0,1), ylab = 'p spiky', xlab = 'n odd-symmetrics', lwd=2)
points(prz1$nodd, prz1$f_spikey, col='red', cex=2)

prz2  = prz2all %>% filter(vp == vpnames[k])
spike = prz2$f_spikey
spike[spike == 0] = 0.01
spike[spike == 1] = 0.99
z_spike = qnorm(spike)
erg = lm(z_spike ~ prz2$nodd)
m = -(coef(erg)[1])/coef(erg)[2]
s = 1 / coef(erg)[2]
curve(pnorm(x,m,s), 0,3, col = 'blue', xlim=c(0,3), ylim=c(0,1), add=T, lwd=2)
points(prz1$nodd, prz2$f_spikey, col='blue', cex=2)

text(2.5,0.1, vpnames[k])
legend(1,0.4,legend = c('sine', 'triangle'), lty = c('solid', 'solid'),col = c('red', 'blue'), bty='n')
dev.off()
}


# V10, 13 , 15 auf Rateniveau
