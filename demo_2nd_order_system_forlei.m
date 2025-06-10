%% Preparation
%ms=reshape(distSig3,2048,600);
load 'multisine_7_13_29'
Trials = 600;
ms = repmat(distSig3_1p,Trials,1);
ms(end+1)= ms(1);
ms = diff(ms);
ms = ms - mean(ms);
ms=reshape(ms,2048,Trials);

ms=ms*50;
tv = (0:1/2048:1-1/2048)*1000;
fe = [8 14 30];
N=2048;
MS = fft(ms,N);
f = [0:1/N:1-1/N]*N;
figure
subplot(211)
plot(tv, mean(ms,2));
xlabel('Time(s)','Fontsize',12)
ylabel('x(t)','Fontsize',12)
%f = [0:1/(N):1-1/(N)]*N;
subplot(212)
stem (f, mean(abs(MS),2));
xlabel('Frequency (Hz)','Fontsize',12)
ylabel('|X(f)|','Fontsize',12)
xlim([1 100])

%% add background noise to the input
ms_noise =awgn(ms,-20,'measured','db');
MS_noise = fft(ms_noise,N);

%MS_noise(fe,:)=MS(fe,:);
ms_noise = ifft(MS_noise./N,N);
figure
subplot(211)
%stem (f, mean(abs(D2_delay_noise),2));
plot(tv, mean(ms_noise,2));
xlabel('Time(s)','Fontsize',12)
ylabel('y(t)','Fontsize',12)
%xlim([1 100])
%f = [0:1/(N):1-1/(N)]*N;
subplot(212)
stem (f, mean(abs(MS_noise),2),'b-');
hold on
stem (f, mean(abs(MS),2),'r-');
xlabel('Frequency (Hz)','Fontsize',12)
ylabel('|Y(f)|','Fontsize',12)
xlim([1 100])

%% 2 order+time delay
tau = 67;
ms_delay = circshift(ms,tau);
d2_delay = ms_delay.^2;
%d2_delay = ms_noise.^2;
D2_delay = fft(d2_delay,N);
f2=[6 14 16 20 22 26 36 42 58];
%D2_delay(f2+1,:) = D2_delay(f2+1,:)./abs(D2_delay(f2+1,:));
d2_delay = ifft(D2_delay,N);

figure
subplot(211)
plot(tv, mean(d2_delay,2));
xlabel('Time(s)','Fontsize',12)
ylabel('y(t)','Fontsize',12)
%f = [0:1/(N):1-1/(N)]*N;
subplot(212)
stem (f, mean(abs(D2_delay),2));
xlabel('Frequency (Hz)','Fontsize',12)
ylabel('|Y(f)|','Fontsize',12)
xlim([1 100])

%% add background noise to the output
d2_delay_noise =awgn(d2_delay,-10,'measured','db');
D2_delay_noise = fft(d2_delay_noise,N);

%D2_delay_noise(f2+1,:)=D2_delay(f2+1,:);
d2_delay_noise = ifft(D2_delay_noise./N,N);
figure
subplot(211)
%stem (f, mean(abs(D2_delay_noise),2));
plot(tv, mean(d2_delay_noise,2));
xlabel('Time(s)','Fontsize',12)
ylabel('y(t)','Fontsize',12)
%xlim([1 100])
%f = [0:1/(N):1-1/(N)]*N;
subplot(212)
stem (f, mean(abs(D2_delay_noise),2),'b-');
hold on
stem (f, mean(abs(D2_delay),2),'r-');
xlabel('Frequency (Hz)','Fontsize',12)
ylabel('|Y(f)|','Fontsize',12)
xlim([1 100])


%% n:m phase coupling

[NMPC_1, NMPC_p_1]= MNPC_p_EEG (MS_noise,D2_delay_noise,7,90);
[NMPC_2, NMPC_p_2]= MNPC_p_EEG (MS_noise,D2_delay_noise,13,90);
[NMPC_3, NMPC_p_3]= MNPC_p_EEG (MS_noise,D2_delay_noise,29,90);

figure
subplot(221)
l(1)=plot(f(2:91),NMPC_1,'b*','MarkerSize',8);
hold on
plot(f(1:91),1.4*sqrt(3/Trials)*ones(91,1),'k-');
xlim([0 90]);
ylim([0 1.1]);
xlabel('Frequency (Hz)','Fontsize',14);
ylabel('nmpc_{XY}(7Hz)','Fontsize',14);

subplot(222)
l(1)=plot(f(2:91),NMPC_2,'b*','MarkerSize',8);
hold on
plot(f(1:91),1.4*sqrt(3/Trials)*ones(91,1),'k-');
xlim([0 90]);
ylim([0 1.1]);
xlabel('Frequency (Hz)','Fontsize',14);
ylabel('nmpc_{XY}(13Hz)','Fontsize',14);

subplot(223)
l(1)=plot(f(2:91),NMPC_3,'b*','MarkerSize',8);
hold on
plot(f(1:91),1.4*sqrt(3/Trials)*ones(91,1),'k-');
xlim([0 90]);
ylim([0 1.1]);
xlabel('Frequency (Hz)','Fontsize',14);
ylabel('nmpc_{XY} (29Hz)','Fontsize',14);

%% phase bicoherence/MSPC second order
[C_2,C_p_2,Ang_2,TimeD_2,f_sigma_2]=MSPC_2(MS,D2_delay_noise,fe); 
figure
%subplot(224)
l(1)=plot(f_sigma_2-1,C_2,'b*','MarkerSize',8);
hold on
plot(f(1:101),sqrt(3/Trials)*ones(101,1),'k--')
hold on
%stem(fe-1, 1.5*ones(3,1),'r-');
xlim([0 90]);
ylim([0 1.1]);
xlabel('Frequency (Hz)','Fontsize',14);
ylabel('bPLV_{XY}','Fontsize',14);

%% NMC map
min_freq = 1;
max_freq = 100;
[NCMC_C, NCMC_C_p] = MNPC (MS_noise,D2_delay_noise,min_freq,max_freq);
%[NCMC_C, NCMC_C_p] = MNPC (MS_noise,D2_delay,min_freq,max_freq);

CL =  sqrt(1 - (0.05/10000)^(1/(Trials-1))); % Bonferroni correction

SC = NCMC_C>CL;
NCMC = NCMC_C.*SC;

figure
imagesc(NCMC);
xlabel ('Output');
ylabel ('Input');
set(gca, 'YDir', 'normal')
title('NMC')


