function [] = PerformClassification(classifierFileList, outputDirectory)

WAV = 'wav';

% HTK output varaibles
STFT_OUTPUT_CODE = 9;
NNMF_OUTPUT_CODE = 9;
LPC_OUTPUT_CODE = 9;

% STFT Variables
FRAME_SIZE = 0.025;      % In seconds
NUMBER_OF_PEAKS = 15;

% LPC Variables
FILTER_ORDER = 20;

for n = 1:length(classifierFileList)
    file = classifierFileList{n};
    
    path = strsplit(file, '.');
    
    ext = path{2};
    
    splitpath = strsplit(path{1}, '\\');
    name = splitpath{end};

    if ~exist(outputDirectory, 'dir')
        mkdir(outputDirectory)
    end
    
    if ~strcmp(ext, WAV)
        continue
    end
    
    [audio, Fs] = audioread(file);
    
    %% STFT
    STFTData = STFTClassifier(audio, Fs, FRAME_SIZE, NUMBER_OF_PEAKS);
    
    stftHTKFile = strcat(outputDirectory, name, '.stft');
    
    if exist(stftHTKFile, 'file')
        delete(stftHTKFile);
    end
    
    writehtk(stftHTKFile, STFTData, FRAME_SIZE, STFT_OUTPUT_CODE);
    
    %{
    %% LPC
    LPCData = LPCClassifier(audio, Fs, FILTER_ORDER, FRAME_SIZE);
    
    lpcHTKFile = strcat(OUTPUT_DIR, name, '.lpc');
    
    if exist(lpcHTKFile, 'file')
        delete(lpcHTKFile);
    end
    
    writehtk(lpcHTKFile, LPCData, FRAME_SIZE, LPC_OUTPUT_CODE);
    %}
    %% NNMF
    % clearvars -except audio Fs
    % [phonemes, NNMFData] = NNMFClassifier(audio', Fs);
end

