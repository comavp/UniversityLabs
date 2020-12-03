function [ corr ] = Extract(ContainerImgName, WatermarkedImgName, wmtype, pathToLibrary, pathToData)

signatureFilePath = [pathToData wmtype];
ContainerImgNamePath = [pathToData ContainerImgName];
WatermarkedImgNamePath = [pathToData WatermarkedImgName];
OutputFileNamePath = [pathToData wmtype];

tmc = [pathToLibrary 'wm_' wmtype '_d -s ' signatureFilePath '.sig -i ' ContainerImgNamePath ' -o ' OutputFileNamePath '.wm ' WatermarkedImgNamePath];
[p,corr] = system(tmc, '-echo');
tmc = [pathToLibrary 'cmp_' wmtype '_sig -C -s ' signatureFilePath '.sig ' OutputFileNamePath '.wm'];
[p,corr] = system(tmc, '-echo');

end

