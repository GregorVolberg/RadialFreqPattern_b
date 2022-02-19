function [x, y] = generate_waveRFPb(r0, A, frq, nodd, phi)

nodd1 = floor(nodd);
nodd2 = ceil(nodd);
nodd_decimal = nodd - nodd1;
[x1, y1, ~] = generate_wave(r0, A, frq, nodd1, phi);
[x2, y2, ~] = generate_wave(r0, A, frq, nodd2, phi);

x = (x1+((x2-x1) * nodd_decimal))';
y = (y1+((y2-y1) * nodd_decimal))';

end