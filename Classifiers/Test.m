addpath('../Voicebox/')
addpath('../amtoolbox/monaural/')
addpath('../AudioManipulation/')

close all

noiseLevels = [30, 15, 5];
[audio, Fs] = audioread('C3CA010B.wav');

for noise = noiseLevels
    noisy = AddNoise(audio, noise);
    figure
    hold on
    plot(noisy, 'b')
    plot(audio, 'r')
    title(sprintf('Noise Addition at %idB SNR', noise), 'FontSize', 32, ...
        'FontWeight', 'bold')
    legend(sprintf('%idB SNR', noise), 'Clean', 'FontSize', 16)
    ylabel('Amplitude', 'FontSize', 16)
    set(gca, 'FontSize', 16, 'XTickLabel', '', 'XTick', 0)
end