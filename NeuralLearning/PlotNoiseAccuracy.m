function [] = PlotNoiseAccuracy(P2Averages)
    
    lineThickness = 3.5;
    load('Data/AccuracyData.mat')
    fontSize = 16;
    fontColour = 'k';

    textNoiseLevels = {'Clean', '30dB', '15dB', '5dB'};

    [noClassifiers, ~] = size(AccuracyData);

    for n = 1:noClassifiers      
        plotData(n,:) = [AccuracyData{n,2:5}];
        classifiers{n} = AccuracyData{n,1};
    end
    plotData = plotData .* 100;
        
    figure
    bar(plotData, 'Grouped')
    xlabel('Classifier', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    ylabel('Classification accuracy (%)', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    title('Classifier Accuracy at Various SNR', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)

    set(gca, 'XTickLabel', classifiers, 'FontSize', fontSize, 'YGrid', 'on')
    
    legend(textNoiseLevels)
    ylim([0,60])

    
    
    plotData = plotData'; %[plotData' P2Averages'];

    figure
    plot(plotData, '--o', 'LineWidth', lineThickness)
    xlabel('Noise Level', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    ylabel('Classification accuracy (%)', 'FontSize',...
        fontSize, 'FontWeight', 'bold', 'Color', fontColour)
    title('Classifier Accuracy at Various SNR', 'FontSize',...
        fontSize*2, 'FontWeight', 'bold', 'Color', fontColour)

    set(gca, 'XTickLabel', textNoiseLevels, 'FontSize', fontSize, 'YGrid', 'on',...
        'XTickMode', 'Manual')
    set(gca,'XLim',[1 4])
    set(gca,'XTick',1:1:4)
    
    legend({classifiers{:} 'Phase 2'})
    ylim([0,60])
end

