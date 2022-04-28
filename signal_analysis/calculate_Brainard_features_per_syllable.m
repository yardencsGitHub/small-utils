function feature_elements = calculate_Brainard_features_per_syllable(wav_folder,path_to_annotation_file)
% This script will take an annotation file and use its data structure to extract features for all syllables in a dataset.
% The annotation file includes the structures:
% keys - a matlab cell array that holdes the file names (to be processed in
% wav_folder)
% elements - a cell array of struct with (among others) fields:
% -- segType - array of syllable tags (integers)
% -- segFileStartTimes - time in seconds from beginning of file of syllable
% onsets
% -- segFileEndTimes - time in seconds from beginning of file of syllables
% offsets.

% The script will create a matching cell array of structs that will include
% for each syllable the duration and the average and mean of the SAP
% features:

% feature_elements{file_number_matching_keys}.
%                           syllable_duration (simply defined)
%                           Fundamental Frequency - averaged at middle 80%
%                              of syllable (8msec windows, step = 2msec)
%                           Time to half-peak amplitude (smoothed rectified
%                             wav, using 2msec gaussian)
%                           Frequency slope. Frequency slope was defined as the mean derivative of
%                             fundamental frequency over the central 80% of the syllable
%                           Amplitude slope. Amplitude slope was defined as follows: Amplitude
%                             slope  (P2 - P1)/(P2 +P1), where P1 and P2 are the average amplitude of the first and second halves of the
%                             syllable, respectively.
%                           Spectral entropy
%                           Temporal Entropy
%                           Spectrotemporal entropy

% Each is a vector with entries matching the syllables


feature_elements = {};
load(path_to_annotation_file);

for fnum = 1:numel(keys)
    empty_element = struct;
    empty_element.syllable_duration = zeros(1,numel(elements{fnum}.segType));
    empty_element.FF = zeros(1,numel(elements{fnum}.segType));
    empty_element.time_to_half_peak = zeros(1,numel(elements{fnum}.segType));
    empty_element.FF_slope = zeros(1,numel(elements{fnum}.segType));
    empty_element.Amplitude_Slope = zeros(1,numel(elements{fnum}.segType));
    empty_element.Spectral_Entropy = zeros(1,numel(elements{fnum}.segType));
    empty_element.Temporal_Entropy = zeros(1,numel(elements{fnum}.segType));
    empty_element.SpectroTemporal_Entropy = zeros(1,numel(elements{fnum}.segType));
    
    fname = fullfile(wav_folder,keys{fnum});
    [y,fs] = audioread(fname);
    y = filter_sound_sam(y); % reject DC
    %[features]=koenigSpectral(y,fs);
    T = numel(y)/fs;
    dt = 1/fs;
    timevec = [dt:dt:T] - dt/2;
    for segnum = 1:numel(elements{fnum}.segType)
        idx = find(timevec >= elements{fnum}.segFileStartTimes(segnum) &  timevec <= elements{fnum}.segFileEndTimes(segnum));
        features = Brainard_features(y(idx),fs);
        if ~isstruct(features)
            continue;
            '/';
        end
        empty_element.syllable_duration(segnum) = elements{fnum}.segFileEndTimes(segnum) - elements{fnum}.segFileStartTimes(segnum);
        empty_element.FF(segnum) = features.FF;
        empty_element.time_to_half_peak(segnum) = features.time_to_half_peak;
        empty_element.FF_slope(segnum) = features.FF_slope;
        empty_element.Amplitude_Slope(segnum) = features.Amplitude_Slope;
        empty_element.Spectral_Entropy(segnum) = features.Spectral_Entropy;
        empty_element.Temporal_Entropy(segnum) = features.Temporal_Entropy;
        empty_element.SpectroTemporal_Entropy(segnum) = features.SpectroTemporal_Entropy;
        
    end
    feature_elements{fnum} = empty_element;
    disp([fnum numel(keys)]);
end
        
