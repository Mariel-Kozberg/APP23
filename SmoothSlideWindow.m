function [ profile_filtered ] = SmoothSlideWindow( profile, slide_width )
%SmoothSlideWindow smooths time-profiles
% It works by averaging a set amount of dynamics in the profile ('slide_width')
% and then replaces the median dynamic of the slide_width with the calculated average

if size(profile,2) > 1
    profile = profile';
end

if size(profile,2) > 1 && size(profile,1) > 1 || ndims(profile) > 2
    error('Size of profile exceeds 2 dimensions');
    return
end

if nargin < 2
    slide_width = 3;
end

profile_filtered = zeros(size(profile,1),1);
for i = 1:size(profile,1)
if i <= slide_width / 2 - 0.5
    profile_filtered(i) = profile(i);
elseif i >= size(profile,1) - (slide_width / 2 - 0.5)
    profile_filtered(i) = profile(i);
else
    profile_filtered(i) = nanmean(profile(i-(slide_width / 2 - 0.5):i+(slide_width / 2 - 0.5)));   
end
end



