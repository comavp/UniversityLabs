function [ ] = Embed(ContainerImgName, WatermarkedImgName, wmtype, pathToLibrary, pathToData)

signatureFilePath = [pathToData wmtype];
WatermarkedImgNamePath = [pathToData WatermarkedImgName];
ContainerImgNamePath = [pathToData ContainerImgName];

tmc = [pathToLibrary 'gen_' wmtype '_sig -o ' signatureFilePath '.sig'];
system(tmc,'-echo');
tmc = [pathToLibrary 'wm_' wmtype '_e -s ' signatureFilePath '.sig -o ', WatermarkedImgNamePath, ' ', ContainerImgNamePath];
system(tmc,'-echo');

end

