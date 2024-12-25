clear all; close all; 
% inputs: raw line scan data from 2-photon (parallel to vessel wall in order to detect RBC velocity) 
% outputs: timecourses of RBC velocity and saved jpegs for a visual check 

pixel_size = 0.3310; % Number of microns/pixel
total_time = 2.5; % Total time of scan in seconds
num_points = 10000; % Total number of scans
fit_status = 0; % Display fitting

mouse = ''; % enter mouse name 
sessions = []; % enter all sessions (e.g. 1:3) 
homedir = ''; % set home directory 
cd(homedir); 

for j = 1:length(sessions)

loaddir = ['']; % set loading directory 
savedir = ['']; % set save directory 
vessels = []; % chose which vessels you want to analyze (e.g. 1:10) 

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
 
