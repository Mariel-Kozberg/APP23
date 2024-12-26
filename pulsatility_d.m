%% pulsatility analysis 
% Mariel Kozberg
% inputs from linescan_d
% will output: 
% HR - heart rate 
% ave_diam  - average diameter of each vessel
% int_filt_diam - absolute value of area under curve of each vessel (units of microns * number of ms)
% PSD - power spectral density max 
% PSDind - frequency at PSD max 
% as well as figures demonstrated analysis performed for each vessel for a visual check  

close all; clear all; 

% load diameter data 

mouse = ''; % mouse number 
sessions = 1; % number of imaging sessions 
numvessels = 1; % number of vessels imaged each session 
t = 2.5; % number of seconds 
pixel_size = 0.3310; % change if using different pixel size 

for session =  1:sessions 
% close all;  
loaddir = ['']; %loading directory  

cd(loaddir); 

for vessel = [1:numvessels] 
close all; 
    cd(loaddir); 
     name = ['LSD' num2str(vessel) '.mat']; 
    if exist(name) == 2 
load(['LSD' num2str(vessel)]);

diam_p = ind2-ind1; 

% convert pixels to microns / time to ms 
diam_m = diam_p*pixel_size; 
fr = size(ind1,2)/t; 
time = linspace(1/fr,t,size(ind1,2)); % time vector 

% smooth data set 

diam_ms = smooth(diam_m); 
figure; plot(time,diam_ms);

%%  calculate heart rate 

% convert to frequency domain 
Fs = size(ind1,2)/t; 
L = size(ind1,2); 
diam_f = fft(diam_ms);
P2 = abs(diam_f/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
f2 = Fs*(0:L)/L; 
psdx = (1/(Fs*L)) * abs(diam_f).^2;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
figure; 
plot(f2(2:end),psdx)
xlabel('f (Hz)')
ylabel('|P1(f)|')
axis([0 250 0 0.15])

% find HR peak 

[fmax,HRind] = max(P1(10:end));
HR = f(10+HRind)*60;% bpm 
[PSD, PSDind]= max(psdx(10:150)); 

% select data from HR freq
Pselect = P1; 
Pselect(1:10) = 0; % high-pass filter 
Pselect(HRind+5+40:end) = 0; % low-pass filter 

l = figure;
plot(f,P1,'m','lineWidth',2); hold on;
% plot(f,Pselect,'g')
title('Single-Sided Amplitude Spectrum')
xlabel('frequency (Hz)')
ylabel('|P1(f)|')
ax = gca;
ax.Color = 'k'; 
ax.XAxis.FontSize = 15; 
ax.XAxis.Color = 'k'; 
ax.YAxis.FontSize = 15; 
ax.YAxis.Color = 'k'; 
axis([0 100 0 0.15])


%% take abs value of integral of diameter (um) vs time (ms) plot 

ave_diam = mean(diam_ms(1000:end-1000)); 

filtave_diam = movmean(diam_ms,50);
movave_diam = smooth(movmean(diam_ms,1500),'sgolay',3); 
filt_diam_zero = filtave_diam - movave_diam; % this will "de-trend" the data 

h = figure; 
subplot(1,2,1); 
plot(time,diam_ms,'g'); hold on; 
plot(time,filtave_diam); 
plot(time,movave_diam,'k'); 
xlabel('time (sec)'); 
ylabel('vessel diameter (microns)'); 
title('filtering check') 
subplot(1,2,2);

plot(time,filt_diam_zero,'g'); hold on; 
plot([0 2.5],[0 0],'w'); 
ax = gca;
ax.Color = 'k'; 
ax.XAxis.FontSize = 15; 
ax.XAxis.Color = 'k'; 
ax.YAxis.FontSize = 15; 
ax.YAxis.Color = 'k'; 
xlabel('time (sec)'); 
ylabel('Change in vessel diameter (microns)'); 

pos_area = sum(filt_diam_zero(filt_diam_zero>0)); % microns*2.5s 
neg_area = sum(filt_diam_zero(filt_diam_zero<0)); 

 
int_filt_diam = (pos_area + abs(neg_area))*1000*t/size(ind1,2); % microns*ms

ave_diam = mean(diam_ms); 
 save 
%cd(savedir); 
%saveas(h,['LSD' num2str(vessel) '_pulsatility'],'jpg');
%saveas(l,['LSD' num2str(vessel) '_HR'],'jpg');
%save(['LSD' num2str(vessel) '_pulsatility'],'HR','ave_diam','int_filt_diam','PSD','PSDind'); 
    else 
    end 
end 
end 

