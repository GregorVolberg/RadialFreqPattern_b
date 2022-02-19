
% the base form ('Rbase', replaces r0)
br0   = 200;
bA    = 0.2;
bfrq  = 4; % 2 und 4
bnodd = 0;   % number of odd harmonics to add (can be 0)
bphi = pi/2;

% the outline
r0 = 200;
A  = 0.15;
frq = 20; % (20-30)
nodd = 5;   % number of odd harmonics to add
            % set to 0 for sine wave
            % see DOI: 10.1038/srep26681
            % or  https://en.wikipedia.org/wiki/Triangle_wave
% 0 bis 5
phi = 0;


            
[x1, y1, Rbase] = generate_wave(br0, bA, bfrq, bnodd, bphi); % base            
[x, y, R]     = generate_wave(Rbase, A, frq, nodd, phi); 
%[x, y, R]     = generate_wave(r0, A, frq, nodd); 
plot(x, y);
%figure; plot(R);
            

%% ======== subfunctions =========
function [x, y, R] = generate_wave(r0, A, frq, nodd, phi)

theta = linspace(-pi, pi, 360);
wave = zeros(size(theta));

  for k = 0:nodd
  tmp = (-1)^k * (sin((2*k+1)*frq*theta+phi) / (2*k+1)^2);
  wave = wave + tmp;
  end
  
R = r0 .* (1 + A * wave);
x = R  .* cos(theta);
y = R  .* sin(theta);
end

function [x, y, R] = generate_Rbase(r0, A, frq, phi)

theta = linspace(-pi, pi, 360);
R = r0 * (1 + A * sin(frq * theta + phi));

x = R  .* cos(theta);
y = R  .* sin(theta);
end

% %% or manually
% phi = 0; set to 0
% R = r0 * (1+A*sin(frq*theta+phi));
% x = R.*cos(theta);
% y = R.*sin(theta);
% %plot(x, y, type = 'l', xlim = c(-2, 2), ylim = c(-2, 2))
% %figure; plot(R)
