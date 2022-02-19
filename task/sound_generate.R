# sound generation for crossmodal correspondance
# package soundgen

library(tuneR) # for sound generation
library(soundgen) # for loudness measures
library(seewave)

setwd('C:/Users/Gregor/Filr/Meine Dateien/CrossModalCor')
w = sine(freq = 2250, samp.rate = 44100, duration = samp.rate * 0.8)
w = normalize(w)
k = powspec(w@left, sr = w@samp.rate, wintime = 0.8, dither = FALSE)
plot(w, )
play(w)
writeWave(w, filename = 'testwav.wav', extensible = TRUE)
powspec(w)

## seewave 
samp  = 44100
dur   = 0.8
freq  = 2250
d_in  = 0.05
d_out = 0.05

k1 = synth(f = samp, d = dur, cf = freq, signal = 'sine')
k2 = synth(f = samp, d = dur, cf = freq, signal = 'saw')
k3 = synth(f = samp, d = dur, cf = freq, signal = 'square')

k1f = fadew(k1, samp, din = 0.05, dout = 0.05)
k2f = fadew(k2, samp, din = 0.05, dout = 0.05)
k3f = fadew(k3, samp, din = 0.05, dout = 0.05)

listen(k1f, f = samp)
seewave::spec(k1f, f = samp, wl = 1024, from = 0.1, to = 0.7, flim=c(0,10),
              norm = F, scaled = T)
savewav(k1f, f = samp, filename = 'testseewave.wav') # option rescale!

ldness= (getLoudness(list(as.vector(k1f), as.vector(k2f), as.vector(k3f)), 
            samplingRate = samp, from = 0.1, to = 0.7,
            summaryFun = 'mean', plot = F, SPL_measured = 65)$summary)$loudness_mean

# die hier nun optimieren: referenz generieren (die mit geringster Lautheit)
# alle anderen relativ zu dieser Referenz manuell 
# Ampilude modifizieren (multiplizieren)

k1fb = k1f*0.7


attenuation(ldness[1], dref = 1, dstop=10, 10, plot = TRUE,
            xlab = "Distance (m)", ylab = "dB", type = "l")
