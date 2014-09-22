clear all
close all

addpath('../Classifiers/')

TRAINING_DIR = 'E:/Thesis/External/ClassifierTraining/NN/Eval/';
TARGET_DIR = 'E:/Thesis/External/ClassifierTraining/NN/Targets/'; 

TRAINING_FILES = getAllFiles(TRAINING_DIR);

totalTraining = [];
totalTargets = [];

for n = 1:length(TRAINING_FILES)
    trainingFile = TRAINING_FILES{n};
    targetFile = strrep(trainingFile, 'Eval', 'Targets');
    
    trainingData = csvread(trainingFile);
    targetData = csvread(targetFile)';
    
    [~, compensationLength] = size(targetData);
    [rows, cols] = size(trainingData);
    
    if cols ~= compensationLength   
        if cols > compensationLength
            trainingData = trainingData(:,1:compensationLength);
        else
            newTrainingData = zeros(compensationLength, cols);
            newTrainingData(1:rows, 1:cols) = trainingData;
            trainingData = newTrainingData;
        end
    end
    
    totalTraining = [totalTraining trainingData];
    totalTargets = [totalTargets targetData];
end

save('5dBData', 'totalTraining', 'totalTargets')