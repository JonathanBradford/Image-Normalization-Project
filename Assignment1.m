close all
clear
clc

%Load all jpg images from projectImages folder + get num of images
imageFiles = dir('projectImages/*.jpg');
iLength = length(imageFiles);       %iLength = # images

%Preprocessing loop grabs images from image folder and sets global values
for i = 1:iLength
    fileName = strcat('projectImages/', imageFiles(i).name);
    images{i} = imread(fileName);
    sizes{i} = size(images{i});     %array holds sizes of each images
    iGray{i} = rgb2gray(images{i}); %generate array of gray images
    accumHist{i} = zeros(1,256);    %each image will have an accum. hist
    normGray{i} = iGray{i};         %holds the final normalized image vals
end

%This loop creates the accumulative histogram for each grayscale image
for i = 1:iLength
    for j = 1:sizes{i}(1)           %respective image row
        for k = 1:sizes{i}(2)       %respective image column
            for l = 0:255               %iterate over each grayscale val
                if (iGray{i}(j,k)) <= l     %checks pixel intensity/hist val
                    accumHist{i}(l+1) = (accumHist{i}(l+1) + 1);
                end
            end
        end
    end
    %this loop normalizes our histogram values relative to each image
    for m = 0:255
        accumHist{i}(m+1) = (accumHist{i}(m+1)/(sizes{i}(1)*sizes{i}(2)));
    end
end

%Normalization loop: normalizes every pixel value in 'iGray' image array
%and places it into new corresponding 'normGray' image array
for i = 1:iLength
    for j = 1:sizes{i}(1)
        for k = 1:sizes{i}(2)
            normGray{i}(j,k) = floor(255 * accumHist{i}((iGray{i}(j,k)) + 1));
        end
    end
end

%Loop displays the image, grayscale image, and 
%grayscale histogram in one figure (will contain as many 
%columns as there are .jpg images inside project image folder)
figure('Name','Image, grayscale & grayscale hist')
for j = 1:iLength
    subplot(iLength,iLength,j)  %display image
    imshow(images{j})
    if j == 1                   %caption images                
        title("Original Images:")
    end

    subplot(iLength,iLength,j+iLength) %grayscale display
    imshow(iGray{j})
    if j == 1
        title("Grayscale Images:")
    end

    subplot(iLength,iLength,j+(2*iLength))  %grayscale histogram
    imhist(iGray{j})
    if j == 1
        title("Grayscale Histograms:")
    end
end


%Loop displays the accumulated grayscale hist, normalized image and a
%histogram of the normalized image in the same manner as the above loop
figure('Name','Acculum. grayscale hist, normalized image, & normalized hist')
for k = 1:iLength
    subplot(iLength,iLength,k)  %display accum. histograms in top row
    bar(accumHist{k})
    if k == 1
        title("Accum. Grayscale Histograms:")
    end
    
    subplot(iLength,iLength,k+iLength) %displays normalized images
    imshow(normGray{k})
    if k == 1
        title("Normalized Images:")
    end 

    subplot(iLength,iLength,k+(2*iLength))  %displays hist of normalized images
    imhist(normGray{k})
    if k == 1
        title("Normalized Histograms:")
    end
end

