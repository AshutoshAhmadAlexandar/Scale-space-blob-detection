img = imread('/Users/ashutoshahmadalexandar/Desktop/CVIP/HW2/hw2/data/tower.jpg');
%converting the image to greyscale
img = rgb2gray(img);

%converting to double
img = im2double(img);

k = 1.2;
n=15;
[h, w] = size(img);
scale_space = zeros(h,w,n);
f=img;
threshold = 0.007;

%Downsampling the image and keeping filter same
tic
img2 = img;
scale_space_2 = zeros(h,w,n);
Max_space_2 = zeros(h,w,n);
scale_factor = 1;
scale_space2 = cell(n,1);
max_space_2 = cell(n,1);
for i=1:n
    img3 = imresize(img2, 1/k^(i-1));
    sigma2=2;
    filt_size2 = 2*ceil(3*sigma2)+1;
    LoG2 = sigma2^2 * fspecial('log', filt_size2, sigma2);
    filtered_img2 = imfilter(img3, LoG2, 'same', 'replicate');
    %filtered_img2 = filtered_img2.^2;
    %scale_space2(:,:,i) = imresize(filtered_img2, size(img2), 'bicubic');
    %scale_factor = 1/k^(i-1);
    filtered_img2 = filtered_img2.^2;
    scale_space2{i} = filtered_img2;
    %scale_space_2 = filtered_img2;
    %max_space_2 = ordfilt2(filtered_img2, 9, ones(3,3));
    scale_space_2(:,:,i) = imresize(filtered_img2, size(img));
    %Max_space_2(:,:,i) = imresize(max_space_2, size(img));
end

max_space2 = zeros(h,w,n);
for i=1:n
    max_space2(:,:,i) = ordfilt2(scale_space_2(:,:,i), 9, ones(3,3));
end

[final_max, final_index] = max(max_space2, [], 3);
final_max2 = repmat(final_max,1,1,n);
final_max3 = scale_space_2 .* (scale_space_2 == final_max2);
%for i=1:n
 %   final_max(:,:,i) = max(max_space2(:,:,1:min(i,n)), [],3);
%end

%plotting the circle

Indexes = find(final_max3 >= threshold);
[cy, cx, z] = ind2sub(size(final_max3), Indexes);
rad = zeros(size(cy,1),1);

%[cy, cx] = find(final_max>threshold);
%rad = zeros(size(cx));

for m=1:size(cx,1)
    index = final_index(cy(m),cx(m));
    sigma = 2;
    sigma = sigma * k^(index-1);
    r = sigma*sqrt(2);
    rad(m) = r;
end
toc
show_all_circles(img,cx,cy,rad);