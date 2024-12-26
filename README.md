# APP23
Mariel Kozberg
12/25/2024 

Amyloid-beta coverage  
-
- Inputs: 
- Outputs: 

Diameter
- linescan_d.m 
- Inputs: raw "diameter" line scans from 2photon imaging (lines placed perpendicular to vessel segments)
- Outputs: indices of vessel edges across timeseries (ind1 = left edge, ind2 = right edge)   

Red blood cell (RBC) velocity uses the following code: 
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
