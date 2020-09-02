% ReturnMatrixWithVisualQuestions.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function VisualQuestionsMatrix = ReturnMatrixWithVisualQuestions(visualQuestionFileName)
%This function reads in the visual questions from a .txt file, stores it
%in a 6 x 3 matrix, and returns this matrix
%Param: visualQuestionFileName should hold the name of the .txt file where the
%questions from the three different categories are placed underneath
%(question 1-6 = YesQuestions, question 7-12 = YesNoQuestion, question
%13-18 = NoQuestion)

%Open the file, read and close it
fileID = fopen(visualQuestionFileName,'r');
readFile = fscanf(fileID ,'%c');
fclose(fileID);

%Convert the read in chars to strings and split it by newline
convertReadInCharsToStrings = convertCharsToStrings(readFile);
splitReadInStringsByNewline = strsplit(convertReadInCharsToStrings,'\n');

%Divide questions into three categories and storage them
yesQuestions = transpose(splitReadInStringsByNewline(1:6));
yesNoQuestions = transpose(splitReadInStringsByNewline(7:12));
noQuestions = transpose(splitReadInStringsByNewline(13:18));

%return the matrix
VisualQuestionsMatrix = [yesQuestions yesNoQuestions noQuestions];

end