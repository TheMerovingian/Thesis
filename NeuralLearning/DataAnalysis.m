clear all
close all

load('TrainedNets.mat')

noiseLevels = {'Clean', '30dB', '15dB', '5dB'};
labels = {'False Negative', 'False positive', 'True positive', 'True Negative'};

for n = 1:length(nets)
    
    netStruct = nets{n};
    outputs = netStruct.net(netStruct.training);
    targets = netStruct.targets;

    [c,cm,ind,per] = confusion(targets,outputs);


    figure
    surf(cm)    
    title(sprintf('Confusion of %s', noiseLevels{n}))
    figure
    for i = 1:4
        subplot(2,2,i)
        plot(per(:,i))
        title(sprintf('%s for %s SNR', labels{i}, noiseLevels{n}))
    end
end