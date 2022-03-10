function [isOctave] = check_octave()
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave
pkg load statistics
pkg load signal
end
end