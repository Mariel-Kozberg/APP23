%% calculate vessel diameter from linescan data 
% Mariel Kozberg 
% inputs: raw 2-photon linescan data collected perpendicular to the vessel in order to measure vessel diameter 
% outputs: indices of edges of blood vessel over timecourse (ind1 = left, ind2 = right) 

% load data sets 
close all; clear variables; 
mouse = ''; % input mouse # 
session = 1; % select imaging session 
loaddir = ['']; % select loading directory 
homedir = ''; % select home directory 
cd(loaddir)) 
savedir = ['']; % save directory 

for v = 1:5; % select which vessels to analyze 
vessel = v; 
filename = ['LSD' num2str(vessel) '.oif.files']; %   
if exist([loaddir filename])
cd([loaddir filename]);

lines = 10000; 
t =  2.5; % seconds
fr = lines/t; 
time = linspace(1/fr,2.5,lines); 

linescan_1 = imread(['s_C001.tif']); % color 1 - methoxy (amyloid-beta channel) 
linescan_2 = imread(['s_C002.tif']); % color 2 - FITC (vessel channel) 

linescan_2c = linescan_2- linescan_1; % subtract methoxy from FITC channel 

LS2 = figure; 
subplot(1,3,1); 
imagesc(linescan_2);
subplot(1,3,2); 
imagesc(linescan_1); 
subplot(1,3,3); 
imagesc(linescan_2c);  colormap gray; 

% threshold 
linescan_2z = ones(size(linescan_2c)); 
for i = 1:size(linescan_2c,1) 
linescan_2z(i,:) = (linescan_2c(i,:)-mean(linescan_2c(i,1:10),2))./mean(linescan_2c(i,1:10),2); 
end 

max1 = max(linescan_2z'); 
setthresh = 0.2;

linescan_2t = ones(size(linescan_2));
for i = 1:size(linescan_2,1)
    for j = 1:size(linescan_2z,2)
    if linescan_2z(i,j) <= setthresh*max1(1,i)
       linescan_2t(i,j) = 0;
    else 
        linescan_2t(i,j) = 1; 
    end 
    end 
end 

for i = 1:size(linescan_2t,1)
[~,ind1(i)] = find(linescan_2t(i,:)==1,1,'first'); 
[~,ind2(i)] = find(linescan_2t(i,:)==1,1,'last'); 
end 

cd(savedir); 

indplot = figure; plot(ind1.*.3310,'b'); hold on; plot(ind2.*.3310,'b');
saveas(indplot,['LSD' num2str(vessel) '_indplot.jpg']);
saveas(LS2,['LSD' num2str(vessel) '.jpg']);
close(indplot)

comparethresh = figure; 
subplot(2,1,1); 
imagesc(linescan_2);  colormap gray; 
subplot(2,1,2); 
imagesc(linescan_2t); 
saveas(comparethresh,['LSD' num2str(vessel) '_comparethresh.jpg']);
close(comparethresh)


cd(savedir); 
savefile = ['LSD' num2str(vessel)];
save(savefile,'linescan_2t','ind1','ind2'); 
else 
    display(['no file ' num2str(v)]); 
end 
end
