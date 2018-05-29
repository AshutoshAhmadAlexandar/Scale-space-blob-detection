img = imread('/Users/ashutoshahmadalexandar/Desktop/CVIP/HW2/hw2/data/tower.jpg');

%converting the image to greyscale
img = rgb2gray(img);

%converting to double
img = im2double(img);

k = 1.5;
n=15;
[h, w] = size(img);
scale_space = zeros(h,w,n);
f=img;
threshold = 0.007;

%Keep image same, and increasing the filter size
tic
for i = 1:n
    sigma=2;
    sigma = sigma * k^(i-1);
    filt_size =  2*ceil(3*sigma)+1; %to make filter size odd
    LoG       =  sigma^2 * fspecial('log', filt_size, sigma);
    filtered_img = imfilter(f, LoG, 'same', 'replicate');
    filtered_img = filtered_img.^2;
    scale_space(:,:,i) = filtered_img;
end

%Performing non maxima suppression

max_space = zeros(h,w,n);
for i=1:n
    max_space(:,:,i) = ordfilt2(scale_space(:,:,i), 9, ones(3,3));
end

 logical_space= max_space == scale_space;
 max_space2 = zeros(h,w,n);

%Non Maxima suppression among the scales
[final_max, final_index] = max(max_space, [], 3);
final_max2 = repmat(final_max,1,1,n);
final_max3 = scale_space .* (scale_space == final_max2);

    
%plotting the circle

Indexes = find(final_max3 >= threshold);
[cy, cx, z] = ind2sub(size(final_max3), Indexes);
rad = zeros(size(cy,1),1);

%[cy, cx] = find(final_max>threshold);
%rad = zeros(size(cx));

for m=1:size(cy,1)
    index = final_index(cy(m),cx(m));
    sigma = 2;
    sigma = sigma * k^(index-1);
    r = sigma*sqrt(2);
    rad(m) = r;
end
toc

show_all_circles(img,cx,cy,rad);
    
