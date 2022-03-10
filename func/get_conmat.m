function [conmat] = get_conmat()
% 6nodd * 2wavef * 2bfreq * 2frq * 3audiofrq = 144; 
% bei 4 Durchgängen pro bedingung: 576 trials, 48 pro RFP*audio
nodd  = repelem([0, 0.4, 0.8, 1.2, 1.6, 3], 96); % odd harmonics, spikeness, 0:1:5
wavef = repmat(repelem(1:2, 48), 1, 6); % 1 = sine, 2 = triangle
bfrq  = repmat(repelem([3, 4], 24), 1, 12); % freq of Rbase, 3 or 4
frq   = repmat(repelem([16, 20],12), 1, 24); % freq of RFP
audi  = repmat(repelem([2000, 2200, 2400], 4), 1, 48); % audio frequency, 2000 2200 2400
conmat = [1:length(nodd); nodd; wavef; bfrq; frq; audi]';
end
