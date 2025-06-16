%assumes eeglab is added to path and you are in data directory
%Assumes foes are named L1-25 and H1-25
%channel 21 = C4 (right); channel 24 = C3 (left); channel 33-40 = EMG1-4
%according to Runfeng:
%EMG 1 = triceps
%EMG 2 = biceps
%EMG 3 = deltoid
%EMG 4 = EOG

%variables
taskmarker = 65511;
samprate = 2048;
numtrials = 25;
triallength = 10;
numdatapoints = triallength*samprate;

%%%%%initialize data matricies
EEG_C3_low = zeros(numtrials, numdatapoints);
EEG_C4_low = zeros(numtrials, numdatapoints);
EMG_N1_low = zeros(numtrials, numdatapoints);
EMG_N2_low = zeros(numtrials, numdatapoints);
EMG_N3_low = zeros(numtrials, numdatapoints);
EMG_N4_low = zeros(numtrials, numdatapoints);
EEG_C3_high = zeros(numtrials, numdatapoints);
EEG_C4_high = zeros(numtrials, numdatapoints);
EMG_N1_high = zeros(numtrials, numdatapoints);
EMG_N2_high = zeros(numtrials, numdatapoints);
EMG_N3_high = zeros(numtrials, numdatapoints);
EMG_N4_high = zeros(numtrials, numdatapoints);
%%%%%

eeglab; %start eeglab

%process loop
for i = 1:25
workingfilehigh = ['H',num2str(i),'.bdf'];
workingfilelow = ['L',num2str(i),'.bdf'];

%load file
%high first, then low    
EEG = pop_biosig(workingfilehigh);
EEG = eeg_checkset( EEG );
%rereference data
EEG = pop_reref( EEG, [],'exclude',[33:40] );
EEG = eeg_checkset( EEG );
%cut extra data
EEG = pop_epoch( EEG, {  '65511'  }, [0  10], 'newname', 'BDF file epochss', 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
%save EEG channels
EEG_C3_high(i,:)=EEG.data(24,:);
EEG_C4_high(i,:)=EEG.data(21,:);
%setup EMG channels 1 to 4
tempEMG = EEG.data(33,:)-EEG.data(34,:);
EEG.data(33,:) = tempEMG;
tempEMG = EEG.data(35,:)-EEG.data(36,:);
EEG.data(34,:) = tempEMG;
tempEMG = EEG.data(37,:)-EEG.data(38,:);
EEG.data(35,:) = tempEMG;
tempEMG = EEG.data(39,:)-EEG.data(40,:);
EEG.data(36,:) = tempEMG;
%delete all but the 4 EMG channels, we don't need this data anymore
EEG = pop_select( EEG, 'channel',{'EXG1','EXG2','EXG3','EXG4'});
%filter EMG data: notch 55-60 hz then highpass 20 hz
EEG = pop_eegfiltnew(EEG, 'locutoff',55,'hicutoff',65,'revfilt',1);
EEG = pop_eegfiltnew(EEG, 'locutoff',20);
%remove DC from each EMG channel
tempEMG = EEG.data(1,:);
EEG.data(1,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(2,:);
EEG.data(2,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(3,:);
EEG.data(3,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(4,:);
EEG.data(4,:) = tempEMG - mean(tempEMG);
%rectify each EMG channel
tempEMG = EEG.data(1,:);
EEG.data(1,:) = abs(tempEMG);
tempEMG = EEG.data(2,:);
EEG.data(2,:) = abs(tempEMG);
tempEMG = EEG.data(3,:);
EEG.data(3,:) = abs(tempEMG);
tempEMG = EEG.data(4,:);
EEG.data(4,:) = abs(tempEMG);
%save each EMG channel
EMG_N1_high(i,:) = EEG.data(1,:);
EMG_N2_high(i,:) = EEG.data(2,:);
EMG_N3_high(i,:) = EEG.data(3,:);
EMG_N4_high(i,:) = EEG.data(4,:);
%tick filenumber so we know we're still working
i
%done with the high, move to the low
EEG = pop_biosig(workingfilelow);
EEG = eeg_checkset( EEG );
%rereference data
EEG = pop_reref( EEG, [],'exclude',[33:40] );
EEG = eeg_checkset( EEG );
%cut extra data
EEG = pop_epoch( EEG, {  '65511'  }, [0  10], 'newname', 'BDF file epochss', 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
%save EEG channels
EEG_C3_low(i,:)=EEG.data(21,:);
EEG_C4_low(i,:)=EEG.data(24,:);
%setup EMG channels 1 to 4
tempEMG = EEG.data(33,:)-EEG.data(34,:);
EEG.data(33,:) = tempEMG;
tempEMG = EEG.data(35,:)-EEG.data(36,:);
EEG.data(34,:) = tempEMG;
tempEMG = EEG.data(37,:)-EEG.data(38,:);
EEG.data(35,:) = tempEMG;
tempEMG = EEG.data(39,:)-EEG.data(40,:);
EEG.data(36,:) = tempEMG;
%delete all but the 4 EMG channels, we don't need this data anymore
EEG = pop_select( EEG, 'channel',{'EXG1','EXG2','EXG3','EXG4'});
%filter EMG data: notch 55-60 hz then highpass 20 hz
EEG = pop_eegfiltnew(EEG, 'locutoff',55,'hicutoff',65,'revfilt',1);
EEG = pop_eegfiltnew(EEG, 'locutoff',20);
%remove DC from each EMG channel
tempEMG = EEG.data(1,:);
EEG.data(1,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(2,:);
EEG.data(2,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(3,:);
EEG.data(3,:) = tempEMG - mean(tempEMG);
tempEMG = EEG.data(4,:);
EEG.data(4,:) = tempEMG - mean(tempEMG);
%rectify each EMG channel
tempEMG = EEG.data(1,:);
EEG.data(1,:) = abs(tempEMG);
tempEMG = EEG.data(2,:);
EEG.data(2,:) = abs(tempEMG);
tempEMG = EEG.data(3,:);
EEG.data(3,:) = abs(tempEMG);
tempEMG = EEG.data(4,:);
EEG.data(4,:) = abs(tempEMG);
%save each EMG channel
EMG_N1_low(i,:) = EEG.data(1,:);
EMG_N2_low(i,:) = EEG.data(2,:);
EMG_N3_low(i,:) = EEG.data(3,:);
EMG_N4_low(i,:) = EEG.data(4,:);
%tick filenumber so we know we're still working
i
%and onto the next file
end