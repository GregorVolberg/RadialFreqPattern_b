function [x, y, R] = generate_wave(r0, A, frq, nodd, phi)

theta = linspace(-pi, pi, 360);
wave = zeros(size(theta));

  for k = 0:nodd
  tmp = (-1)^k * (sin((2*k+1)*frq*theta + phi) / (2*k+1)^2);
  wave = wave + tmp;
  end
  
R = r0 .* (1 + A * wave);
x = R  .* cos(theta);
y = R  .* sin(theta);
end