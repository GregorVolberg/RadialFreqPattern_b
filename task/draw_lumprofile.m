% https://www.sciencedirect.com/science/article/pii/S004269899800039X#:~:text=The%20local%20curvature%20of%20radial,0%20is%20the%20mean%20radius.
% Draw something
C = 0.3; %contrast
r = 3; %radius
s = 2; %sigma, peak spatial frequency


function [poly] = make_D4(a, b, c)
poly.x = a+b+c;
poly.y = a+b+c;
end