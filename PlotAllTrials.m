% PlotAllTrials.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function PlotAllTrials(participantID)
%This function plots all trials with the values from the result file
%Param: participantID is the number of the desired participant 

%Read resultfile as tables and convert to matrix
fileName = 'MouseDecTracking';
resultFile = readtable(fileName);
resultFile = resultFile{:,:};

%get the participant id and trial numbers
getTrialNumbers = unique(resultFile(:,2));
getParticipantIDs = unique(resultFile(:,1));

%filter resultfile for desired participant id
logicalIndexParticipantID  = resultFile(:,1) == getParticipantIDs(participantID);
resultFileWithParticipantIDFilter = resultFile(logicalIndexParticipantID,:);

for i = 1:length(getTrialNumbers)
    logicalIndexTrialNumber = resultFileWithParticipantIDFilter(:,3) & resultFileWithParticipantIDFilter(:,2) == getTrialNumbers(i);
    resultFileFilterPartIDAndTrialNumber = resultFileWithParticipantIDFilter(logicalIndexTrialNumber,:);
    x1 = resultFileFilterPartIDAndTrialNumber(:,3);
    y1 = resultFileFilterPartIDAndTrialNumber(:,4);
    figure(i);
    plot(x1,y1);
end

end







