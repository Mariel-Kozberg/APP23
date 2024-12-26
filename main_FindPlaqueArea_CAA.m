clear all;

addpath(sprintf('%s/export_fig', pwd));

s(1).INPUT_PATH = ''; %loading directory 
s(1).name_array = {''}; %image to analyze 

FindPlaqueArea_CAA(s);
