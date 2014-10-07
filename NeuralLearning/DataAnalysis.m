close all
clear all

load('Data/TrainedNets.mat')
load('Data/PhonemeData.mat')

noiseLevels = {'Clean', '30dB', '15dB', '5dB'};
labels = {'False Negative', 'False positive', 'True positive', 'True Negative'};

noiseRow = 5;
P2averages = zeros(4,1);

for n = 1:length(nets)
    noiseRow = n+1;
    
    netStruct = nets{n};
    outputs = netStruct.net(netStruct.training);
    targets = netStruct.targets;

    [c,cm,ind,per] = confusion(targets,outputs);

    [rows, ~] = size(PhoneTypes);
    [phones, ~] = size(per);
    
    phoneAccuracies = containers.Map;
    phoneMFC = containers.Map;
    phoneFBNK = containers.Map;
    phoneLPD = containers.Map;
    phonePLP = containers.Map;
    
    
    
    for i = 1:phones-1
        index = num2str(i);
        
        for j = 1:rows
            typeRow = {PhoneTypes{j,:}};
            typeName = char(PhoneTypes{j,1});  
            
            if strcmp(typeName, 'Silence')
                continue
            end
            
            % ANN data calculations
            if (any(strcmp(index, typeRow)))                
                if ~isKey(phoneAccuracies, typeName)
                    phoneAccuracies(typeName) = struct('TruePos', 0, 'TrueNeg', 0, 'Count', 0);
                end
                
                pos = phoneAccuracies(typeName).TruePos + per(i,3);
                neg = phoneAccuracies(typeName).TrueNeg + per(i,4);
                count = phoneAccuracies(typeName).Count + 1;

                phoneAccuracies(typeName) = struct('TruePos', pos, 'TrueNeg', neg, 'Count', count);
            end
            
            % MFC Data calculations
            if(any(strcmp(MFCAccuracy{i,1}, typeRow)))                
                if ~isKey(phoneMFC, typeName)
                    phoneMFC(typeName) = struct('Accuracy', 0, 'Count', 0);
                end
                
                accuracy = phoneMFC(typeName).Accuracy + str2double(MFCAccuracy{i,noiseRow});
                count = phoneMFC(typeName).Count + 1;
                
                phoneMFC(typeName) = struct('Accuracy', accuracy, 'Count', count);
            end
            
            % FBNK Data calculations
            if(any(strcmp(FBNKAccuracy{i,1}, typeRow)))                
                if ~isKey(phoneFBNK, typeName)
                    phoneFBNK(typeName) = struct('Accuracy', 0, 'Count', 0);
                end

                accuracy = phoneFBNK(typeName).Accuracy + str2double(FBNKAccuracy{i,noiseRow});
                count = phoneFBNK(typeName).Count + 1;
                
                phoneFBNK(typeName) = struct('Accuracy', accuracy, 'Count', count);
            end
            
            % LPD Data calculations
            if(any(strcmp(LPDAccuracy{i,1}, typeRow)))                
                if ~isKey(phoneLPD, typeName)
                    phoneLPD(typeName) = struct('Accuracy', 0, 'Count', 0);
                end
                
                accuracy = phoneLPD(typeName).Accuracy + str2double(LPDAccuracy{i,noiseRow});
                count = phoneLPD(typeName).Count + 1;
                
                phoneLPD(typeName) = struct('Accuracy', accuracy, 'Count', count);
            end
            
            % PLP Data calculations
            if(any(strcmp(PLPAccuracy{i,1}, typeRow)))                
                if ~isKey(phonePLP, typeName)
                    phonePLP(typeName) = struct('Accuracy', 0, 'Count', 0);
                end

                accuracy = phonePLP(typeName).Accuracy + str2double(PLPAccuracy{i,noiseRow});
                count = phonePLP(typeName).Count + 1;
                
                phonePLP(typeName) = struct('Accuracy', accuracy, 'Count', count);
            end
        end
    end
    
    PlotClassifierAccuracy(noiseLevels{n}, phoneAccuracies, phoneMFC, phoneLPD, phoneFBNK, phonePLP);   
    
    noiseCollection{n}= {phoneMFC, phoneLPD, phoneFBNK, phonePLP};
    
    averageAccuracy = 0;
    
    phoneTypes = keys(phoneAccuracies);
    
    for i = 1:length(phoneTypes)
        averageAccuracy = averageAccuracy + (phoneAccuracies(phoneTypes{i}).TruePos + ...
            phoneAccuracies(phoneTypes{i}).TrueNeg) / phoneAccuracies(phoneTypes{i}).Count;
    end
    
    averageAccuracy = averageAccuracy / 8;
    
    P2Averages(n) = averageAccuracy;
    
    %PlotConfusionMatrices();
    
    %{
    figure
    surf(cm)    
    title(sprintf('Confusion of %s', noiseLevels{n}))
    figure
    for i = 1:4
        subplot(2,2,i)
        plot(per(:,i))
        title(sprintf('%s for %s SNR', labels{i}, noiseLevels{n}))
    end
    %}
end

P2Averages = P2Averages .* 50;
PlotNoiseAccuracy(P2Averages);

PlotNoiseAccuracyByType(noiseCollection);