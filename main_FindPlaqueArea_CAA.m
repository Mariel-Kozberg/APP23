clear all;

addpath(sprintf('%s/export_fig', pwd));

s(1).INPUT_PATH = 'Z:\hymanlab\bacskai\Mari SanchezMico\Macros\Steve\Picking.Plaques.V2.0\Data_example';
s(1).name_array = {'Image7'};

FindPlaqueArea_CAA(s);
