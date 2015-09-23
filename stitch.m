function [ ] = stitch( path )
%stitch takes an ordered set of images that may be stiched for panorama
%view
%   The input is a path to your images and the it outputs the panorama
%   image called 'panorama.jpg' in the same directory is ran in

%start funct
clearvars -except path; clc;
% Load images.
ImDir = fullfile(path);
ImScene = imageSet(ImDir);

%load first image
I1 = read(ImScene, 1);
%rescaling for time complexity
dim = 900000/(size(I1,1)*size(I1,2));
if(dim<1),
   I1=imresize(I1,dim);
end
H{1}=[1,0,0;0,1,0;0,0,1];
% Iterate over remaining image pairs
for totalImagesUsed = 2:ImScene.Count,
    %read next image
    I2=read(ImScene,totalImagesUsed);
    %rescaling for time complexity
    dim = 900000/(size(I2,1)*size(I2,2));
    if(dim<1),
       I2=imresize(I2,dim);
    end
	   
    totalImagesUsed
    
    %Find similar points with SIFT
    [ID1,ID2] = SiftImages(I1,I2);

    % Find best transform
    H{totalImagesUsed} = RANSAC2(ID1,ID2);
    
    %move to next pair
    I1=I2;
end

%recalculate for center
for current_Image_Stitching=2:totalImagesUsed,
    H{current_Image_Stitching}=H{current_Image_Stitching-1}*H{current_Image_Stitching};
end

%Compute the change from center
CenterInd = floor(totalImagesUsed/2);
Hbuff = inv(H{CenterInd});

% setting image limits and setting center image as referance
lim=[0,0,0,0];
for current_Image_Stitching=1:totalImagesUsed
    H{current_Image_Stitching}=Hbuff*H{current_Image_Stitching};
    [a,b,c,d]=ImageLimits(H{current_Image_Stitching},read(ImScene,totalImagesUsed));
    lim(current_Image_Stitching,1:4)=[a,b,c,d];
end

% compute offset
offset = -1*[floor(min(lim(:,2)')),floor(min(lim(:,1)'))];

% compute the dimentions of the output image
V = [ceil(max(lim(:,4)'));ceil(max(lim(:,3)'))];

% recale the output image to a reasonable theashold
T = [1,0;0,1];
if(V(1)>2500),
	T = [2500/V(1),0;0,2500/V(1)];
	V=T*V;	
end
if(V(2)>4000),
	Tp = [4000/V(2),0;0,4000/V(2)];
	V=Tp*V;
	T=Tp*T;
	clearvars Tp;
end

% recale the offset by the same scaling for the image
offset = floor((T*offset')');

%resize for H-matrix
T(3,1:2)=[0,0];
T(1:3,3)=[0;0;1];
 
%scale the H matricies to the same scaling
for current_Image_Stitching =1:totalImagesUsed,
	H{current_Image_Stitching}=T*H{current_Image_Stitching};
    
    %attempt 360 panorama
%     ap = n-CenterInd;
%     theta = 0.75*ap/n*pi;
%     delta =0.4*ap*V(2);
%     H{i}=([1,0,delta;0,1,0;0,0,1]*...
%         [cos(theta),-1*sin(theta),0;sin(theta),cos(theta),0;0,0,1]*...
%         [1,0,-1*delta/4;0,1,0;0,0,1])\H{i};
end

%create the panorama templat
ImageTemplate = uint8(zeros(ceil(V(1)+offset(1)),...
        ceil(V(2)+offset(2)+200), 3));

% clean memory
clearvars -except ImageTemplate offset H ImScene ImDir totalImagesUsed

% iterate though images
for current_Image_Stitching=1:totalImagesUsed,
    % find the output if the transformation of image i
    Iw = CreateWarp2(H{current_Image_Stitching},read(ImScene,current_Image_Stitching),uint8(zeros(size(ImageTemplate))),offset);
    % copy the image into the global panorama image
	ImageTemplate(Iw>0) = Iw(Iw>0);
    current_Image_Stitching
%     if current_Image_Stitching<10
%         imwrite(uint8(ImageTemplate),strcat('Panoram0',num2str(current_Image_Stitching),'.jpg'),'jpg');
%     else
%         imwrite(uint8(ImageTemplate),strcat('Panoram',num2str(current_Image_Stitching),'.jpg'),'jpg');
%     end
end
%save result
imwrite(uint8(ImageTemplate),'panorama.jpg','jpg');

end

