function [] = FindPlaqueArea_CAA(s)
% Steven Hou (shou@nmr.mgh.harvard.edu)

for s_idx = 1:length(s)
    
    INPUT_PATH = s(s_idx).INPUT_PATH;
    OUTPUT_PATH = sprintf('%s/OUTPUT', INPUT_PATH);
    mkdir(OUTPUT_PATH);
    
    name_array = s(s_idx).name_array;
    
    for name_idx = 1:length(name_array)
        name = name_array{name_idx};
        
        name
        FILEPATH = sprintf('%s/%s.oif.files', INPUT_PATH, name);
        
        listing = dir([FILEPATH, '/s_C001*.tif']);
        num_sections = length(listing);
        
        temp = imread(sprintf('%s/s_C001Z%03d.tif', FILEPATH, 1));
        [nx ny] = size(temp);
        
        channel1 = zeros(nx, ny, num_sections);
        
        for j = 1:num_sections
            j
            channel1(:, :, j) = imread(sprintf('%s/s_C001Z%03d.tif', FILEPATH, j));
        end
        
        %    intensity = uint16(mean(channel1, 3));
        intensity = max(channel1, [], 3);
        
%         figure(1), imagesc(intensity);
%         axis image;
%         colormap('gray');
%         hold on;
%         
        intensity = uint8(255*(intensity/max(max(intensity))));
        
        ROI_filename_zip = sprintf('%s/roi/%s_RoiSet.zip', INPUT_PATH, name);
        ROI_filename_roi = sprintf('%s/roi/%s.roi', INPUT_PATH, name);
        
        if exist(ROI_filename_zip, 'file') == 2
            temp = ReadImageJROI(ROI_filename_zip);
        elseif exist(ROI_filename_roi, 'file') == 2
            temp = ReadImageJROI(ROI_filename_roi);
        end
        
        num_ROI = length(temp);
        
        area_array = zeros(1, num_ROI);
        
        for j = 1:num_ROI
            
            if iscell(temp) == 1
                temp_ROI = temp{j};
            else
                temp_ROI = temp;
            end
            bounds = temp_ROI.vnRectBounds;
            
            x_min = bounds(1);
            x_max = bounds(3);
            
            y_min = bounds(2);
            y_max = bounds(4);
            
            intensity_ROI = intensity(x_min:x_max, y_min:y_max);
            
            level = graythresh(intensity_ROI);
            BW = im2bw(intensity_ROI,level);
            
            % Find biggest object
%             [L, num] = bwlabel(BW, 8);
%             count_pixels_per_obj = sum(bsxfun(@eq,L(:),1:num));
%             [~,ind] = max(count_pixels_per_obj);
%             biggest_blob = (L == ind);
%             
%             BW = biggest_blob;
%             num
            
            area_array(j) = sum(sum(BW));
            
            whole_image = zeros(nx, ny);
            whole_image(x_min:x_max, y_min:y_max) = BW;
            
            figure(1), imagesc(whole_image);
            axis image;
            colormap('gray');
            
            
            set(gcf, 'Color', 'white'); % white bckgr
            export_fig( gcf, ...      % figure handle
                sprintf('%s/%s_roi%d.png', OUTPUT_PATH, name, j),... % name of output file without extension
                '-painters', ...      % renderer
                '-png', ...           % file format
                '-r300' );             % resolution in dpi
         
         
            %
%             [B, L] = bwboundaries(whole_image, 'noholes');
% 
%             for k = 1:length(B)
%                 boundary = B{k};
%                 plot(boundary(:, 2), boundary(:, 1), 'y', 'Linewidth', 1);
%             end
        end
        
         figure(1), imagesc(intensity);
         axis image;
         colormap('gray');
          
         set(gcf, 'Color', 'white'); % white bckgr
         export_fig( gcf, ...      % figure handle
             sprintf('%s/%s.png', OUTPUT_PATH, name),... % name of output file without extension
             '-painters', ...      % renderer
             '-png', ...           % file format
             '-r300' );             % resolution in dpi
         
        
         temp = zeros(1, 3);
         temp(1) = num_ROI;
        temp(2) = num_sections;
        temp(3) = sum(area_array)/(nx*ny);
        
        sheet = 1;
        xlrange = 'A1';
        A = temp(:)';
        xlswrite(sprintf('%s/%s_stats.xls', OUTPUT_PATH, name), A, sheet, xlrange);
        
        sheet = 1;
        xlrange = 'D1';
        A = area_array(:);
        xlswrite(sprintf('%s/%s_stats.xls', OUTPUT_PATH, name), A, sheet, xlrange);
        
        close all;
    end
end




