function printTwoImages(figureTitle, image1, image2, title1, title2)
  figure('Name', figureTitle, 'NumberTitle', 'off');
  subplot(1, 2, 1); imshow(image1); title(title1);
  subplot(1, 2, 2); imshow(image2); title(title2);  
end
