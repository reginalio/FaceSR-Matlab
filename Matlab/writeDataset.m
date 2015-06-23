% write training set and test set data
load('trainAndTestSetRandom.mat');
dir = '../dataset/';
mkdir('../dataset/train');
mkdir('../dataset/test');
mkdir('../dataset/trainLR');
mkdir('../dataset/trainHR');
mkdir('../dataset/testLR');
mkdir('../dataset/testHR');

LRSize = [15 15];
HRSize = [60 60];

trainSet.LR = imresize(trainSet.groundTruth, LRSize);
trainSet.HR = imresize(trainSet.groundTruth, HRSize);

testSet.LR = imresize(testSet.groundTruth, LRSize);
testSet.HR = imresize(testSet.groundTruth, HRSize);

for i=1:size(trainSet.LR,3)
    filename = strcat(dir,'trainLR/Face',num2str(i),'.pgm');
    image = uint8(trainSet.LR(:,:,i)*255);
    imwrite(image,filename); 
end

for i=1:size(testSet.LR,3)
    filename = strcat(dir,'testLR/Face',num2str(i),'.pgm');
    image = uint8(testSet.LR(:,:,i)*255);
    imwrite(image,filename); 
end

for i=1:size(trainSet.HR,3)
    filename = strcat(dir,'trainHR/Face',num2str(i),'.pgm');
    image = uint8(trainSet.HR(:,:,i)*255);
    imwrite(image,filename); 
end

for i=1:size(testSet.HR,3)
    filename = strcat(dir,'testHR/Face',num2str(i),'.pgm');
    image = uint8(testSet.HR(:,:,i)*255);
    imwrite(image,filename); 
end

% for i=1:size(trainSet.groundTruth,3)
%     filename = strcat(dir,'train/Face',num2str(i),'.pgm');
%     image = uint8(trainSet.groundTruth(:,:,i)*255);
%     imwrite(image,filename); 
% end
% 
% for i=1:size(testSet.groundTruth,3)
%     filename = strcat(dir,'test/Face',num2str(i),'.pgm');
%     image = uint8(testSet.groundTruth(:,:,i)*255);
%     imwrite(image,filename); 
% end
