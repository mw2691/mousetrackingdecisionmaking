% ReturnCellArrayWithAuditiveQuestions.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function AuditiveQuestionsCellArray = ReturnCellArrayWithAuditiveQuestions()
%This function reads in the auditory questions, transposes the amplitudes (for PsychPortAudio function), and stores it in a 6 x 3 cell
%array and returns this cell array and the sampling rate of the recorded
%questions. 
%Return arg AuditiveQuestionsCellArray: 
%first column belongs to the YesQuestions, second column to the YesNoQuestions, third column to the
%NoQuestions.


%%%%%%YesQuestions%%%%%%
yesQuestion01 = 'Yes01.wav';
[y1] = audioread(yesQuestion01);
y1 = y1';

yesQuestion02 = 'Yes02.wav';
[y2] = audioread(yesQuestion02);
y2 = y2';

yesQuestion03 = 'Yes03.wav';
[y3] = audioread(yesQuestion03);
y3 = y3';

yesQuestion04 = 'Yes04.wav';
[y4] = audioread(yesQuestion04);
y4 = y4';

yesQuestion05 = 'Yes05.wav';
[y5] = audioread(yesQuestion05);
y5 = y5';

yesQuestion06 = 'Yes06.wav';
[y6] = audioread(yesQuestion06);
y6 = y6';





%%%%%%YesNoQuestions%%%%%%
yesNoQuestions01 = 'YesNo01.wav';
[y7] = audioread(yesNoQuestions01);
y7 = y7';

yesNoQuestions02 = 'YesNo02.wav';
[y8] = audioread(yesNoQuestions02);
y8 = y8';

yesNoQuestions03 = 'YesNo03.wav';
[y9] = audioread(yesNoQuestions03);
y9 = y9';

yesNoQuestions04 = 'YesNo04.wav';
[y10] = audioread(yesNoQuestions04);
y10 = y10';

yesNoQuestions05 = 'YesNo05.wav';
[y11] = audioread(yesNoQuestions05);
y11 = y11';

yesNoQuestions06 = 'YesNo06.wav';
[y12] = audioread(yesNoQuestions06);
y12 = y12';



%%%%%%NoQuestions%%%%%%
noQuestions01 = 'No01.wav';
[y13] = audioread(noQuestions01);
y13 = y13';

noQuestions02 = 'No02.wav';
[y14] = audioread(noQuestions02);
y14 = y14';

noQuestions03 = 'No03.wav';
[y15] = audioread(noQuestions03);
y15 = y15';

noQuestions04 = 'No04.wav';
[y16] = audioread(noQuestions04);
y16 = y16';

noQuestions05 = 'No05.wav';
[y17] = audioread(noQuestions05);
y17 = y17';

noQuestions06 = 'No06.wav';
[y18] = audioread(noQuestions06);
y18 = y18';


AuditiveQuestionsCellArray = {y1,y2,y3; 
    y4,y5,y6; 
    y7,y8,y9;
    y10,y11,y12;
    y13,y14,y15;
    y16,y17,y18};

end