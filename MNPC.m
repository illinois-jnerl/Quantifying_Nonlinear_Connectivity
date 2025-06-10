%%--------------------------------------
% This code is developed based on Yuan Yang's unpublished method on m:n
% phase synchronization. Please keep it in confidential
%%---------------------------------------

% This function help to check harmonics and subharmonics nonlinearity
% from perturbation to EEG
% Input:
% PT(Samples,Trials) is the FFT of perturbation signal
% input_freq is movement frequency
% EEG_m is the FFT of one channel EEG signal
% max_freq is the max frequency you want to scan. [1, max_freq] with
% frequency resolution 1 Hz.
% Output: NPCC - nonlinear perturbation-cortical coherence
% NPCC is the coherence value, NPCC_p is coherency

function [NMPC_v, NMPC_p]= MNPC (X,Y,min_freq,max_freq)
X = X./abs(X); % remove the amplitude
Y = Y./abs(Y); % remove the amplitude
a = min_freq:max_freq;
M = length(a);
NMPC_v = zeros(M,M);
NMPC_p = zeros(M,M);

for i = min_freq:max_freq
    for j = min_freq:max_freq
    cm = lcm(i,j);
    n=cm/i;
    m=cm/j;
    Temp_X = X(i+1,:);
    Temp_Y = Y(j+1,:);
    CSD_i = (Temp_X.^n).*conj(Temp_Y.^m);
   % CSD_i_normalized = CSD_i./abs(CSD_i);
    NMPC_p(i,j) = mean (CSD_i);
    NMPC_v(i,j)=abs(NMPC_p(i,j));
    end
end


