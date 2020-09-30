function lungAnalysis()

%Reads Image Files
Selected_Image = imread('healthy.jpg'); %read picture 
%divides figure into rectangular panes 
figure, imshow(Selected_Image); %show image
title('Selected Image'); %image name

%Noise Removal Section
greyscale_Method = (Selected_Image); %convert into grayscale
median_filtering_Image = customfilter(greyscale_Method); %Uses Noise Removal
figure, imshow(median_filtering_Image); %show image 
title('Noise Removed'); %image name

%Binary Image Conversion
binary_picture = im2bw(median_filtering_Image, 0.2); %Convert into Black and White
 
figure, imshow(binary_picture); %show image 
title('Binary Image'); %image name

%Create morphological structuring element
se1 = strel('disk', 2); %creates a flat, disk-shaped structure,
postOpenImage_1 = imopen(binary_picture, se1);
figure, imshow(postOpenImage_1); %show image
title('Opening Image'); %image name

%Create morphological structuring element
se2 = strel('disk', 8); %creates a flat, disk-shaped structure,
postOpenImage_2 = imopen(binary_picture, se2);
inverted = ones(size(binary_picture));

%Creates Inverted Picture
invertedImage_1 = inverted - postOpenImage_1;
invertedImage_2 = inverted - postOpenImage_2;
figure, imshow(invertedImage_1); %show image
title('Inverted Picture'); %image name

%Specify initial contour
mask = zeros(size(invertedImage_1)); 
mask(50:end-50,50:end-50) = 1;

%Segments image into foreground and background
bw_1 = activecontour(invertedImage_1, mask, 800); %800 iterations 
bw_2 = activecontour(invertedImage_2, mask, 400); %400 iterations 
figure, imshow(bw_1); %show image
title('Contoured'); %image name

%Create Combination Pictures with Inverted image and Contour
mix_Image_1 = invertedImage_1 + bw_1;
filter_mix_Image_1 = medfilt2(mat2gray(mix_Image_1),[5 5]); %Filtering
mix_Image_2 = invertedImage_2 + bw_2;
filter_mix_Image_2 = medfilt2(mat2gray(mix_Image_2),[7 7]); %Filtering
figure, imshow(mix_Image_1); %show image
title('Contoured + inverted'); %image name

figure, imshow(filter_mix_Image_1); %show image
title('filtered'); %image name

%Black White Combination to Create Final Images
final_2 = im2bw(filter_mix_Image_2, 0.6);
final_1 = im2bw(filter_mix_Image_1, 0.6);
figure, imshow(final_1); %show image
title('Final 1'); %image name 

%Dispaly Final Image
figure, imshow(final_2); %show image
title('Final 2'); %image name

pre_final = final_1; %transfer
figure, imshow(pre_final); %show image
title('pre final'); %image name

BW5 = imfill(pre_final,'holes');
figure, imshow(BW5); %show image
title('Segmented'); %image name

%Dispaly Final Image
figure, imshow(final_1); %show image
title('Final Picture'); %image name

%Find Circles within Image using Polarity and Sensitivity
warning('off', 'all')
circle_image = final_1;
[centers,radii] = imfindcircles(circle_image,[9 20],'ObjectPolarity','dark','Sensitivity',0.88);
viscircles(centers,radii,'EdgeColor','g'); % Circles Display Green
display(size(centers, 1), ' Numbers of Circles');

figure, imshow(circle_image); %show image
title('Circle Found Picture'); %image name


segment_pic = final_2 - final_1; % Creates Segmented Image
figure, imshow(segment_pic); %show image
title('Segment pic'); %image name
%Creates before Colour Image 
pre_colour_pic = im2bw(medfilt2(mat2gray(segment_pic),[3 3]), 0.6);
figure, imshow(pre_colour_pic); %show image
title('Circles Segmented'); %image name

%Circles Segmented Circles
[B] = bwboundaries(pre_colour_pic,'holes');
hold on
for k  = 1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)

end
end