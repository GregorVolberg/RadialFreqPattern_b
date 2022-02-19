% generate square wave
% https://de.mathworks.com/help/signal/ref/square.html
% https://de.mathworks.com/help/signal/ref/sawtooth.html

duration = 0.8; % in s
fade_dur = 0.02;%
Freq     = 2250; %in Hz
Fs       = 44000;

t         = (0:(1/Fs):duration-(1/Fs))';
fade_samp = length((0:(1/Fs):fade_dur-(1/Fs)));
fadefunc  = ones(length(t), 1);
fadefunc(1:fade_samp) = linspace(0, 1, fade_samp);
fadefunc(end-fade_samp+1:end) = linspace(1, 0, fade_samp);

sinwave = sin(2*pi*Freq*t) .* fadefunc;
squwave = square(2*pi*Freq*t) .* fadefunc;
sawwave = sawtooth(2*pi*Freq*t, 1) .* fadefunc;

[p1]  = pspectrum(sinwave, Fs);
[p2]  = pspectrum(squwave, Fs);
[p3,f]  = pspectrum(sawwave, Fs);
[~,idx] = min(abs(f-Freq));

adj1 = p1(idx)/p2(idx);
adj2 = p1(idx)/p3(idx);

sound(sinwave, Fs); %OK
pause(1.6);
%sound(squwave/adj1, Fs); %OK
%pause(1.6);
sound(sawwave, Fs); %OK

%% https://en.wikipedia.org/wiki/Equal-loudness_contour
% https://de.mathworks.com/help/audio/ref/acousticloudness.html
l= acousticLoudness(squwave, Fs);

p1 = pspectrum(sqwave, Fs)


Fs = 1000; % sampling rate of signal
FADE_LEN = 5; % 5 second fade

sig = randn(15.*Fs,1); % generate 15 s signal

fade_samples = round(FADE_LEN.*Fs); % figure out how many samples fade is over
fade_scale = linspace(0,1,fade_samples)'; % create fade

sig_faded = sig;
sig_faded(1:fade_samples) = sig(1:fade_samples).*fade_scale; % apply fade

subplot(211)
plot(sig)
subplot(212)
plot(sig_faded)