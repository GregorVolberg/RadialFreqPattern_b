fade       = 0.02; %fade-in, fade-out
Freq       = 2200; %in Hz
duration   = 0.8;
betw_pause = 0.4;
snd_order  = 1;
Fs         = 48000; % sampling freq


snd = generate_sounds(snd_order, duration, Freq, fade, betw_pause, Fs);
sound(snd, Fs);


function [snd] = generate_sounds(snd_order, duration, Freq, fade, betw_pause, Fs)
% nur zwei sounds, sin und tria
% order: 1 = sin zuerst, 2 = tria zuerst 
% s_length = länge des sound samples, pro wellenform, in sec
% freq: zB 2000, 2200, 2400
% fade-in und fade-out, in sec
% pause: pause zwischen sounds, in sec
%Fs       = 44000;

t         = (0:(1/Fs):duration-(1/Fs))';
fade_samp = length((0:(1/Fs):fade-(1/Fs)));
fadefunc  = ones(length(t), 1);
fadefunc(1:fade_samp) = linspace(0, 1, fade_samp);
fadefunc(end-fade_samp+1:end) = linspace(1, 0, fade_samp);

sinwave = sin(2*pi*Freq*t) .* fadefunc;
sawwave = sawtooth(2*pi*Freq*t, 1) .* fadefunc;
paus    = zeros(Fs * betw_pause, 1);
if snd_order == 1
    snd = [sinwave; paus; sawwave];
elseif snd_order == 2
    snd = [sawwave; paus; sinwave];
end

end

