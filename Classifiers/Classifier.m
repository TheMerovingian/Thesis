clear all

addpath('../Voicebox/')
WAV = 'wav';

OUTPUT_DIR = 'F:/Thesis/External/ClassifierTraining/Classifiers/';
AUDIO_DIR = 'F:/Thesis/External/Audio/';

NOISE_LEVELS = ['Clean', '30dB', '15dB', '5dB'];

TRAINING_AUDIO_DIR = 'Development/';
EVAL_AUDIO_DIR = 'Evaluation/';

TRAINING_FILES = getAllFiles(strcat(AUDIO_DIR, 'Clean/', TRAINING_AUDIO_DIR));
EVAL_FILES = getAllFiles(strcat(AUDIO_DIR, 'Clean/', EVAL_AUDIO_DIR));

CLASSIFICATION_TYPE = {'Training', 'Evaluation'};
CLASSIFIER_FILES = {TRAINING_FILES, EVAL_FILES};


for noise = NOISE_LEVELS
    
    trainingOutput = strcat(OUTPUT_DIR, noise, '/Training/');
    evalOutput = strcat(OUTPUT_DIR, noise, '/Eval/');
    OUTPUT_DIR = {trainingOutput, evalOutput};

    
    outputDir = strcat(OUTPUT_DIR, 'Training/');
    TRAINING_FILES = getAllFiles(TRAINING_AUDIO_DIR);
    
    for N = 1:length(CLASSIFIER_FILES)
        fprintf('Performing %s classification\n', CLASSIFICATION_TYPE{N})

        tic
        PerformClassification(CLASSIFIER_FILES{N}, OUTPUT_DIR{N})
        toc

    end
end






