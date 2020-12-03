function [cmpResults, parameters] = addGaussianBlur(image)

cmpResults = [];
parameters = 1:0.5:4;
cnt = 0;

for sigma = 1:0.5:4
    cnt = cnt + 1;
    resultImageName = ['GaussianBlur\result' sprintf('%d', cnt) '.pgm'];
    
    M = 2*floor(3*sigma) + 1;
    g = zeros(M);
    for m1 = 1:M
        for m2 = 1:M
             g(m1, m2) = exp(-((m1-M/2)^2 - (m2-M/2)^2)/2*sigma^2);
        end
    end
    g = g / sum(g(:));
    %bluredImage = imfilter(image, g);
    bluredImage = imgaussfilt(image, sigma, 'FilterSize', M);;
    imwrite(uint8(bluredImage), ['data\' resultImageName]);
    %figure;
    %imshow(['data\' resultImageName]);
    cmpResult = Extract('peppers.pgm', resultImageName, 'cox', 'watermarking_library\', 'data\');
    cmpResults = [cmpResults, str2double(cmpResult)];
end
end

