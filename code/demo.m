A = [ 4 1 4 9 1 1; 7 5 1 4 1 1; 1 5 3 4 1 1;8 6 7 4 1 1];
B = ordfilt2(A,9,ones(3,3));
[maxValue, linearIndexesOfMaxes] = max(A(:));
[rowsOfMaxes colsOfMaxes] = find(A == maxValue);

C = [ 17 24 1 8 15; 23 5 7 14 16; 4 6 13 20 22;10 12 19 21 3; 11 18 25 2 9];
[r c] = size(C);
D = ordfilt2(C,9,ones(3,3));
E = C==D;
F=D;
F=ind2sub(size(D),E);
[I,J,V] = find(C==D);

Z = zeros(size(D));

for ii=1:size(D,1)
    for jj = 1:size(D,2)
        old_value = E(ii,jj);
         if (old_value <1)
             new_value = 0;
         else
             new_value = D(ii,jj);
         end
         Z(ii,jj) = new_value;
    end
end

[final_max, final_index] = max(max_space2, [], 3);
final_max2 = repmat(final_max,1,1,n);

threshold = 0.005;

Indexes = find(final_max2 >= threshold);
[cy, cx, z] = ind2sub(size(final_max2), Indexes);
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

show_all_circles(img,cx,cy,rad);

%{
temp = scale_space(:,:,4);
disp(temp(1:3,1:3));

temp1 = max_space(:,:,4);
disp(temp1(1:3,1:3));
 
temp2 = logical_space(:,:,4);
disp(temp2(1:3,1:3));
 
temp3 = max_space2(:,:,3);
disp(temp3(1:3,1:3));
 
temp4 = max_space3(:,:,3);
disp(temp4(1:3,1:3));
 
temp5 = final_max3(:,:,5);
disp(temp5(1:3,1:3)); 
%}

%for i=1:n
 %   final_max(:,:,i) = max(max_space2(:,:,1:min(i,n)), [],3);
%end

%Non-maxima suppression in each 2-D slice across each scale
 %{
for i=1:n
    max_slice = max_space(:,:,i);
    logical_slice = logical_space(:,:,i);
    for ii=1:size(max_space,1)
        for jj = 1:size(max_space,2)
            old_value = logical_slice(ii,jj);
            if (old_value < 1)
                new_value = 0;
            else
                new_value = max_slice(ii,jj);
            end
            max_slice(ii,jj) = new_value;
        end
    end
    max_space2(:,:,i) = max_slice;
end
%}
%max_space3 = max_space .* logical_space;