function [ ImageAdd ] = CreateWarp2( H, I1, ImageAdd, offset)
%CreateWarp2 inputs a homogenous transform H for Image I1 to panorama
%template ImageAdd with an offset
%   This function outputs an black panorama templateimage with the 
%   transformed image of I1 with a reverse transform method which maps
%   pixels in the codomain of H(I1) from the domain of I1 using inv(H)

    %rescaling for time complexity
    dim = 900000/(size(I1,1)*size(I1,2));
    if(dim<1),
       I1=imresize(I1,dim);
    end
    SZ=size(ImageAdd);
  % find limits of codomain
 [minx,miny,maxx,maxy] = ImageLimits2( H, I1 );
    %find inverse og the function
   H=inv(H);

    %conversion nessesary for interp2
    IM = double(I1);
    %find the iteration of the y indexes
    itr = ceil(miny):floor(maxy);
    %create an of offset vector for the y indexes
    off = ones(size(itr))*(offset(1));
    %find the range of the x indexes
    Iterate = [ceil(minx),floor(maxx)+149];
    %find the transform of the inv(H) transform on the Y indexes
    Yd = (H(:,1)*(itr))';
    %find dimentions for repmat of X values
    N = length(Yd);
    D = H(:,3)';
    %iterate through all of the rows of picture
    for i=Iterate(1):Iterate(2),
       Xd = (H(:,2)*i)';
       Xd = repmat(Xd+D,N,1);
       X = Xd(:,2)+Yd(:,2);
       Y = Xd(:,1)+Yd(:,1);
       x = itr+off; x(x<1)=1;
       y = i+offset(2); y(y<1)=1;
       ImageAdd(x,y,1:3) = [interp2(IM(:,:,1),X',Y');...
                   interp2(IM(:,:,2),X',Y');interp2(IM(:,:,3),X',Y')]';
    end
    %crop excess pixels
    ImageAdd = ImageAdd(1:SZ(1),1:SZ(2),1:3);
    clearvars -except ImageAdd;

end
