function [] = PlotNoiseAccuracyByType( noiseCollection )
    % MFC, LPD, FBNK, PLP
    
    fontSize = 16;
    fontColour = 'k';

    noiseLevels = {'Clean', '30dB', '15dB', '5dB'};
    classifierNames = {'MFCC', 'LPD', 'Filterbank', 'PLP'};
    
    phoneTypes = keys(noiseCollection{1}{1});
    
    output = cell(4,1);
    
    % Each classifier
    for n = 1:4
        output{n} = zeros(8, 4);
        
        % Each phone type
        for i = 1:length(phoneTypes)
            label = phoneTypes{i};
            
            % Each noise level
            for j = 1:length(noiseLevels)
                classifier = noiseCollection{j}{1, n};
                output{n}(i, j) = classifier(label).Accuracy / classifier(label).Count;

            end
        end
    end
    
    for n = 1:4
        figure
        bar(output{n}, 'Grouped')
        title(sprintf('%s Classification Accuracy for Articulation Type', ...
            classifierNames{n}), 'FontSize', fontSize*2, 'FontWeight', 'bold')
        set(gca, 'XTickLabel', phoneTypes, 'FontSize', fontSize, 'YGrid', 'on', 'YMinorTick', 'on')
        xlabel('Articulation type', 'FontSize',...
            fontSize, 'FontWeight', 'bold', 'Color', fontColour)
        ylabel('Classification accuracy (%)', 'FontSize',...
            fontSize, 'FontWeight', 'bold', 'Color', fontColour)
        legend(noiseLevels)
    end
end

