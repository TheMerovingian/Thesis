clear all

addpath('../Voicebox/')
WAV = 'wav';

OUTPUT_DIR = 'F:/Thesis/External/ClassifierTraining/Classifiers/';
AUDIO_DIR = 'F:/Thesis/External/Audio/';

NOISE_LEVELS = {'Clean', '30dB', '15dB', '5dB'};

TRAINING_AUDIO_DIR = 'Development/';
EVAL_AUDIO_DIR = 'Evaluation/';

CLASSIFICATION_TYPE = {'Training', 'Evaluation'};

for noiseLvl = NOISE_LEVELS
    noise = noiseLvl{1};
    
    trainingOutput = strcat(OUTPUT_DIR, noise, '/Training/');
    evalOutput = strcat(OUTPUT_DIR, noise, '/Eval/');
    outputDirs = {trainingOutput, evalOutput};

    trainingFiles = getAllFiles(strcat(AUDIO_DIR, 'Clean/', TRAINING_AUDIO_DIR));
    evalFiles = getAllFiles(strcat(AUDIO_DIR, 'Clean/', EVAL_AUDIO_DIR));

    classifierFiles = {trainingFiles, evalFiles};
    
    for N = 1:length(classifierFiles)
        fprintf('Performing %s classification at %s SNR\n', CLASSIFICATION_TYPE{N}, noiseLvl{1})

        tic
        PerformClassification(classifierFiles{N}, outputDirs{N})
        toc

    end
end






