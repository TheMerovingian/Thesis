clear all
close all

addpath('../Classifiers/')

TRAINING_DIR = 'E:/Thesis/External/ClassifierTraining/NN/Eval/';
TARGET_DIR = 'E:/Thesis/External/ClassifierTraining/NN/Targets/'; 

TRAINING_FILES = getAllFiles(TRAINING_DIR);

% Create a Pattern Recognition Network
hiddenLayerSize = 30;
net = patternnet(hiddenLayerSize);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

totalTraining = [];
totalTargets = [];

noiseLabels = {'Clean', '30dB', '15dB', '5dB'};

nets = cell(1,length(noiseLabels));

for n = 1:length(noiseLabels)
    net = init(net);
    net.trainParam.epochs = 200;
    
    clear totalTargets
    clear totalTraining
    
    load(strrep('||Data', '||', noiseLabels{n})) 
    
    % Train the Network
    [net,tr] = train(net,totalTraining,totalTargets);

    % Test the Network
    y = net(totalTraining);
    e = gsubtract(totalTargets,y);
    tind = vec2ind(totalTargets);
    yind = vec2ind(y);
    percentErrors = sum(tind ~= yind)/numel(tind);
    performance = perform(net,totalTargets,y);
    
    netStruct.net = net;
    netStruct.tr = tr;
    netStruct.training = totalTraining;
    netStruct.targets = totalTargets;
    
    nets{n} = netStruct;
end

netStruct = nets{3};
outputs = netStruct.net(netStruct.training);
targets = netStruct.targets;

[c,cm,ind,per] = confusion(targets,outputs);

surf(cm)

% View the Network
view(net)
