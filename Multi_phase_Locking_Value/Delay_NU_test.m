%edit this
armlift = 'r'; %r or l, determines ipsilateral vs contralateral processing
samplerate = 2048; %sampling rate in hz
tms = (0:1/2048:1-1/2048)*1000; %sampling times, 1sx2048 hz
mindelay_ms = 0; %make sure that the max delay here is a valid sampling time from tms
maxdelay_ms = 125; %make sure that the max delay here is a valid sampling time from tms
delayvalues_ms = (mindelay_ms/1000:1/samplerate:maxdelay_ms/1000)*1000;
mindelay_pos = (mindelay_ms/1000)/(1/samplerate)+1; %this assumes your time index starts at 0
maxdelay_pos = (maxdelay_ms/1000)/(1/samplerate)+1; %this assumes your time index starts at 0


%input data into matrix and flip so that each colum is a trial
%input_EEG_C3_low=(EEG_C3_low)';
%input_EEG_C4_low=(EEG_C4_low)';
%input_EEG_C3_high=(EEG_C3_high)';
%input_EEG_C4_high=(EEG_C4_high)';
%output_EMG_low=(EMG_N3_low)';
%output_EMG_high=(EMG_N3_high)';

%filter our data appropriately using EEGLab filters, to stay consistent
%with other preprocessing steps
eeglab; %start eeglab

%EEG & EMG 15-25 Hz - temporarily replaced by narrowband 20 hz filter
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

%hilbert transform
EEG_C3_low_15_25_phase = hilbert(EEG_C3_low_15_25_split);
EEG_C3_low_1_5_phase = hilbert(EEG_C3_low_1_5_split);
EEG_C3_low_5_10_phase = hilbert(EEG_C3_low_5_10_split);
EEG_C4_low_15_25_phase = hilbert(EEG_C4_low_15_25_split);
EEG_C4_low_1_5_phase = hilbert(EEG_C4_low_1_5_split);
EEG_C4_low_5_10_phase = hilbert(EEG_C4_low_5_10_split);
EMG_N3_low_10_20_phase = hilbert(EMG_N3_low_10_20_split);
EMG_N3_low_15_25_phase = hilbert(EMG_N3_low_15_25_split);
EMG_N3_low_1_10_phase = hilbert(EMG_N3_low_1_10_split);
EEG_C3_high_15_25_phase = hilbert(EEG_C3_high_15_25_split);
EEG_C3_high_1_5_phase = hilbert(EEG_C3_high_1_5_split);
EEG_C3_high_5_10_phase = hilbert(EEG_C3_high_5_10_split);
EEG_C4_high_15_25_phase = hilbert(EEG_C4_high_15_25_split);
EEG_C4_high_1_5_phase = hilbert(EEG_C4_high_1_5_split);
EEG_C4_high_5_10_phase = hilbert(EEG_C4_high_5_10_split);
EMG_N3_high_10_20_phase = hilbert(EMG_N3_high_10_20_split);
EMG_N3_high_15_25_phase = hilbert(EMG_N3_high_15_25_split);
EMG_N3_high_1_10_phase = hilbert(EMG_N3_high_1_10_split);

%initialize our delayed outputs
EMG_N3_high_10_20_phase_temp = zeros(size(EMG_N3_high_10_20_phase));
EMG_N3_high_15_25_phase_temp = zeros(size(EMG_N3_high_15_25_phase)); 
EMG_N3_high_1_10_phase_temp = zeros(size(EMG_N3_high_1_10_phase)); 
EMG_N3_low_10_20_phase_temp = zeros(size(EMG_N3_low_10_20_phase)); 
EMG_N3_low_15_25_phase_temp = zeros(size(EMG_N3_low_15_25_phase)); 
EMG_N3_low_1_10_phase_temp = zeros(size(EMG_N3_low_1_10_phase)); 
ipsi_high_1_5_phase_temp = zeros(size(EEG_C3_high_1_5_phase));
ipsi_high_15_25_phase_temp = zeros(size(EEG_C3_high_15_25_phase)); 
ipsi_high_5_10_phase_temp = zeros(size(EEG_C3_high_5_10_phase)); 
ipsi_low_1_5_phase_temp = zeros(size(EEG_C3_low_1_5_phase)); 
ipsi_low_15_25_phase_temp = zeros(size(EEG_C3_low_15_25_phase)); 
ipsi_low_5_10_phase_temp = zeros(size(EEG_C3_low_5_10_phase)); 
contra_high_1_5_phase_temp = zeros(size(EEG_C3_high_1_5_phase));
contra_high_15_25_phase_temp = zeros(size(EEG_C3_high_15_25_phase)); 
contra_high_5_10_phase_temp = zeros(size(EEG_C3_high_5_10_phase)); 
contra_low_1_5_phase_temp = zeros(size(EEG_C3_low_1_5_phase)); 
contra_low_15_25_phase_temp = zeros(size(EEG_C3_low_15_25_phase)); 
contra_low_5_10_phase_temp = zeros(size(EEG_C3_low_5_10_phase)); 
if armlift == 'r'
ipsi_high_5_10_phase_temp = EEG_C4_high_5_10_phase;
ipsi_high_15_25_phase_temp = EEG_C4_high_15_25_phase ;
ipsi_high_1_5_phase_temp = EEG_C4_high_1_5_phase ;
ipsi_low_5_10_phase_temp = EEG_C4_low_5_10_phase ;
ipsi_low_15_25_phase_temp = EEG_C4_low_15_25_phase ;
ipsi_low_1_5_phase_temp = EEG_C4_low_1_5_phase ;
contra_high_5_10_phase_temp = EEG_C3_high_5_10_phase;
contra_high_15_25_phase_temp = EEG_C3_high_15_25_phase ;
contra_high_1_5_phase_temp = EEG_C3_high_1_5_phase ;
contra_low_5_10_phase_temp = EEG_C3_low_5_10_phase ;
contra_low_15_25_phase_temp = EEG_C3_low_15_25_phase ;
contra_low_1_5_phase_temp = EEG_C3_low_1_5_phase ;
end
if armlift == 'l'
ipsi_high_5_10_phase_temp = EEG_C3_high_5_10_phase;
ipsi_high_15_25_phase_temp = EEG_C3_high_15_25_phase ;
ipsi_high_1_5_phase_temp = EEG_C3_high_1_5_phase ;
ipsi_low_5_10_phase_temp = EEG_C3_low_5_10_phase ;
ipsi_low_15_25_phase_temp = EEG_C3_low_15_25_phase ;
ipsi_low_1_5_phase_temp = EEG_C3_low_1_5_phase ;
contra_high_5_10_phase_temp = EEG_C4_high_5_10_phase;
contra_high_15_25_phase_temp = EEG_C4_high_15_25_phase ;
contra_high_1_5_phase_temp = EEG_C4_high_1_5_phase ;
contra_low_5_10_phase_temp = EEG_C4_low_5_10_phase ;
contra_low_15_25_phase_temp = EEG_C4_low_15_25_phase ;
contra_low_1_5_phase_temp = EEG_C4_low_1_5_phase ;
end

%initialize time coherence values
Coherency_15_25_EEG_15_25_EMG_ipsi_high = zeros(size(EMG_N3_high_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_15_25_EEG_15_25_EMG_ipsi_low = zeros(size(EMG_N3_low_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_15_25_EEG_15_25_EMG_contra_high = zeros(size(EMG_N3_high_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_15_25_EEG_15_25_EMG_contra_low = zeros(size(EMG_N3_low_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_5_10_EEG_10_20_EMG_ipsi_high = zeros(size(EMG_N3_high_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_5_10_EEG_10_20_EMG_ipsi_low = zeros(size(EMG_N3_low_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_5_10_EEG_10_20_EMG_contra_high = zeros(size(EMG_N3_high_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_5_10_EEG_10_20_EMG_contra_low = zeros(size(EMG_N3_low_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_1_5_EEG_1_10_EMG_ipsi_high = zeros(size(EMG_N3_high_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_1_5_EEG_1_10_EMG_ipsi_low = zeros(size(EMG_N3_low_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_1_5_EEG_1_10_EMG_contra_high = zeros(size(EMG_N3_high_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
Coherency_1_5_EEG_1_10_EMG_contra_low = zeros(size(EMG_N3_low_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_15_25_EEG_15_25_EMG_ipsi_high = zeros(size(EMG_N3_high_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_15_25_EEG_15_25_EMG_ipsi_low = zeros(size(EMG_N3_low_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_15_25_EEG_15_25_EMG_contra_high = zeros(size(EMG_N3_high_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_15_25_EEG_15_25_EMG_contra_low = zeros(size(EMG_N3_low_15_25_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_5_10_EEG_10_20_EMG_ipsi_high = zeros(size(EMG_N3_high_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_5_10_EEG_10_20_EMG_ipsi_low = zeros(size(EMG_N3_low_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_5_10_EEG_10_20_EMG_contra_high = zeros(size(EMG_N3_high_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_5_10_EEG_10_20_EMG_contra_low = zeros(size(EMG_N3_low_10_20_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_1_5_EEG_1_10_EMG_ipsi_high = zeros(size(EMG_N3_high_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_1_5_EEG_1_10_EMG_ipsi_low = zeros(size(EMG_N3_low_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_1_5_EEG_1_10_EMG_contra_high = zeros(size(EMG_N3_high_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);
CoherenceValues_1_5_EEG_1_10_EMG_contra_low = zeros(size(EMG_N3_low_1_10_phase_temp,1),1+maxdelay_pos-mindelay_pos);

%calculate coherence profiles - input is EEG, output is EMG
    for i = mindelay_pos:maxdelay_pos
    %delay our outputs
    EMG_N3_high_10_20_phase_temp(1:(end-i+1),:) = EMG_N3_high_10_20_phase(i:end,:);
    EMG_N3_high_15_25_phase_temp(1:(end-i+1),:) = EMG_N3_high_15_25_phase(i:end,:); 
    EMG_N3_high_1_10_phase_temp(1:(end-i+1),:) = EMG_N3_high_1_10_phase(i:end,:); 
    EMG_N3_low_10_20_phase_temp(1:(end-i+1),:) = EMG_N3_low_10_20_phase(i:end,:); 
    EMG_N3_low_15_25_phase_temp(1:(end-i+1),:) = EMG_N3_low_15_25_phase(i:end,:); 
    EMG_N3_low_1_10_phase_temp(1:(end-i+1),:) = EMG_N3_low_1_10_phase(i:end,:); 
    EMG_N3_high_10_20_phase_temp(1:(end-i+1),:) = EMG_N3_high_10_20_phase(i:end,:);
    EMG_N3_high_15_25_phase_temp((end-i+2):end,:) = EMG_N3_high_15_25_phase(1:i-1,:); 
    EMG_N3_high_1_10_phase_temp((end-i+2):end,:) = EMG_N3_high_1_10_phase(1:i-1,:); 
    EMG_N3_low_10_20_phase_temp((end-i+2):end,:) = EMG_N3_low_10_20_phase(1:i-1,:); 
    EMG_N3_low_15_25_phase_temp((end-i+2):end,:) = EMG_N3_low_15_25_phase(1:i-1,:); 
    EMG_N3_low_1_10_phase_temp((end-i+2):end,:) = EMG_N3_low_1_10_phase(1:i-1,:); 
    %calculate coherence
    %15-25 EEG 15-25 EMG ipsi high Calculations
    inputphasetemp = ipsi_high_15_25_phase_temp;
    outputphasetemp = EMG_N3_high_15_25_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_15_25_EEG_15_25_EMG_ipsi_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_15_25_EEG_15_25_EMG_ipsi_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %15-25 EEG 15-25 EMG ipsi low Calculations
    inputphasetemp = ipsi_low_15_25_phase_temp;
    outputphasetemp = EMG_N3_low_15_25_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_15_25_EEG_15_25_EMG_ipsi_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_15_25_EEG_15_25_EMG_ipsi_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %15-25 EEG 15-25 EMG contra high Calculation
    inputphasetemp = contra_high_15_25_phase_temp;
    outputphasetemp = EMG_N3_high_15_25_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_15_25_EEG_15_25_EMG_contra_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_15_25_EEG_15_25_EMG_contra_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %15-25 EEG 15-25 EMG contra low Calculations
    inputphasetemp = contra_low_15_25_phase_temp;
    outputphasetemp = EMG_N3_low_15_25_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_15_25_EEG_15_25_EMG_contra_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_15_25_EEG_15_25_EMG_contra_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %5-10 EEG 10-20 EMG ipsi high Calculations
    inputphasetemp = ipsi_high_5_10_phase_temp;
    outputphasetemp = EMG_N3_high_10_20_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_5_10_EEG_10_20_EMG_ipsi_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_5_10_EEG_10_20_EMG_ipsi_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));
    
    %5-10 EEG 10-20 EMG ipsi low Calculations
    inputphasetemp = ipsi_low_5_10_phase_temp;
    outputphasetemp = EMG_N3_low_10_20_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_5_10_EEG_10_20_EMG_ipsi_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_5_10_EEG_10_20_EMG_ipsi_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %5-10 EEG 10-20 EMG contra high Calculations
    inputphasetemp = contra_high_5_10_phase_temp;
    outputphasetemp = EMG_N3_high_10_20_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_5_10_EEG_10_20_EMG_contra_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_5_10_EEG_10_20_EMG_contra_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %5-10 EEG 10-20 EMG contra low Calculations
    inputphasetemp = contra_low_5_10_phase_temp;
    outputphasetemp = EMG_N3_low_10_20_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_5_10_EEG_10_20_EMG_contra_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_5_10_EEG_10_20_EMG_contra_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %1-5 EEG 1-10 EMG ipsi high Calculations
    inputphasetemp = ipsi_high_1_5_phase_temp;
    outputphasetemp = EMG_N3_high_1_10_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_1_5_EEG_1_10_EMG_ipsi_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_1_5_EEG_1_10_EMG_ipsi_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %1-5 EEG 1-10 EMG ipsi low Calculations
    inputphasetemp = ipsi_low_1_5_phase_temp;
    outputphasetemp = EMG_N3_low_1_10_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_1_5_EEG_1_10_EMG_ipsi_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_1_5_EEG_1_10_EMG_ipsi_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %1-5 EEG 1-10 EMG contra high Calculations
    inputphasetemp = contra_high_1_5_phase_temp;
    outputphasetemp = EMG_N3_high_1_10_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_1_5_EEG_1_10_EMG_contra_high(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_1_5_EEG_1_10_EMG_contra_high(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %1-5 EEG 1-10 EMG contra low Calculations
    inputphasetemp = contra_low_1_5_phase_temp;
    outputphasetemp = EMG_N3_low_1_10_phase_temp;
    Coherencetemp=zeros(size(inputphasetemp));
    Coherencetempnormalized=zeros(size(inputphasetemp));
    Coherencetemp = (inputphasetemp).*(conj(outputphasetemp));
    Coherencetempnormalized(:,:)=Coherencetemp(:,:)./abs(Coherencetemp(:,:)); %coherence normalization
    Coherency_1_5_EEG_1_10_EMG_contra_low(:,(1+i-mindelay_pos)) = (mean (Coherencetempnormalized,2));
    CoherenceValues_1_5_EEG_1_10_EMG_contra_low(:,(1+i-mindelay_pos)) = abs((mean (Coherencetempnormalized,2)));

    %tick our counter to see what our loop is doing
  i+1-mindelay_pos
    end

%create delay and coherence profiles
ipsi_EEG_EMG_15_25_low_delay = mean(CoherenceValues_15_25_EEG_15_25_EMG_ipsi_low,1);
contra_EEG_EMG_15_25_low_delay = mean(CoherenceValues_15_25_EEG_15_25_EMG_contra_low,1);

ipsi_EEG_5_10_EMG_10_20_low_delay = mean(CoherenceValues_5_10_EEG_10_20_EMG_ipsi_low,1);
contra_EEG_5_10_EMG_10_20_low_delay = mean(CoherenceValues_5_10_EEG_10_20_EMG_contra_low,1);

ipsi_EEG_1_5_EMG_1_10_low_delay = mean(CoherenceValues_1_5_EEG_1_10_EMG_ipsi_low,1);
contra_EEG_1_5_EMG_1_10_low_delay = mean(CoherenceValues_1_5_EEG_1_10_EMG_contra_low,1);

ipsi_EEG_EMG_15_25_high_delay = mean(CoherenceValues_15_25_EEG_15_25_EMG_ipsi_high,1);
contra_EEG_EMG_15_25_high_delay = mean(CoherenceValues_15_25_EEG_15_25_EMG_contra_high,1);

ipsi_EEG_5_10_EMG_10_20_high_delay = mean(CoherenceValues_5_10_EEG_10_20_EMG_ipsi_high,1);
contra_EEG_5_10_EMG_10_20_high_delay = mean(CoherenceValues_5_10_EEG_10_20_EMG_contra_high,1);

ipsi_EEG_1_5_EMG_1_10_high_delay = mean(CoherenceValues_1_5_EEG_1_10_EMG_ipsi_high,1);
contra_EEG_1_5_EMG_1_10_high_delay = mean(CoherenceValues_1_5_EEG_1_10_EMG_contra_high,1);

%{
%visualize results - rewrite and comment/uncomment as necessary 
%For now, lets just plot our delay charts in 4up form - ipsi/contra and
%high/low for each of the 3 ranges

%range 1 - 15-25 EEG 15-25 EMG
figure('Position', [544 157 1120 840])
t = tiledlayout(2,2);
nexttile
CVMean = mean(CoherenceValues_15_25_EEG_15_25_EMG_ipsi_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('15-25 EEG 15-25 EMG ipsi high')
nexttile
CVMean = mean(CoherenceValues_15_25_EEG_15_25_EMG_contra_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('15-25 EEG 15-25 EMG contra high')
nexttile
CVMean = mean(CoherenceValues_15_25_EEG_15_25_EMG_ipsi_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('15-25 EEG 15-25 EMG ipsi low')
nexttile
CVMean = mean(CoherenceValues_15_25_EEG_15_25_EMG_contra_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('15-25 EEG 15-25 EMG contra low')

%range 2
figure('Position', [544 157 1120 840])
t = tiledlayout(2,2);
nexttile
CVMean = mean(CoherenceValues_5_10_EEG_10_20_EMG_ipsi_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('5-10 EEG 10-20 EMG ipsi high')
nexttile
CVMean = mean(CoherenceValues_5_10_EEG_10_20_EMG_contra_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('5-10 EEG 10-20 EMG contra high')
nexttile
CVMean = mean(CoherenceValues_5_10_EEG_10_20_EMG_ipsi_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('5-10 EEG 10-20 EMG ipsi low')
nexttile
CVMean = mean(CoherenceValues_5_10_EEG_10_20_EMG_contra_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('5-10 EEG 10-20 EMG contra low')

%range 3
figure('Position', [544 157 1120 840])
t = tiledlayout(2,2);
nexttile
CVMean = mean(CoherenceValues_1_5_EEG_1_10_EMG_ipsi_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('1-5 EEG 1-10 EMG ipsi high')
nexttile
CVMean = mean(CoherenceValues_1_5_EEG_1_10_EMG_contra_high,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('1-5 EEG 1-10 EMG contra high')
nexttile
CVMean = mean(CoherenceValues_1_5_EEG_1_10_EMG_ipsi_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('1-5 EEG 1-10 EMG ipsi low')
nexttile
CVMean = mean(CoherenceValues_1_5_EEG_1_10_EMG_contra_low,1);
plot(delayvalues_ms, CVMean);
xlabel ('delay (ms)')
ylabel ('Coherence Values')
title('1-5 EEG 1-10 EMG contra low')
%}

