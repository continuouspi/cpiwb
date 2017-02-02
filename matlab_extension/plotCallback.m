% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function plotCallback(hObject, ~, ~)

% set the transparency of the selected plot on clicking
% fourth color index sets transparency of lines
if (strcmp(hObject.LineStyle, '-'))
   hObject.Color = [hObject.Color 0.2]; 
   hObject.LineStyle = '--';
else
   hObject.Color = [hObject.Color 1.0]; 
   hObject.LineStyle = '-';
end

end