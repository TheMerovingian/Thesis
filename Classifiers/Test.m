addpath('../Voicebox/')
addpath('../amtoolbox/monaural/')
addpath('../AudioManipulation/')

close all

frameSize = 0.02;
X = linspace(0, Fs, length(audio));

[audio, Fs] = audioread('C3CA010C.wav');

noise = AddNoise(audio, 5);
plot(X, noise, X, audio)

audiowrite('Noise.wav', noise, Fs);
noise2 = audioread('Noise.wav');

figure()
plot(X, noise2, X, audio)

diff = noise-noise2;
