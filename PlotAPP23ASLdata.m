%% This script plots the registered ASL data (maps, boxplots and time-profiles) of the APP23 study
% These plots are published in Kozberg, Munting et al., Brain Communications 2025
% Contact Leon Munting: l.p.munting@lumc.nl for any questions.
% Before running this script, make sure you have the data and ROIs (see
% line 12-17) and that you have the following scripts in your matlab path:
% 1. "SmoothSlideWindow" - can be found together with script on github
% 2. "shadedErrorBar" -  https://github.com/raacampbell/shadedErrorBar

clear
close all

% Here you need to provide the links to where the data and ROIs are stored on your
% computer; 
dataPath = 'R:\- Gorter\- Personal folders\Munting, L\MGH\APP23_paper\MRI\';
dataFile = 'CBF_maps_allMice.mat';
roiFile = 'SensoryCxROI.mat';
brainMaskFile = 'BrainMask.mat';

plotIndividualMaps = 0; % if you want maps of individual mice, insert 1 
saveMaps = 0; % if you want to save the CBF maps, insert 1


%% Loading the data 
% All data is stored in "CBF_maps_allMice" matrix, with the following details:
% Dimensions: 
% dim1 = X, dim2 = Y, dim3 = slice, dim4 =
% dynamics, dim5 = mice, dim6 = group, where (1=12moWT; 2=18moWT; 3=24moWT;
% 4=12moTG; 5=18moTG; 6=24moTG;)
% Sex:
% wt_12mo_sex = [0,0,1,1,1]; % 0 = male; 1 = female
% tg_12mo_sex = [1,1,1,1,0]; % 0 = male; 1 = female
% wt_18mo_sex = [0,0,1,0,1,0,1,1]; % 0 = male; 1 = female
% tg_18mo_sex = [0,1,1,1,0,0,1]; % 0 = male; 1 = female
% wt_24mo_sex = [0,1,0,0,0,0,0,1,1]; % 0 = male; 1 = female
% tg_24mo_sex = [1,1,1,0,0,1]; % 0 = male; 1 = female

cd(dataPath)
load(dataFile)
fprintf('data loaded\n');

% load the brain mask
load(brainMaskFile)
brainMask = [];
for i = 1:numel(uvascroi)
    brainMask(:,:,i) = uvascroi(i).value;
end

% set the boundaries of the CBF maps
xmin = 24;
xmax = 106;
ymin = 38;
ymax = 150;

% Filter out non-physiological CBF values
CBF_maps_allMice(CBF_maps_allMice < 0) = NaN; 
CBF_maps_allMice(CBF_maps_allMice > 800) = NaN; 

% CBF baseline
CBF_maps_allMice_baseline = squeeze(nanmean(CBF_maps_allMice(:,:,:,9:43,:,:),4));
CBF_maps_mouseAveraged_baseline = squeeze(nanmean(CBF_maps_allMice_baseline,4));

CBF_maps_mouseAveraged_masked_baseline = CBF_maps_mouseAveraged_baseline .* brainMask;

CBF_WT_APP23_diff = CBF_maps_mouseAveraged_masked_baseline(:,:,:,1:3) - CBF_maps_mouseAveraged_masked_baseline(:,:,:,4:6);


%% Plotting the maps 

colors = 'magma'; %'jet'

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i,1),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i-5,4),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,1),[-50 100])
    colormap(gca,colors)
end
title = '12 months WT vs APP23 CBF baseline';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i,2),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i-5,5),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,2),[-50 100])
    colormap(gca,colors)
end
title = '18 months WT vs APP23 CBF baseline';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i,3),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_masked_baseline(xmin:xmax,ymin:ymax,i-5,6),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,3),[-50 100])
    colormap(gca,colors)
end
title = '24 months WT vs APP23 CBF baseline';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

% CBF during CO2
CBF_maps_allMice_CO2 = squeeze(nanmean(CBF_maps_allMice(:,:,:,51:86,:,:),4));
CBF_maps_mouseAveraged_CO2 = squeeze(nanmean(CBF_maps_allMice_CO2,4));
CBF_maps_mouseAveraged_CO2_masked = CBF_maps_mouseAveraged_CO2 .* brainMask;

CBF_WT_APP23_diff_CO2 = CBF_maps_mouseAveraged_CO2_masked(:,:,:,1:3) - CBF_maps_mouseAveraged_CO2_masked(:,:,:,4:6);

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i,1),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i-5,4),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff_CO2(xmin:xmax,ymin:ymax,i-10,1),[-50 100])
    colormap(gca,colors)
end
title = '12 months WT vs APP23 CBF during CO2';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i,2),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i-5,5),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff_CO2(xmin:xmax,ymin:ymax,i-10,2),[-50 100])
    colormap(gca,colors)
end
title = '18 months WT vs APP23 CBF during CO2';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i,3),[0 250])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CBF_maps_mouseAveraged_CO2_masked(xmin:xmax,ymin:ymax,i-5,6),[0 250])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CBF_WT_APP23_diff_CO2(xmin:xmax,ymin:ymax,i-10,3),[-50 100])
    colormap(gca,colors)
end
title = '24 months WT vs APP23 CBF during CO2';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

% CVR
CVR_maps_allMice = ((CBF_maps_allMice_CO2 - CBF_maps_allMice_baseline) ./ CBF_maps_allMice_baseline) .* 100;
CVR_maps_mouseAveraged = squeeze(nanmean(CVR_maps_allMice,4));
CVR_maps_mouseAveraged_masked = CVR_maps_mouseAveraged .* brainMask;

CVR_WT_APP23_diff = CVR_maps_mouseAveraged_masked(:,:,:,1:3) - CVR_maps_mouseAveraged_masked(:,:,:,4:6);


figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i,1),[0 60])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i-5,4),[0 60])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CVR_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,1),[0 60])
    colormap(gca,colors)
end
title = '12 months WT vs APP23 CVR';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i,2),[0 60])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i-5,5),[0 60])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CVR_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,2),[0 60])
    colormap(gca,colors)
end
title = '18 months WT vs APP23 CVR';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end

figure,
for i = 1:5
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i,3),[0 60])
    colormap(gca,colors)
end
hold on
for i = 6:10
    subplot(3,5,i)
    imshow(CVR_maps_mouseAveraged_masked(xmin:xmax,ymin:ymax,i-5,6),[0 60])
    colormap(gca,colors)
end
for i = 11:15
    subplot(3,5,i)
    imshow(CVR_WT_APP23_diff(xmin:xmax,ymin:ymax,i-10,3),[0 60])
    colormap(gca,colors)
end
title = '24 months WT vs APP23 CVR';
subtitle(title)
if saveMaps == 1
    saveas(gcf,strcat(title,'.svg'))
    saveas(gcf,strcat(title,'.fig'))
end


%%

if plotIndividualMaps == 1
    
    for sliceOfInterest = 3 
        
        for group = 1:6
            
            figure,
            for mouse = 1:9
                subplot(2,5,mouse)
                imshow(CVR_maps_allMice(xmin:xmax,ymin:ymax,sliceOfInterest,mouse,group),[0 50])
                hold on
            end
        end
    end
end

%% Here the time-profiles in the region of interest will be plotted

% Load the ROI
load(roiFile);

brainROI = nan(size(CBF_maps_allMice,1),size(CBF_maps_allMice,2),size(CBF_maps_allMice,3));
for i = 1:size(CBF_maps_allMice,3)
    for j = 1:numel(uvascroi)
        if uvascroi(j).displayedslice == i
            brainROI(:,:,i) = uvascroi(j).value;
        end
    end
end

% Plot the time-profiles
time = (1:130) * 7 /60; % time in minutes

CBFinROI = CBF_maps_allMice .* brainROI;
clear CBF_maps_allMice % in case you run low on memory
CBFinROI(CBFinROI == 0) = NaN;
CBFinROI = squeeze(nanmean(squeeze(reshape(CBFinROI,...
    [size(CBFinROI,1) * size(CBFinROI,2) * size(CBFinROI,3),1,1,size(CBFinROI,4),size(CBFinROI,5),size(CBFinROI,6)])),1));

CBFinROI_filt = CBFinROI; % dim1 = dynamics, dim2 = mice, dim3 = age groups
for i = 1:size(CBFinROI,2)
    for j = 1:size(CBFinROI,3)
        dataTemp = CBFinROI(:,i,j);
        dataTemp(dataTemp>(nanmean(CBFinROI(:,i,j))+(2*nanstd(CBFinROI(:,i,j))))) = NaN;
        dataTemp(dataTemp<(nanmean(CBFinROI(:,i,j))-(2*nanstd(CBFinROI(:,i,j))))) = NaN;
        CBFinROI_filt(:,i,j) = dataTemp;
    end
end
CBFinROI = CBFinROI_filt;

meanCBFinROI = squeeze(nanmean(CBFinROI,2));
stdCBFinROI  = squeeze(nanstd(CBFinROI,2));

figure,
for i = 1:3
    subplot(1,3,i)
    shadedErrorBar(time,SmoothSlideWindow(meanCBFinROI(:,i)),SmoothSlideWindow(stdCBFinROI(:,i)),...
        'lineprops',{'color',[.30, .58, .80],'markerfacecolor',[.30, .58, .80],'linewidth',2},'transparent',1)
    hold on
    shadedErrorBar(time,SmoothSlideWindow(meanCBFinROI(:,i+3)),SmoothSlideWindow(stdCBFinROI(:,i+3)),...
        'lineprops',{'color',[.80, .30, .22],'markerfacecolor',[.80, .30, .22],'linewidth',2},'transparent',1)
    set(gca,...
        'FontWeight','bold',...
        'FontSize',18,...
        'FontName','Arial',...
        'LineWidth',2);
    xlabel('Time (min)');
    ylabel('CBF (mL/100 g/min)')
    xlim([0 15])
    y_min_max = [50 200];
    ylim(y_min_max)
%     y_min_max = ylim;
    h=fill([5 10 10 5],[y_min_max(1) y_min_max(1) y_min_max(2) y_min_max(2)],'k','EdgeColor','none'); h.FaceAlpha=0.2;
end


CBFinROInormalized = (CBFinROI ./ nanmean(CBFinROI(9:43,:,:))) .* 100 - 100;
meanCBFinROInormalized = squeeze(nanmean(CBFinROInormalized,2));
stdCBFinROInormalized  = squeeze(nanstd(CBFinROInormalized,2));


figure,
for i = 1:3
    subplot(1,3,i)
    shadedErrorBar(time,SmoothSlideWindow(meanCBFinROInormalized(:,i)),SmoothSlideWindow(stdCBFinROInormalized(:,i)),...
        'lineprops',{'color',[.30, .58, .80],'markerfacecolor',[.30, .58, .80],'linewidth',2},'transparent',1)
    hold on
    shadedErrorBar(time,SmoothSlideWindow(meanCBFinROInormalized(:,i+3)),SmoothSlideWindow(stdCBFinROInormalized(:,i+3)),...
        'lineprops',{'color',[.80, .30, .22],'markerfacecolor',[.80, .30, .22],'linewidth',2},'transparent',1)
    set(gca,...
        'FontWeight','bold',...
        'FontSize',18,...
        'FontName','Arial',...
        'LineWidth',2);
    xlabel('Time (min)');
    ylabel('CVR (%)')
    xlim([0 15])
    y_min_max = [-20 80];
    ylim(y_min_max)
%     y_min_max = ylim;
    h=fill([5 10 10 5],[y_min_max(1) y_min_max(1) y_min_max(2) y_min_max(2)],'k','EdgeColor','none'); h.FaceAlpha=0.2;
end


% Plot the boxplots

CBF_baseline = nan(9,6);
CVR = nan(9,6);

for i = 1:6
    CBF_baseline(:,i) = squeeze(nanmean(CBFinROI(9:43,:,i),1));
    CVR(:,i) = squeeze((nanmean(CBFinROI(51:86,:,i),1) - nanmean(CBFinROI(9:43,:,i),1)) ./ nanmean(CBFinROI(9:43,:,i),1) .* 100);
end

boxPosition = [1 2 4 5 7 8]; 
 
CBF_baseline_reorder = cat(2,CBF_baseline(:,1),CBF_baseline(:,4),CBF_baseline(:,2),CBF_baseline(:,5),CBF_baseline(:,3),CBF_baseline(:,6));
CVR_reorder = cat(2,CVR(:,1),CVR(:,4),CVR(:,2),CVR(:,5),CVR(:,3),CVR(:,6));

sex = cat(2,[0;0;1;1;1;NaN;NaN;NaN;NaN],... 
            [1;1;1;1;0;NaN;NaN;NaN;NaN],... 
            [0;0;1;0;1;0;1;1;NaN],... 
            [0;1;1;1;0;0;1;NaN;NaN],... 
            [0;1;0;0;0;0;0;1;1],...
            [1;1;1;0;0;1;NaN;NaN;NaN]); % 0 = male; 1 = female

CBF_baseline_reorder_males = CBF_baseline_reorder .* (1 - sex);
CBF_baseline_reorder_males(CBF_baseline_reorder_males == 0) = NaN;
CBF_baseline_reorder_females = CBF_baseline_reorder .* sex;
CBF_baseline_reorder_females(CBF_baseline_reorder_females == 0) = NaN;
        
CVR_reorder_males = CVR_reorder .* (1 - sex);
CVR_reorder_males(CVR_reorder_males == 0) = NaN;
CVR_reorder_females = CVR_reorder .* sex;
CVR_reorder_females(CVR_reorder_females == 0) = NaN;


figure,
h = boxplot(CBF_baseline_reorder,'positions',boxPosition,'widths',0.75,'Colors','k','Symbol','');
set(h, 'linewidth' ,2)
set(gca,...
    'FontWeight','bold',...
    'FontSize',14,...
    'FontName','Arial',...
    'LineWidth',2,...
    'Box','off');
ylabel('CBF (mL/100 g/min)')
set(gca,'XTickLabel',{'WT' 'Tg' 'WT' 'Tg' 'WT' 'Tg'})
hold on
spread = 0.5; % 0=no spread; 0.75=random spread within box bounds
temp = 0;
for i = boxPosition
    temp = temp + 1;
    if rem(temp,2) == 1     % plotting the wild types 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CBF_baseline_reorder_males(:,temp)),...
            'ok','MarkerFaceColor',[.30, .58, .80],'linewidth', 0.5)
        hold on 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CBF_baseline_reorder_females(:,temp)),...
            '^k','MarkerFaceColor',[.30, .58, .80],'linewidth', 0.5)
    else                    % plotting the transgenics 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CBF_baseline_reorder_males(:,temp)),...
            'ok','MarkerFaceColor',[.80, .30, .22],'linewidth', 0.5)
        hold on
                plot(rand(9,1)*spread -(spread/2) + i, squeeze(CBF_baseline_reorder_females(:,temp)),...
            '^k','MarkerFaceColor',[.80, .30, .22],'linewidth', 0.5)
    end
end


figure,
h = boxplot(CVR_reorder,'positions',boxPosition,'widths',0.75,'Colors','k','Symbol','');
set(h, 'linewidth' ,2)
set(gca,...
    'FontWeight','bold',...
    'FontSize',14,...
    'FontName','Arial',...
    'LineWidth',2,...
    'Box','off');
ylabel('CVR (%)')
set(gca,'XTickLabel',{'WT' 'Tg' 'WT' 'Tg' 'WT' 'Tg'})
hold on
spread = 0.5; % 0=no spread; 0.75=random spread within box bounds
temp = 0;
for i = boxPosition
    temp = temp + 1;
    if rem(temp,2) == 1     % plotting the wild types 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CVR_reorder_males(:,temp)),...
            'ok','MarkerFaceColor',[.30, .58, .80],'linewidth', 0.5)
        hold on 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CVR_reorder_females(:,temp)),...
            '^k','MarkerFaceColor',[.30, .58, .80],'linewidth', 1)
    else                    % plotting the transgenics 
        plot(rand(9,1)*spread -(spread/2) + i, squeeze(CVR_reorder_males(:,temp)),...
            'ok','MarkerFaceColor',[.80, .30, .22],'linewidth', 1)
        hold on
                plot(rand(9,1)*spread -(spread/2) + i, squeeze(CVR_reorder_females(:,temp)),...
            '^k','MarkerFaceColor',[.80, .30, .22],'linewidth', 1)
    end
end

