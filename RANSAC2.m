function [ H ] = RANSAC2( p1, p2 )
%RANSAC2 finds the optimally agreable pairs points given by p1 and p2 and
%outputs the homogenous transformation matrix for those opitmal pairs
    
    epsilon = 10; %the inital inlier error
    inlie = 0; %initail number of inliers
    D=9; %dimention of sample
    
    %iterate 100 times for good results
    for i=1:100,
        %find random sample
        ind = randperm(length(p1),D);
        
        %get the indexes of that random sample from both pairs
        p = p1(ind,:);
        pi = p2(ind,:);
        
        %find the tranformation using DLT
        H = DLT(p1,p2);
        %buffer for mulitplication
        pi = [pi,ones(D,1)];
        p = [p,ones(D,1)];
        %find the r and inliers(R)
        piT = (H*pi')';
        r = abs(p - piT/(median(piT(:,3))));
        R = sum(mean(r(:,1:2),2)<epsilon);
        
        %if you have better inliers save
        if R>inlie,
           sv = ind;
           %if you have more than 4, save those
           if R>3,
                sv = ind(mean(r(:,1:2),2)<epsilon);
           end
           inlie=R;
        end
    end
    
    %do it again to return the transform
        p = p1(sv,:);
        pi = p2(sv,:);
        
        H = DLT(p1,p2);
        
        pi = [pi,ones(length(pi),1)];
        p = [p,ones(length(pi),1)];
        
        piT = (H*pi')';
        p;
        r = abs(p - piT/(median(piT(:,3))));
        H=H/H(9);
end