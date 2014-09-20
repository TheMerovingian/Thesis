function [STFT] = STFTClassifier(audio, Fs, frameSize, numberOfPeaks)
    
    DENORMALISATION_FACTOR = (Fs / 2) / pi;

    MAX_PEAKS = numberOfPeaks;
    
    sampleSize = ceil(frameSize * Fs);

    [S, F] = spectrogram(audio, hamming(sampleSize));
    
    S = S';
    F = F' .* DENORMALISATION_FACTOR;
    
    [rows, ~] = size(S);
    
    for N = 1:rows
        transform = S(N,:);
        
        [~, peakLocs] = findpeaks(abs(transform),'SortStr','descend');
        
        % Take only the top X peaks (specified in constants)
        noOfPeaks = length(peakLocs);
        if MAX_PEAKS > noOfPeaks
            topXPeaks = peakLocs;
        else
            topXPeaks = peakLocs(1:MAX_PEAKS);
            noOfPeaks = MAX_PEAKS;
        end

        % Determine the frequency corresponding to each peak
        peakFreqs = zeros(1, MAX_PEAKS);
        peakFreqs(1,1:noOfPeaks) = round(F(topXPeaks));

        STFT(N,:) = peakFreqs;      
    end
    % Determine the number of samples per time step
    %{
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
        sample = sample.*hamming(length(sample));

        % Perform the fft and strip the reflection
        transform = fft(sample);
        plot(abs(transform))
        transform = transform(1:ceil(length(transform)/2));

        % Set up the frequency data
        freq = linspace(0, Fs/2, length(sample)/2+1);

        % Find all the peaks and sort them in decending order of magnitude
        [~, peakLocs] = findpeaks(abs(transform),'SortStr','descend');

        % Take only the top X peaks (specified in constants)
        noOfPeaks = length(peakLocs);
        if peakCount > noOfPeaks
            topXPeaks = peakLocs;
        else
            topXPeaks = peakLocs(1:peakCount);
            noOfPeaks = 10;
        end

        % Determine the frequency corresponding to each peak
        peakFreqs = zeros(1, peakCount);
        peakFreqs(1,1:noOfPeaks) = round(freq(topXPeaks));
        
        STFT(count,:) = peakFreqs;

        % Increment the time step
        startIndex = startIndex + ceil(samplesPerStep * (overlap / 100));
        count = count + 1;
    end
end
%}

end