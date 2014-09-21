clear all
addpath('../Classifiers')
WAV = 'wav';

AUDIO_DIR = 'F:/Thesis/External/Audio/';

NOISE_LEVELS = [5]; %[30, 15, 5];

TRAINING_AUDIO_DIR = 'Development/';

TRAINING_FILES = getAllFiles(strcat(AUDIO_DIR, 'Clean/', TRAINING_AUDIO_DIR));

EVAL_AUDIO_DIR = 'Evaluation/';

EVAL_FILES = getAllFiles(strcat(AUDIO_DIR, 'Clean/', EVAL_AUDIO_DIR));

CLASSIFIER_FILES = {TRAINING_FILES, EVAL_FILES};

for noiseLvl = NOISE_LEVELS
    for files = CLASSIFIER_FILES
        for n = 1:length(files{1})
            file = files{1}{n};
            newFile = strrep(file, 'Clean', sprintf('%idB', noiseLvl));
            
            path = strsplit(file, '.');

            ext = path{2};

            splitpath = strsplit(path{1}, '\\');
            
            directory = sprintf('%s/', splitpath{1:end-1});
            directory = strrep(directory, 'Clean', sprintf('%idB', noiseLvl));
            
            if ~exist(directory, 'dir')
                mkdir(directory)
            end
            
            if ~strcmp(ext, WAV)               
                copyfile(file, newFile);
                continue
            end

            [audio, Fs] = audioread(file);

            noisy = AddNoise(audio, noiseLvl);
            
            if exist(newFile, 'file')
                X = linspace(0, Fs, length(audio));
                noise = audioread(newFile);
                
                plot(X, noise, X, audio)
                continue
            end
            
            audiowrite(newFile, noisy, Fs);
        end
    end
end