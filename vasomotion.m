%% load files 

close all; clear variables; 
% load mouse data set  
mouse = ''; % enter mouse name 
session = 1; % enter session number 
loaddir = ''; % enter loading directory 
homedir = ''; % enter home directory 
savedir = ['']; % enter save directory 
filename = ''; % enter filename  
cd([loaddir filename]);

frames = 700; % # of frames 
time = 300.535 ; % # of seconds

frameRate = frames/time; 
pixels = 256; 

data = ones(pixels,pixels,frames); 
for i = 1:frames
    data1(:,:,i) = imread(['s_C001T' sprintf('%03d',i) '.tif']); % color 1
    data2(:,:,i) = imread(['s_C002T' sprintf('%03d',i) '.tif']); % color 2 
end 

cd(homedir); 

%% view movie of data 

figure; 
for i = 1:frames
    imagesc(data2(:,:,i)); axis image; colormap gray; 
    pause(0.01); 
end

%% ROI selection 
g = 4; % number of ROIs
[coor,figs] = ROIselect(data2,g); 
cd(savedir);
saveas(figs,[filename '_regions.jpg']);
cd(homedir); 

%% rotate the vessels - make vertical + calculate FWHM + pixels 

cd(homedir); 
for f = 1:g
vessel = data2([round(coor(2,f)):round(coor(2,f)+coor(4,f))],[round(coor(1,f)):round(coor(1,f)+coor(3,f))],:);
figure; imagesc(vessel(:,:,1)); axis image; 
title('select edges'); 
rorl = input('Is vessel tilted L or R? Reply 1 = L, 2 = R   '); 
h = imrect; 
pos = getPosition(h); 
ang = radtodeg(atan(pos(4)/pos(3))); 
 
clear J; 
if rorl == 2
for i = 1:size(vessel,3)
J(:,:,i) = imrotate(vessel(:,:,i),(ang)); % rotates counterclockwise
end 
else 
for i = 1:size(vessel,3)
J(:,:,i) = imrotate(vessel(:,:,i),(-ang)); % rotates counterclockwise
end 
end 
rotation = figure; 
subplot(1,2,1)
imagesc(vessel(:,:,1)); axis image; 
subplot(1,2,2)
imagesc(J(:,:,1)); axis image;

% reselect coordinates
coor_rot = ROIselect(J(:,:,1),1); 

% calculate FWHM 
% FWHM_all(:,1) = FWHM(J,coor_rot,1); 
data_in = J; 
coord = coor_rot;
region = squeeze(mean(data_in([round(coord(2)):round(coord(2)+coord(4))],[round(coord(1)):round(coord(1)+coord(3))],:),1)); 
figure; plot(region); 
region_s = ones(size(region)); 
for i = 1:size(region,2) 
region_s(:,i) = smooth(region(:,i));
end 
for t = 1:size(region,2)
[Y,~] = max(region_s(1:round(coord(3)/2),t)); 
[Y2,~] = max(region_s(round(coord(3)/2):end,t)); 
[~, ix1] = min(abs(region_s(1:round(coord(3)/2),t)-Y/2));
[~, ix2] = min(abs(region_s(round(coord(3)/2):end,t)-Y2/2));
FWHM(t) = ix2 + round(coord(3)/2) - ix1; 
end 

% calculate in pixels 
region = double(data_in([round(coord(2)):round(coord(2)+coord(4))],[round(coord(1)):round(coord(1)+coord(3))],:)); 
region_thresh = ones(size(region)); 
maxregion = double(max(max(region(:,:,1)))); 
region_01 = double(region./maxregion); 
for j = 1:size(region_01,3) 
region_thresh(:,:,j) = im2bw(region_01(:,:,j),0.25);
profile = squeeze(sum(squeeze(mean(region_thresh,1)),1));
end 
pixel_av(f,:) = profile; 
FWHM_av(f,:) = FWHM; 
end 

h = figure; 
subplot(1,2,1); 
plot(1:700, FWHM_av); legend('1','2','3','4','5','6'); title('FWHM') 
subplot(1,2,2)
plot(1:700, pixel_av); legend('1','2','3','4','5','6'); title('pixels')
cd(savedir); 
saveas(h,[filename '_summplot.jpg']);
save(filename,'FWHM_av','pixel_av'); 

%% fourier analysis 

% convert to frequency domain

Fs = 700/300.525; % sampling rate
T = 300.525; % time in seconds  
L = 700; 
P1_all = ones(size(pixel_av,1),L/2+1); 
for i = 1:size(pixel_av,1) 
pixel_f = fft(pixel_av(i,:));
P2 = abs(pixel_f/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
P1_all(i,:) = P1; 
end 
axis([0 0.5 0 0.5])


figure; 
for i = 1:
plot(f,P1_all);
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
axis([0 0.5 0 0.5])