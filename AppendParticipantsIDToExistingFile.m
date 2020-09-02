% AppendParticipantsIDToExistingFile.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function ParticipantID = AppendParticipantsIDToExistingFile(fileName)
%This function asks for the next participants id and checks if the number
%is valid.

%read in existing file, get participants id column, show only unique
%participant ids, get last participant id
%Return arg ParticipantID: 
%Number of Participant ID which was entered by the user

readInExistingResultFile = readtable(fileName);
participantIDColumn = readInExistingResultFile(:,1);
uniqueParticipantIDs = unique(participantIDColumn);
lastParticipantID = uniqueParticipantIDs{end,:};

%prompt the user and cast his answer to a double
prompt = sprintf('Enter Participant ID: (last ID: %d)', lastParticipantID);
dialogTitle = 'Participant ID';
userAnswer = inputdlg(prompt,dialogTitle);
userAnswerCast= str2double(userAnswer);

%If the entered participants id is already in the existing file, then
%prompt the user with a message and stop the script
if any(uniqueParticipantIDs{:,1} == userAnswerCast)
    msgbox('Participants ID is not valid. Please start function MouseDecisionTrackingExperimentMainCode.m again');
    %no need to call sca - just to play it safe
    sca;
    clearvars;
    return;
end

ParticipantID = userAnswerCast;

end