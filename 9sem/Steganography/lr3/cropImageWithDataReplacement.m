function [cmpResults, parameters] = cropImageWithDataReplacement(image, dataToReplace)

cmpResults = [];
cnt = 0;
parameters = 0.2:0.1:0.9;

for squarePart=0.2:0.1:0.9
    cnt = cnt + 1;
    resultImageName = ['CropImageWithDataReplacement\result' sprintf('%d', cnt) '.pgm'];
    
    cropSize = floor(sqrt(squarePart)*size(image));
    result = dataToReplace;
    result(1:cropSize(1), 1:cropSize(2)) = image(1:cropSize(1), 1:cropSize(2));
    
    imwrite(uint8(result), ['data\' resultImageName]);
    cmpResult = Extract('peppers.pgm', resultImageName, 'cox', 'watermarking_library\', 'data\');
    cmpResults = [cmpResults str2double(cmpResult)];
end

end