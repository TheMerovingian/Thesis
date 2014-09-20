function [ outputAudio ] = AddNoise( audio, noiseLevel )
% AddNoise  Adds noise to the input signal at the level specified
% Inputs:   audio       - Audio signal to add noise to
%           noiseLevel  - The SNR to add the noise at
%
% Function code predominantly based off code by Anthony Bath in his 2010
% thesis

%Calculate the RMS power of the
signal_power = sqrt(mean(audio.^2));

%Based on the input SNR, calculate the required noise power
noise_power = signal_power/(10^(noiseLevel/20));

%Generate some random noise as long as the signal
noise = randn(length(audio),1);

%Obtain gains k required to adjust the power of noise to the required
%noise power
k = noise_power/sqrt(mean(noise.^2));

%Multiply the noisy array by the gains k to adjust the power
noise = k.*noise;

%Combine the signal and the noise
outputAudio = audio + noise;

end


