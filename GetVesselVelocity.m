function [velocity] = GetVesselVelocity(INPUT_PATH, channel, meas_name, vessel_type, pixel_size, num_points, total_time, minpeakdistance, fit_status)
% LSPIV with no parallel processing enabled (modified by Steven Hou)

close all

frame_time = total_time / num_points;

factor = pixel_size/frame_time;

% Parameters to improve fits
maxGaussWidth = 100;  % maximum width of peak during peak fitting

% Judge correctness of fit
numstd        = 3;  %num of stdard deviation from the mean before flagging
windowsize    = 1/frame_time; %in # scans, this will be converted to velocity points
%if one scan is 1/2600 s, then windowsize=2600 means
%a 1 second moving window.  Choose the window size
%according to experiment.
%

%%  settings
% Ask user for setting
% str = {'capillary', 'artery', 'user'};
% [speedSetting,v] = listdlg('PromptString','Select a configuration',...
%                 'SelectionMode','single',...
%                 'ListString',str);
% if v == 0; beep; disp('Cancelled'); break; end

if strcmp(vessel_type, 'A') == 1
    speedSetting = 2;
elseif strcmp(vessel_type, 'V') == 1
    speedSetting = 1;
end

if speedSetting == 1   % CAPILLARY SETTING
    numavgs       = 100;  %up to 100 (or more) for noisy or slow data
    %   numavgs = 500; % my edit
    skipamt       = 25;   %if it is 2, it skips every other point.  3 = skips 2/3rds of points, etc.
    shiftamt      = 5;
elseif speedSetting == 2   % ARTERY SETTING
    numavgs       = 100;  %up to 100 (or more) for noisy or slow data
    skipamt       = 25;   %if it is 2, it skips every other point.  3 = skips 2/3rds of points, etc.
    shiftamt      = 1;
elseif speedSetting == 3   % USER SETTING
    disp('settings are hard coded in the script, see script!');
    numavgs       = 100;  %up to 100 (or more) for noisy or slow data
    skipamt       = 25;   %if it is 2, it skips every other point.  3 = skips 2/3rds of points, etc.
    shiftamt      = 2;
end




%% Import the data from a multi-frame tif and make into a single array
%  The goal is a file format that is one single array,
%  so modify this section to accomodate your raw data format.
%
%  This particular file format assumes
imageLines = double(imread(sprintf('%s/%s/s_C00%d.tif', INPUT_PATH, meas_name, channel)));

%% choose where in the image to process

startColumn = 1;
endColumn = size(imageLines, 2);

%% minus out background signal (PWG 6/4/2009)
tic
disp('DC correction')
DCoffset = sum(imageLines,1) / size(imageLines,1);
imageLinesDC = imageLines - repmat(DCoffset,size(imageLines,1),1);

%% do LSPIV correlation
disp('LSPIV begin');

scene_fft  = fft(imageLinesDC(1:end-shiftamt,:),[],2);
test_img   = zeros(size(scene_fft));
test_img(:,startColumn:endColumn)   = imageLinesDC(shiftamt+1:end, startColumn:endColumn);
test_fft   = fft(test_img,[],2);
W      = 1./sqrt(abs(scene_fft)) ./ sqrt(abs(test_fft)); % phase only

LSPIVresultFFT      = scene_fft .* conj(test_fft) .* W;
LSPIVresult         = ifft(LSPIVresultFFT,[],2);
disp('LSPIV complete');

%% find shift amounts
disp('Find the peaks');
velocity = [];
maxpxlshift = round(size(imageLines,2)/2)-1;

index_vals = skipamt:skipamt:(size(LSPIVresult,1) - numavgs);
numpixels = size(LSPIVresult,2);
velocity  = nan(size(index_vals));
amps      = nan(size(index_vals));
sigmas    = nan(size(index_vals));
goodness  = nan(size(index_vals));

%% iterate through
close all
for index = 1:length(index_vals)
    
    if mod(index_vals(index),100) == 0
        fprintf('line: %d\n',index_vals(index))
    end
    
    LSPIVresultAVG   = fftshift(sum(LSPIVresult(index_vals(index):index_vals(index)+numavgs,:),1)) ...
        / max(sum(LSPIVresult(index_vals(index):index_vals(index)+numavgs,:),1));
    
    % find a good guess for the center
    c = zeros(1, numpixels);
    c(numpixels/2-maxpxlshift:numpixels/2+maxpxlshift) = ...
        LSPIVresultAVG(numpixels/2-maxpxlshift:numpixels/2+maxpxlshift);
    [maxval, maxindex] = max(c);
    
    % fit a guassian to the xcorrelation to get a subpixel shift
    options = fitoptions('gauss1');
    options.Lower      = [0    numpixels/2-maxpxlshift   0            0];
    options.Upper      = [1e9  numpixels/2+maxpxlshift  maxGaussWidth 1];
    options.StartPoint = [1 maxindex 10 .1];
    
    [q,good] = fit((1:length(LSPIVresultAVG))',LSPIVresultAVG','a1*exp(-((x-b1)/c1)^2) + d1',options);
    
    %save the data
    velocity(index)  = (q.b1 - size(LSPIVresult,2)/2 - 1)/shiftamt;
    amps(index)      = q.a1;
    sigmas(index)    = q.c1;
    goodness(index)  = good.rsquare;
    
    if fit_status == 1
        % plot the data out
        figure(1)
        subplot(1,2,1)
        hold off
        plot(LSPIVresultAVG);
        hold all
        plot(q);
        xlim([1 numpixels]);
        ylim([0 1]);
        
        
        subplot(1,2,2)
        plot(index_vals,velocity)
        title('displacement [pixels/scan]');
        ylabel('pixel shift');
        
        xlabel('scan number');
        pause(.01);
    end
end
%% find possible bad fits
toc

% Find bad velocity points using a moving window
pixel_windowsize = round(windowsize / skipamt);

badpixels = zeros(size(velocity));
for index = 1:1:length(velocity)-pixel_windowsize
    pmean = mean(velocity(index:index+pixel_windowsize-1)); %partial window mean
    pstd  = std(velocity(index:index+pixel_windowsize-1));  %partial std
    
    pbadpts = find((velocity(index:index+pixel_windowsize-1) > pmean + pstd*numstd) | ...
        (velocity(index:index+pixel_windowsize-1) < pmean - pstd*numstd));
    
    badpixels(index+pbadpts-1) = badpixels(index+pbadpts-1) + 1; %running sum of bad pts
end
badvals  = find(badpixels > 0); % turn pixels into indicies
goodvals = find(badpixels == 0);

meanvel  = mean(velocity(goodvals)); %overall mean
stdvel   = std(velocity(goodvals));  %overall std

if mean(velocity) < 0
    Data = -velocity;
else
    Data = velocity;
end

Data = factor * Data;

velocity = abs(Data);
%
%     mean_velocity_array(m) = mean(Data);
%
%     temp1 = mean(Data);
%     [Maxima,MaxIdx] = findpeaks(Data, 'MinPeakHeight', temp1, 'MinPeakDistance', minpeakdistance);
%
%     DataInv = 1.01*max(Data) - Data;
%     temp2 = mean(DataInv);
%     [Minima,MinIdx] = findpeaks(DataInv, 'MinPeakHeight', temp2, 'MinPeakDistance', minpeakdistance);
%     Minima = Data(MinIdx);
%
%     t = 0:total_time/(length(Data)-1):total_time;
%
%     figure(2), plot(t, Data, 'Linewidth', 1.5);
%     hold on;
%     plot(t(MaxIdx), Data(MaxIdx), 'bo');
%     plot(t(MinIdx), Data(MinIdx), 'ro');
%     xlabel('Time (s)');
%     ylabel('Velocity (mm/s)');
%     set(gca,'XTick', 0:total_time/5:total_time)
%     set(gca,'FontSize',18)
%
%     if fit_status == 1
%         idx = 1;
%         fit_a_indiv_array = [];
%         fit_b_indiv_array = [];
%
%         for f = 1:length(MaxIdx)
%             temp_idx = find(MinIdx > MaxIdx(f));
%             if length(temp_idx) > 0
%                 begin_idx = MaxIdx(f);
%                 end_idx = MinIdx(temp_idx(1));
%                 decay = Data(begin_idx:end_idx);
%                 t_decay = t(begin_idx:end_idx);
%
%                 fitType = 'exp1';
%                 myFit = fit(t_decay',decay',fitType);
%                 fit_a_indiv_array(idx) = myFit.a;
%                 fit_b_indiv_array(idx) = myFit.b;
%                 idx = idx + 1;
%
%                 figure(2), plot(t_decay, myFit.a*exp(myFit.b*t_decay), 'k');
%             end
%         end
%
%         fit_a_array(m) = mean(fit_a_indiv_array);
%         fit_b_array(m) = mean(fit_b_indiv_array);
%     end
%
%     export_fig(figure(2), sprintf('%s/%s_fit.png', SAVE_PATH, meas_name));
%
%     min_num = min(length(MaxIdx), length(MinIdx));
%     Maxima = Maxima(1:min_num);
%     Minima = Minima(1:min_num);
%
%     pulse_ratio_array(m) = mean(Maxima ./ Minima);
%     pulse_amplitude_array(m) = mean(Maxima - Minima);
%     frequency_array(m) = min_num / total_time;



