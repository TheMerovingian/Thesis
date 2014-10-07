function [] = PlotClassifierAccuracy(noiseLevel, phoneAccuracies, phoneMFC, phoneLPD, phoneFBNK, phonePLP)
    clear data

    lineThickness = 2.5;
    fontSize = 16;
    fontColour = 'k';
    
    upperYBound = 75;
    stepSize = 5;

    names = keys(phoneAccuracies);

    data = zeros(length(names), 5);
    data(:,1) = NaN;
    
    newNames = {' '};
    plotColours = {'b', 'r', 'g', 'k', 'c'};

    dataContainer = {phoneAccuracies, phoneMFC, phoneLPD, phoneFBNK, phonePLP};

    for n = 1:length(names)
        type = names{n};

        data(1,n+1) = (phoneAccuracies(type).TruePos + phoneAccuracies(type).TrueNeg) / phoneAccuracies(type).Count * 50;

        for i = 2:5
            data(i,n+1) = dataContainer{i}(type).Accuracy / dataContainer{i}(type).Count; 
        end

        newNames{n+1} = type;

        %fprintf('Type: %s\tAccuracy: %d\tCount: %d\n', type, phoneEval(type).Accuracy, phoneEval(type).Count);
    end
 
    figure
    hold on
    
    % Line plot the classifier accuracy
    for n = 1:5
        plot(data(n,:), [plotColours{n} '-x'], 'LineWidth', lineThickness)   
    end

    ylim([0,75])
    legend('Phase 2', 'MFCC', 'LPD', 'Filterbank', 'PLP')
    set(gca, 'XTickLabel', newNames, 'FontSize', fontSize, 'YGrid', 'on', 'YMinorTick', 'on')
    xlabel('Articulation type', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    ylabel('Classification accuracy (%)', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    title(sprintf('Classifier Accuracy at %s SNR', noiseLevel), 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)

    % Add average classifier accuracy
    for n = 1:5
        lineType = [plotColours{n} '--'];
        plot(ones(1,length(names)+1)*mean(data(n,2:end)), lineType, 'LineWidth', lineThickness)
    end

    [rows, ~] = size(newNames');
    plotData = zeros(rows-1,5);                
    
    figure
    hold on

    % Plot a bar graph of classifier accuracies
    for i = 2:rows
        typeName = char(newNames{i});

        dataContainer = {phoneAccuracies(typeName), phoneMFC(typeName), phoneLPD(typeName), phoneFBNK(typeName), phonePLP(typeName)};

        plotData(i-1,1) = (dataContainer{1}.TruePos + dataContainer{1}.TrueNeg) * 50 / dataContainer{1}.Count;

        for j = 2:length(dataContainer)
            plotData(i-1,j) = dataContainer{j}.Accuracy / dataContainer{j}.Count;
        end    
    end

    bar(plotData(:, 2:end), 'Grouped');
    legend('MFCC', 'LPD', 'Filterbank', 'PLP')
    xlabel('Articulation type', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    ylabel('Classification accuracy (%)', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    title(sprintf('Classifier Accuracy at %s SNR', noiseLevel), 'FontSize',...
        fontSize*2, 'FontWeight', 'bold', 'Color', fontColour)
    
    set(gca, 'XTickLabel', newNames, 'YGrid', 'on', 'FontSize', fontSize)
end

