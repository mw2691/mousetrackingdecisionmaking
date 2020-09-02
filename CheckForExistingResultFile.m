% CheckForExistingResultFile.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function [ResultFileExists] = CheckForExistingResultFile(fileName)
%This function checks, if a result file is already there 

if isfile(fileName)
    ResultFileExists = true;

else
    ResultFileExists = false;
    
    
end


end
