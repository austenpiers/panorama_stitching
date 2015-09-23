function [ H ] = DLT( pn, p )
%DLT takes in coordinate pairs pn and p and returns a homogenous
%transformation matrix H, such that pn = H*p

% create default buffer
buff = zeros(1,3);
% buffer the z value with ones
p(:,3) = ones(length(p),1);
pn(:,3) = ones(length(p),1);

%get the standardatization matricies
[Tn,T] = FindTs(pn,p);
%standardize
pn=(Tn*pn')';
p=(T*p')';

%create the solving A matrix; such that Tn*pn = A * T*p
for i=1:length(pn)
    A(i*2,:) = [-1*p(i,:), buff, pn(i,1)*p(i,:)];
    A(i*2+1,:) = [buff, -1*p(i,:), pn(i,2)*p(i,:)];
end

% solve for the last eigenvector to minimize error
[~, ~, V] = svd(A, 0);
H = V(:, end);

%rearrange 1x9 to 3x3
H = [H(1:3),H(4:6),H(7:9)]';
%undo the normalization matricies
H = Tn\H*T;

end