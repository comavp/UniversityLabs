function [cmpResults, parameters] = addNoise(image)

cmpResults = [];
parameters = 400:100:1000;
cnt = 0;

for noiseVariance = 400:100:1000
    cnt = cnt + 1;
    resultImageName = ['Noise\result' sprintf('%d', cnt) '.pgm'];
    
    noise = randn(size(image));
    noise = noise - mean(noise(:));
    noise = noise / sqrt(var(noise(:))) * sqrt(noiseVariance);
    imageWithNoise = image + noise;
    
    imwrite(uint8(imageWithNoise), ['data\' resultImageName]);
    cmpResult = Extract('peppers.pgm', resultImageName, 'cox', 'watermarking_library\', 'data\');
    cmpResults = [cmpResults, str2double(cmpResult)];
end
end

