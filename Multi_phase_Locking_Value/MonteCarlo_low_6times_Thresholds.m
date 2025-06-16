%set these
num_monte_sq = 100;
num_monte = num_monte_sq*num_monte_sq;
armlift = 'l';
samplerate = 2048; %sampling rate in hz
tms = (0:1/2048:1-1/2048)*1000; %sampling times, 1sx2048 hz
mindelay_ms = 0; %make sure that the max delay here is a valid sampling time from tms
maxdelay_ms = 125; %make sure that the max delay here is a valid sampling time from tms
delayvalues_ms = (mindelay_ms/1000:1/samplerate:maxdelay_ms/1000)*1000;
mindelay_pos = (mindelay_ms/1000)/(1/samplerate)+1; %this assumes your time index starts at 0
maxdelay_pos = (maxdelay_ms/1000)/(1/samplerate)+1; %this assumes your time index starts at 0
percentthreshold = 95; %change as needed

%initialize some variables
cv_values1 = zeros(1,num_monte);
cv_values2 = zeros(1,num_monte);
cv_values3 = zeros(1,num_monte);
cv_values4 = zeros(1,num_monte);
cv_values5 = zeros(1,num_monte);
cv_values6 = zeros(1,num_monte);

%filter our data appropriately using EEGLab filters, to stay consistent
%with other preprocessing steps
eeglab; %start eeglab

%EEG & EMG 15-25 Hz
EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_high','setname','EEG_C3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EEG_C3_high_15_25 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_low','setname','EEG_C3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EEG_C3_low_15_25 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_high','setname','EEG_C4_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EEG_C4_high_15_25 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_low','setname','EEG_C4_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EEG_C4_low_15_25 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_high','setname','EMG_N3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EMG_N3_high_15_25 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_low','setname','EMG_N3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',15,'hicutoff',25);
EMG_N3_low_15_25 = EEG.data;

%EEG 1-5 Hz
EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_high','setname','EEG_C3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',5);
EEG_C3_high_1_5 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_low','setname','EEG_C3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',5);
EEG_C3_low_1_5 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_high','setname','EEG_C4_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',5);
EEG_C4_high_1_5 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_low','setname','EEG_C4_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',5);
EEG_C4_low_1_5 = EEG.data;

%EMG 1-10-Hz
EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_high','setname','EMG_N3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',10);
EMG_N3_high_1_10 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_low','setname','EMG_N3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',10);
EMG_N3_low_1_10 = EEG.data;

%EEG 5-10 Hz
EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_high','setname','EEG_C3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',5,'hicutoff',10);
EEG_C3_high_5_10 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C3_low','setname','EEG_C3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',5,'hicutoff',10);
EEG_C3_low_5_10 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_high','setname','EEG_C4_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',5,'hicutoff',10);
EEG_C4_high_5_10 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EEG_C4_low','setname','EEG_C4_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',5,'hicutoff',10);
EEG_C4_low_5_10 = EEG.data;

%EMG 10-20 Hz
EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_high','setname','EMG_N3_high','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',10,'hicutoff',20);
EMG_N3_high_10_20 = EEG.data;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','EMG_N3_low','setname','EMG_N3_low','srate',2048,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',10,'hicutoff',20);
EMG_N3_low_10_20 = EEG.data;

%split everything into smaller 1 second trials
datalength_high = size(EMG_N3_high,2);
datalength_low = size(EMG_N3_low,2);
datatrials_high = size(EMG_N3_high,1);
datatrials_low = size(EMG_N3_low,1);
time_ms_low = size(EMG_N3_low,2)/samplerate*1000;
time_ms_high = size(EMG_N3_high,2)/samplerate*1000;
rows_per_trial_low = datalength_low /samplerate;
samples_per_row_low = datalength_low / rows_per_trial_low;
time_per_row_ms_low = datalength_low/samplerate/rows_per_trial_low*1000;
rows_per_trial_high = datalength_high /samplerate;
samples_per_row_high = datalength_high / rows_per_trial_high;
time_per_row_ms_high = datalength_high/samplerate/rows_per_trial_high*1000;
EEG_C3_high_15_25_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C3_high_1_5_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C3_high_5_10_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C4_high_15_25_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C4_high_1_5_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C4_high_5_10_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EMG_N3_high_10_20_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EMG_N3_high_15_25_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EMG_N3_high_1_10_split = zeros(rows_per_trial_high*datatrials_high,datalength_high/rows_per_trial_high);
EEG_C3_low_15_25_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EEG_C3_low_1_5_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EEG_C3_low_5_10_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EEG_C4_low_15_25_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EEG_C4_low_1_5_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EEG_C4_low_5_10_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EMG_N3_low_10_20_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EMG_N3_low_15_25_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
EMG_N3_low_1_10_split = zeros(rows_per_trial_low*datatrials_low,datalength_low/rows_per_trial_low);
k = 1;
for i=1:datatrials_high
    for j = 1:rows_per_trial_high
    EEG_C3_high_15_25_split(k,:)= EEG_C3_high_15_25(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EEG_C3_high_1_5_split(k,:)= EEG_C3_high_1_5(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EEG_C3_high_5_10_split(k,:)= EEG_C3_high_5_10(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EEG_C4_high_15_25_split(k,:)= EEG_C4_high_15_25(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EEG_C4_high_1_5_split(k,:)= EEG_C4_high_1_5(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EEG_C4_high_5_10_split(k,:)= EEG_C4_high_5_10(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EMG_N3_high_10_20_split(k,:)= EMG_N3_high_10_20(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EMG_N3_high_15_25_split(k,:)= EMG_N3_high_15_25(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    EMG_N3_high_1_10_split(k,:)= EMG_N3_high_1_10(i,1+((j-1)*samples_per_row_high):j*samples_per_row_high);
    k = k + 1;
    end
end
k = 1;
for i=1:datatrials_low
    for j = 1:rows_per_trial_low
    EEG_C3_low_15_25_split(k,:)= EEG_C3_low_15_25(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EEG_C3_low_1_5_split(k,:)= EEG_C3_low_1_5(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EEG_C3_low_5_10_split(k,:)= EEG_C3_low_5_10(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EEG_C4_low_15_25_split(k,:)= EEG_C4_low_15_25(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EEG_C4_low_1_5_split(k,:)= EEG_C4_low_1_5(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EEG_C4_low_5_10_split(k,:)= EEG_C4_low_5_10(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EMG_N3_low_10_20_split(k,:)= EMG_N3_low_10_20(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EMG_N3_low_15_25_split(k,:)= EMG_N3_low_15_25(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    EMG_N3_low_1_10_split(k,:)= EMG_N3_low_1_10(i,1+((j-1)*samples_per_row_low):j*samples_per_row_low);
    k = k + 1;
    end
end

% flip our data so that each colum is a trial
EEG_C3_low_15_25_split = EEG_C3_low_15_25_split';
EEG_C3_low_1_5_split = EEG_C3_low_1_5_split';
EEG_C3_low_5_10_split = EEG_C3_low_5_10_split';
EEG_C4_low_15_25_split = EEG_C4_low_15_25_split';
EEG_C4_low_1_5_split = EEG_C4_low_1_5_split';
EEG_C4_low_5_10_split = EEG_C4_low_5_10_split';
EMG_N3_low_10_20_split = EMG_N3_low_10_20_split';
EMG_N3_low_15_25_split = EMG_N3_low_15_25_split';
EMG_N3_low_1_10_split = EMG_N3_low_1_10_split';
EEG_C3_high_15_25_split = EEG_C3_high_15_25_split';
EEG_C3_high_1_5_split = EEG_C3_high_1_5_split';
EEG_C3_high_5_10_split = EEG_C3_high_5_10_split';
EEG_C4_high_15_25_split = EEG_C4_high_15_25_split';
EEG_C4_high_1_5_split = EEG_C4_high_1_5_split';
EEG_C4_high_5_10_split = EEG_C4_high_5_10_split';
EMG_N3_high_10_20_split = EMG_N3_high_10_20_split';
EMG_N3_high_15_25_split = EMG_N3_high_15_25_split';
EMG_N3_high_1_10_split = EMG_N3_high_1_10_split';

%hilbert transform and convert to ipsi and contra
EMG_N3_low_10_20_phase = hilbert(EMG_N3_low_10_20_split);
EMG_N3_low_15_25_phase = hilbert(EMG_N3_low_15_25_split);
EMG_N3_low_1_10_phase = hilbert(EMG_N3_low_1_10_split);
EMG_N3_high_10_20_phase = hilbert(EMG_N3_high_10_20_split);
EMG_N3_high_15_25_phase = hilbert(EMG_N3_high_15_25_split);
EMG_N3_high_1_10_phase = hilbert(EMG_N3_high_1_10_split);
if armlift == 'r'
contra_low_15_25_phase = hilbert(EEG_C3_low_15_25_split);
contra_low_1_5_phase = hilbert(EEG_C3_low_1_5_split);
contra_low_5_10_phase = hilbert(EEG_C3_low_5_10_split);
ipsi_low_15_25_phase = hilbert(EEG_C4_low_15_25_split);
ipsi_low_1_5_phase = hilbert(EEG_C4_low_1_5_split);
ipsi_low_5_10_phase = hilbert(EEG_C4_low_5_10_split);
contra_high_15_25_phase = hilbert(EEG_C3_high_15_25_split);
contra_high_1_5_phase = hilbert(EEG_C3_high_1_5_split);
contra_high_5_10_phase = hilbert(EEG_C3_high_5_10_split);
ipsi_high_15_25_phase = hilbert(EEG_C4_high_15_25_split);
ipsi_high_1_5_phase = hilbert(EEG_C4_high_1_5_split);
ipsi_high_5_10_phase = hilbert(EEG_C4_high_5_10_split);
end
if armlift == 'l'
ipsi_low_15_25_phase = hilbert(EEG_C3_low_15_25_split);
ipsi_low_1_5_phase = hilbert(EEG_C3_low_1_5_split);
ipsi_low_5_10_phase = hilbert(EEG_C3_low_5_10_split);
contra_low_15_25_phase = hilbert(EEG_C4_low_15_25_split);
contra_low_1_5_phase = hilbert(EEG_C4_low_1_5_split);
contra_low_5_10_phase = hilbert(EEG_C4_low_5_10_split);
ipsi_high_15_25_phase = hilbert(EEG_C3_high_15_25_split);
ipsi_high_1_5_phase = hilbert(EEG_C3_high_1_5_split);
ipsi_high_5_10_phase = hilbert(EEG_C3_high_5_10_split);
contra_high_15_25_phase = hilbert(EEG_C4_high_15_25_split);
contra_high_1_5_phase = hilbert(EEG_C4_high_1_5_split);
contra_high_5_10_phase = hilbert(EEG_C4_high_5_10_split);
end

%set up our inputs and outputs, with delays
input1 = ipsi_low_1_5_phase;
input2 = ipsi_low_5_10_phase;
input3 = ipsi_low_15_25_phase;
input4 = contra_low_1_5_phase;
input5 = contra_low_5_10_phase;
input6 = contra_low_15_25_phase;
output1 = EMG_N3_low_1_10_phase;
output2 = EMG_N3_low_10_20_phase;
output3 = EMG_N3_low_15_25_phase;

Coherencetemp=zeros(size(input1));
Coherencetempnormalized=zeros(size(input1));
outputshuffle = zeros(size(output1)); %temporary shuffled output
outputlength = size(output1,2);
shuffleindex = 1:(length(Coherencetemp));



k = 0;
for j = 1:num_monte_sq
for i = 1:num_monte_sq
    k = k+1;
   %shuffle
shuffleindex = shuffleindex(randperm(length(shuffleindex)));

%combo 1 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output1(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input1).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values1(k)=mean(abs((mean (Coherencetempnormalized,2))));
%combo 2 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output2(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input2).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values2(k)=mean(abs((mean (Coherencetempnormalized,2))));
%combo 3 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output3(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input3).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values3(k)=mean(abs((mean (Coherencetempnormalized,2))));
%combo 4 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output1(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input4).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values4(k)=mean(abs((mean (Coherencetempnormalized,2))));
%combo 5 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output2(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input5).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values5(k)=mean(abs((mean (Coherencetempnormalized,2))));
%combo 6 of 6 
    for l = 1:length(shuffleindex)
        outputshuffle(l,:) = output3(shuffleindex(l),:);
    end
    %coherence calculations
    Coherencetemp = (input6).*(conj(outputshuffle));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    cv_values6(k)=mean(abs((mean (Coherencetempnormalized,2))));
end
j
end

%threshold calculations

%to find any particular p value, rounded to the nearest sample point
inputvar = cv_values1;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold1 = inputvar(inputindex);
inputvar = cv_values2;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold2 = inputvar(inputindex);
inputvar = cv_values3;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold3 = inputvar(inputindex);
inputvar = cv_values4;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold4 = inputvar(inputindex);
inputvar = cv_values5;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold5 = inputvar(inputindex);
inputvar = cv_values6;
inputvar = sort(inputvar);
inputindex = round((percentthreshold*((size(inputvar,2))/100)));
threshold6 = inputvar(inputindex);
