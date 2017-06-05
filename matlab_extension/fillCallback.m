% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function fillCallback(hObject, ~, ~)

% set the transparency of the selected plot on clicking
% fourth color index sets transparency of lines
if (hObject.FaceAlpha == 0.2)
   hObject.FaceAlpha = 0.1;
else
   hObject.FaceAlpha = 0.2;
end

end