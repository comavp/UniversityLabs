function [cmpResults, parameters] = sharpening(image)

cmpResults = [];
parameters = 3:2:15;
A = 5;
cnt = 0;

for M = 3:2:15
    cnt = cnt + 1;
    resultImageName = ['Sharpening\result' sprintf('%d', cnt) '.pgm'];
    
    mask = ones(M);
    mask = mask / sum(mask(:));
    smoothImage = imfilter(image, mask);
    sharperImage = image + A *(image - smoothImage);
    
    imwrite(uint8(sharperImage), ['data\' resultImageName]);
    cmpResult = Extract('peppers.pgm', resultImageName, 'cox', 'watermarking_library\', 'data\');
    cmpResults = [cmpResults, str2double(cmpResult)];
end
end