# functions for RFPa

lapsepnorm <- function(x, m, sd, guess = 0, lapse = 0){
  guess + (1 - guess - lapse) * pnorm(x, m, sd)
}
# gamma (guess) is left asymptote, lambda (lapse) is right asymptote
# guess + (1 - guess -lambda)) * pnorm(x, m, sd), 
# eg https://journal.r-project.org/archive/2016-1/linares-na.pdf, equation (2)


plotAndTest <- function(fit1){ # plot curves and test for differences in mean
res <-  fit1$par %>% group_by(waveform, parn) %>%
  summarize(avg = mean(par)) %>%
  mutate(parn = recode(parn, p1 = 'm', p2 = 'sd', p3 = 'guess', p4 = 'lapse')) %>%
  ungroup() 

if (all(!(res$parn == 'guess'))){
  res = add_case(res, 
                waveform = c('sine', 'sine', 'tria', 'tria'),
                parn = c('guess', 'lapse', 'guess', 'lapse'),
                avg = c(0, 0, 0, 0))
}

names(res$avg) = res$parn
pars = split(res, res$waveform)

curve(lapsepnorm(x, pars$sine$avg['m'],
                    pars$sine$avg['sd'],
                    pars$sine$avg['guess'],
                    pars$sine$avg['lapse']),
      -0.5, 3.5, ylim = c(0,1),
      ylab = 'p (spikey)', xlab = 'n odd',
      col = 'red', lwd = 2, xaxt = 'n')
curve(lapsepnorm(x, pars$tria$avg['m'],
                    pars$tria$avg['sd'],
                    pars$tria$avg['guess'],
                    pars$tria$avg['lapse']),
      -0.5, 3.5, ylim = c(0,1),
      col = 'blue', lwd = 2, add = T)
axis(1, at = c(0, 0.4, 0.8, 1.2, 1.6, 3), labels = c(0, 0.4, 0.8, 1.2, 1.6, 3))
legend(1.8,0.4,legend = c('sine', 'triangle'), 
       lty = c('solid', 'solid'),
       lwd = c(2,2),
       col = c('red', 'blue'), bty='n')

pdats = fit1$averages %>% 
  filter(waveform == 'sine') %>%
  group_by(nodd) %>% 
  summarize(m = mean(prob)) %>%
  pull(m)
pdatt = fit1$averages %>% 
  filter(waveform == 'tria') %>%
  group_by(nodd) %>% 
  summarize(m = mean(prob)) %>%
  pull(m)
points(c(0, 0.4, 0.8, 1.2, 1.6, 3), pdats, col='red', cex=1.5, pch = 19)
points(c(0, 0.4, 0.8, 1.2, 1.6, 3), pdatt, col='blue', cex=1.5, pch = 19)
tdata = fit1$thresholds %>% split(.$waveform) 
t.test(tdata$sine$thre, tdata$tria$thre, paired = TRUE)
}