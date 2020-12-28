function [ColorMatrix] = color_func(f, colorMap)

M = max(f); 
m = min(f); 
if M~=m
    f = (f - m)/(M - m)*(length(f)-1); %normalize function
else
    f = 0.6*ones(size(f))*(length(f) - 1); 
end


f_int = floor(f) + 1; 
ColorMatrix = colorMap(f_int, :); 