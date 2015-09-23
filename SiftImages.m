function [ img1_pts, img2_pts ] = SiftImages( img1, img2 )
%SiftImages Runs sift images from siftDemo4V path and finds the most
%similar, paired points from images img1 and img2

%add path to executables
 addpath(genpath('siftDemoV4'));

% run match as a command
[T, ~, matchidx, loc1, loc2] = evalc('match(img1, img2);');

% set and return matching pairs
img1_pts = loc1(find(matchidx > 0), 1:2);
img2_pts = loc2(matchidx(find(matchidx > 0)), 1:2);

end

