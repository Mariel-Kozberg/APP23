%% calculate vessel diameter 

% load 

close all; clear variables; 
mouse = 'APP23_4'; 
session = 2; 
loaddir = ['/Volumes/mgkdata/APP23/' mouse '_' num2str(session) '/'];
homedir = '/users/marielkozberg/Documents/code/';
cd(['/Volumes/mgkdata/APP23/analysis/' mouse '/' mouse '_' num2str(session)]) 
mkdir(['/Volumes/mgkdata/APP23/analysis/' mouse '/' mouse '_' num2str(session) '_diametersubtr']);
savedir = ['/Volumes/mgkdata/APP23/analysis/' mouse '/' mouse '_' num2str(session) '_diametersubtr'];


% Tg = 1; % 1 Tg, 2 WT 

for v = 18:23
vessel = v; 
filename = ['LSD' num2str(vessel) '.oif.files']; %   
if exist([loaddir filename])
cd([loaddir filename]);

lines = 10000; 
t =  2.5; % seconds
fr = lines/t; 
time = linspace(1/fr,2.5,lines); 

linescan_1 = imread(['s_C001.tif']); % color 1 - methoxy 
linescan_2 = imread(['s_C002.tif']); % color 2 - FITC 


linescan_2c = linescan_2- linescan_1; 
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


% calculate valleys for Tg
%if Tg == 1
  %  caa = input('Is there CAA around vessel? Reply 1 = yes, 2 = no   '); 
   % if caa == 1 
    
% linescanmean = mean(linescan_2z,1); 
% d2 = diff(diff(linescanmean)); 
% [~, indval1] = max(d2(1,1:round(end/2)));
% [~, indval2t] = max(d2(1,round(end/2):end));
% indval2 = indval2t +  round(size(d2,2)/2); 
% corr1 = indval1 - mean(ind1); 
% corr2 = mean(ind2) - indval2; 
%savedir = ['/Volumes/mgkdata/APP23/analysis/S191F3/' mouse];
%cd(savedir); 
%savefile = ['LSD' num2str(vessel) '_corr'];
%save(savefile,'corr1','corr2');
 %   end 
%else 
% end 
%close(LS2)
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