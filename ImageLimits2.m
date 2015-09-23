function [ minx,miny,maxx,maxy ] = ImageLimits2( T, I1 )
%ImageLimits2 find the min and max outputs of transform T on I1
    
    %make matrix with the corners
    I1Targets = [ 0 0 1; size(I1,1) 0 1;...
        0 size(I1,2) 1; size(I1,1) size(I1,2) 1]';
    %compute transformation
    I1Transform = (T*I1Targets)';
    %store/return min/max
    minx=min(I1Transform(:,2));miny=min(I1Transform(:,1));
    maxx=max(I1Transform(:,2));maxy=max(I1Transform(:,1));
end
%
