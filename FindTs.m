function [ T1, T2 ] = FindTs( p1,p2 )
%FindTs finds the unit length transformations from paired-points p1 and p1
%and returns those corrisponding transformation matricies

    %find the k-means of the x and y locations
    pmean1 = mean(p1,2);
    pmean2 = mean(p2,2);
    
    %set dimention and default deniminators for the transforms
    n=length(p1);
    Den1=0;Den2=0;
    %iterate to get the standard deviation
    for i=1:n,
       Den1 = Den1 + sqrt(abs(p1(i)-(pmean1(i))));
       Den2 = Den2 + sqrt(abs(p2(i)-(pmean2(i)))); 
    end
    % find the stardardized transforms using n and standard deviation
    S1 = sqrt(2)*n/Den1;
    S2 = sqrt(2)*n/Den2;
    
    %set and return the matricies
    T1=[S1,0,-1*S1*pmean1(1);...
        0,S1,-1*S1*pmean1(2);...
        0,0,1];
    T2=[S2,0,-1*S2*pmean2(1);...
        0,S2,-1*S2*pmean2(2);...
        0,0,1];
end

