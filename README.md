# APP23
Mariel Kozberg
12/25/2024 

Amyloid-beta coverage 
(code courtesy of Dr. Steven Hou, MGH)  
- main_FindPlaqueArea_CAA.m (calls FindPlaqueArea_CAA.m, requires ReadImageJROI.m to run) 
- Inputs: z-stack 2photon imaging data with amyloid-beta (labeled with contrast agent, in these experiments, methoxy-XO4) and vascular imaging data (vesse;s labeled with IV fluorescent dextran), ROIs selected in ImageJ surrounding blood vessels (excluding parenchymal amyloid-beta plaques) 
- Outputs: spreadsheet with % coverage of amyloid-beta of different vessel segments 

Diameter
- linescan_d.m 
- Inputs: raw "diameter" line scans from 2photon imaging (lines placed perpendicular to vessel segments)
- Outputs: indices of vessel edges across timeseries (ind1 = left edge, ind2 = right edge)   

Red blood cell (RBC) velocity uses the following code: 
 (code courtesy of Dr. Steven Hou, MGH) 
- main_velocity (calls GetVesselVelocity.m)
- Inputs: raw "velocity" line scans from 2photon imaging (lines placed parallel to the the edges of the vessel) 
- Outputs: timeseries of RBC velocity over imaging period, jpg

Vasomotion uses the following code: 
- vasomotion.m (calls ROIselect.m)
- Inputs: raw 2photon timeseries data  
- Outputs: 

Pulsatility uses the following code: 
- linescan_d.m (see above) --> use these outputs for pusatility_d.m
- Inputs: 
- Outputs: 
