clear all; close all; 

pixel_size = 0.3310; % Number of microns/pixel
total_time = 2.5; % Total time of scan in seconds
num_points = 10000; % Total number of scans
fit_status = 0; % Display fitting

mouse = 'RFC1184'; 
sessions = [1 2 3]; 
homedir = '/users/marielkozberg/Documents/code/';
cd(homedir); 

for j = 1:length(sessions)

loaddir = ['/Volumes/MGH-VANVELUWLAB/Eugene/ROCK/Olympus/' mouse '_' num2str(sessions(j)) '/'];
savedir = ['/Volumes/MGH-VANVELUWLAB/Eugene/ROCK/Olympus/' mouse '_' num2str(sessions(j)) '/'];
vessels = [1:2]; % :20]; % which vessels you want to analyze 

for i = 1:size(vessels,2)
   % vessel = char(vessels(i)); % for S191F2 session 1 and 2 
   % name(i) = string(['LSV' num2str(vessel)]); % string(['LSV' num2str(vessel)]);
   name(i) = string(['LSV' num2str(vessels(i))]);  
end 

name2 = cellstr(name); 
s(1).INPUT_PATH = loaddir; 
s(1).name_array = name2; 
s(1).channel = 1; % PMT channel with line scan data
%
% filename = 'LSV1.oif.files'; 
% cd([loaddir filename]) 
% for i = 1:num_points
%     data = imread(['s_C002-R002' '.tif']); 
% end 

GetVesselVelocity_Wrapper(s, pixel_size, total_time, num_points, fit_status,savedir,homedir);

end 
 