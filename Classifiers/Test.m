addpath('../Voicebox/')
addpath('../amtoolbox/monaural/')

close all

frameSize = 0.02;

[audio, Fs] = audioread('C3CA010B.wav');

%dwt = dwtr(audio, 

