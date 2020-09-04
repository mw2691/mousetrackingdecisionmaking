% OrderQuestionsInTrialOrder.m
% Function relates to experiment MouseDecisionTrackingExperimentMainCode.m
% Markus Wieland August 2020
function QuestionOrderForTrial = OrderQuestionsInTrialOrder(presentationOrder, questionOrder)
%This function orders both sorts of questions (visual and auditory) based
%on the BalanceFactors function and returns this as a cell array.
%Param: presentationOrder is the return value "presentation" from the BalanceFactors
%function and indicates whether a visual or auditory question should be presented in
%each trial
%Param: questionOrder is the return value "questions" from the BalanceFactors
%function and indicates which category of questions (Yes,Yes/No,No) should
%be presented in each trial


%Read in the visual and auditory questions
visualQuestionsName = 'VisualQuestions';
visualQuestionsFileName= [visualQuestionsName '.txt'];
visualQuestions = ReturnMatrixWithVisualQuestions(visualQuestionsFileName);
auditiveQuestionsCellArray = ReturnCellArrayWithAuditiveQuestions();

%Preallocate the return cell array with the order of the questions
questionTrialSequence = cell(length(presentationOrder),1);

%Init of counters to ensure that each question is unique
%VisualQuestion
counterYesVisualQuestion = 1;
counterYesNoVisualQuestion = 1;
counterNoVisualQuestion = 1;
%AuditoryQuestion
counterYesAuditiveQuestion = 1;
counterYesNoAuditiveQuestion = 1;
counterNoAuditiveQuestion = 1;

%Fill the cell array with the visual and auditory questions
for i = 1:length(presentationOrder)
    
    
    %--------%
    % VISUAL %
    %--------%
    %If presentation of question is VISUAL
    if presentationOrder(i) == 1
        %Question is one of three categories
        switch questionOrder(i)
            case 1 % =YesQuestion
                %Get question from the all visual questions matrix and
                %store it
                questionTrialSequence{i} = visualQuestions(counterYesVisualQuestion,1);
                counterYesVisualQuestion = counterYesVisualQuestion +1;
            case 2 % =YesNoQuestion
                questionTrialSequence{i} = visualQuestions(counterYesNoVisualQuestion,2);
                counterYesNoVisualQuestion = counterYesNoVisualQuestion +1;
            case 3 % = NoQuestion
                questionTrialSequence{i} = visualQuestions(counterNoVisualQuestion,3);
                counterNoVisualQuestion = counterNoVisualQuestion +1;
        end
    
        
    %----------%
    % AUDITORY %
    %----------%
    %If presentation of question is AUDITORY     
    else
        %Question is one of three categories
        switch questionOrder(i)
            case 1 % =YesQuestion
                %Get question from the all auditory questions cell array
                %and store it
                questionTrialSequence{i} = auditiveQuestionsCellArray(counterYesAuditiveQuestion,1);
                counterYesAuditiveQuestion = counterYesAuditiveQuestion +1;
            case 2 % =YesNoQuestion
                questionTrialSequence{i} = auditiveQuestionsCellArray(counterYesNoAuditiveQuestion,2);
                counterYesNoAuditiveQuestion = counterYesNoAuditiveQuestion +1;
            case 3 % =NoQuestion
                questionTrialSequence{i} = auditiveQuestionsCellArray(counterNoAuditiveQuestion,3);
                counterNoAuditiveQuestion = counterNoAuditiveQuestion +1;
        end
    end
    
    
end

%Return the cell array with all questions in the correct order
QuestionOrderForTrial = questionTrialSequence;

end