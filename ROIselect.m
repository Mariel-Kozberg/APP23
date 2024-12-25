function[coor,figs] = ROIselect(data,g,endframe)

f = figure; 
imagesc(data(:,:,endframe)); axis image; colormap gray; 
coor = ones(4,g); 
for l = 1:g
h = imrect; 
pos = getPosition(h); 
coor(:,l) = pos; 
end

close(f); 
figs = figure; 
imagesc(data(:,:,endframe)); axis image; colormap gray; hold on; 
colors = jet(g); 
for l = 1:g
rectangle('Position',coor(:,l),'EdgeColor',colors(l,:),'LineWidth',2); 
end 
