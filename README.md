# APP23
Mariel Kozberg
12/25/2024 

Amyloid-beta coverage: 
(code courtesy of Dr. Steven Hou, MGH)  
- main_FindPlaqueArea_CAA.m (calls FindPlaqueArea_CAA.m, requires ReadImageJROI.m to run) 
- Inputs: z-stack 2photon imaging data with amyloid-beta (labeled with contrast agent, in these experiments, methoxy-XO4) and vascular imaging data (vesse;s labeled with IV fluorescent dextran), ROIs selected in ImageJ surrounding blood vessels (excluding parenchymal amyloid-beta plaques) 
- Outputs: spreadsheet with % coverage of amyloid-beta of different vessel segments 

Diameter: 
- linescan_d.m 
- Inputs: raw "diameter" line scans from 2photon imaging (lines placed perpendicular to vessel segments)
- Outputs: indices of vessel edges across timeseries (ind1 = left edge, ind2 = right edge)   

Red blood cell (RBC) velocity: 
 (code courtesy of Dr. Steven Hou, MGH) 
- main_velocity (calls GetVesselVelocity.m)
- Inputs: raw "velocity" line scans from 2photon imaging (lines placed parallel to the the edges of the vessel) 
- Outputs: timeseries of RBC velocity over imaging period, jpg

Vasomotion: 
- vasomotion.m (calls ROIselect.m)
- Inputs: raw 2photon timeseries data  
- Outputs: 1) time domain analysis (1st segment of code): timecourses of vessel segment diameter changes in pixels and as full-width half max (FWHM) 2) frequency analysis (2nd segment of code): analysis of pixel outputs to 1 in the frequency domain, finds vasomotion peak between 0.04 and 0.13 Hz   

Pulsatility: 
- linescan_d.m (see above) --> use these outputs for pulsatility_d.m
- Inputs: outputs of linescan_d
- Outputs: heart rate, average diameter of each vessel, absolute value of area under curve of each vessel as measure of pusatility (units of microns * number of ms), figures demonstrating analysis performed for each vessel for visual check
