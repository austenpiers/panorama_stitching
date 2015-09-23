function [ minx,miny,maxx,maxy ] = ImageLimits( T, I1 )
%ImageLimits is the same as ImageLimits2 with an additional rescaling of
%the image if nessesary

    %rescaling for time complexity
    dim = 900000/(size(I1,1)*size(I1,2));
    if(dim<1),
       I1=imresize(I1,dim);
    end
    
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
