function [LPCData] = LPCClassifier(audio, Fs, filterOrder, frameSize)

 % Determine the number of samples per time step
    samplesPerStep = ceil(Fs * frameSize);

    startIndex = 1;
    count = 1;
    audioLength = length(audio);

    while startIndex < audioLength

        % Determine the end index for the STFT
        endIndex = startIndex+samplesPerStep;
        if endIndex > audioLength
            endIndex = audioLength;
        end

        % Extract the data for this time step
        sample = audio(startIndex:endIndex);

        %LPCData(count,:) = lpccovar(sample, filterOrder);
        LPCData(count,:) = lpc(sample, filterOrder);
        
        % Increment the time step
        startIndex = startIndex + samplesPerStep;
        count = count + 1;
    end
end