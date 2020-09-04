%MouseDecisionTrackingExperimentMainCode.m

%Written by Markus Wieland, August 2020
%Created for Seminar Experimentalprogrammierung mit MATLAB und
%Psychtoolbox-3 by Dr. Elisabeth Hein, Summer Term 2020
%
%The experiment examines the kinematic profile of a decision-making process. 
%This is achieved through the recording of the mouse trajectory pathway. 
%In each trial, participants have to answer a question that is presented either visually or auditive. 
%Two answer buttons (yes and no) are presented in the upper-left and right. 
%Each question belongs to one of three categories (clear yes question, question with no clear yes or no answer, clear no question).
%Task: participants have to press one of the buttons after they have heard or seen the question.
%Variables:
%DV: x and y screen coordinates of mouse trajectory
%UV 1 : presentation form of question (visual or auditory)
%UV 2: category of question (1. clear yes question, 2. no clear yes or no question, 3. Clear no question) 


function MouseDecisionTrackingExperimentMainCode()

try
    %turn off matlab error sound
    beep off;
    
    
    
    
    %---------------------%
    % 1. DEFINE VARIABLES %
    %---------------------%
    
    resultName = 'MouseDecTracking';
    resultFileName=[resultName '.txt'];
    resultFileHeader = 'ID\t Trial\t x\t y\t QuestionCat\t Presentation\t ButtonOrder\t WhichButton\n';
    resultFileFormatSpecifier = '%d\t %d\t %.2f\t %.2f\t %d\t %d\t %d\t %d\n';
    resultFileExists = CheckForExistingResultFile(resultFileName);
    
    %Check for existing result file and append to file or create new file
    if resultFileExists
        participantID = AppendParticipantsIDToExistingFile(resultFileName);
        resultFile = fopen(resultFileName, 'a');
        
    else
        participantID = 1;
        resultFile = fopen(resultFileName, 'w');
        fprintf(resultFile, resultFileHeader);
        
    end
    
    
    %Balance Factors
    presentationLevels = [1 2];
    questionLevels = [1 2 3];
    nConditions = length(presentationLevels) * length(questionLevels);
    experimentalTrials = nConditions*6;
    randomTrials = 1;
    trialsPerCondition = ceil(experimentalTrials/nConditions);
    [questions,presentation] = BalanceFactors(trialsPerCondition, randomTrials, questionLevels, presentationLevels);

    
    %Read in stimuli and order it based on BalanceFactors
    trialOrderQuestion = OrderQuestionsInTrialOrder(presentation, questions);
    %this experiment assumes stereo and fix sampling rate of the recorded
    %questions
    samplingRate = 44100;
    audioChannels = 2;
    
    %Init PsychSound,open audioport, and set volume
    InitializePsychSound;
    numberOfRepetitionQuestion = 1;
    audio_port = PsychPortAudio('Open', [], [], 0, samplingRate, audioChannels);
    PsychPortAudio('Volume', audio_port, 0.5);
    
    %preallocate result arrays with overestimated size
    %idea: it is not clear how many coordinates are recorded in every
    %trial and therefore a large array is created to avoid dynamic
    %resizing of array during the trial
    xCoordinatesMouse = ones(10000,1);
    yCoordinatesMouse = ones(10000,1);
    trialCounter = zeros(10000,1);
    participantsIDs = zeros(10000,1);
    questionCategory = zeros(10000,1);
    stimuliPresentation = zeros(10000,1);
    buttonOrder = zeros(10000,1);
    whichButtonPressed = zeros(10000,1);
    
    
    %----------------------%
    % 2. INITIALIZE SCREEN % 
    %----------------------%
    
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'VisualDebugLevel', 3);
    screenVector = Screen('Screens');
    screenNumber = max(screenVector);
    %use for experiment:
    [mainWindow, windowRect] = Screen('OpenWindow', screenNumber,1);
    %use for debugging (if only one monitor is available):
    %[mainWindow, windowRect] = Screen('OpenWindow', screenNumber,1, [0 0 640 480]);
    Priority(MaxPriority(mainWindow));
    [xCenter, yCenter] = RectCenter(windowRect);
    [screenXpixels, screenYpixels] = Screen('WindowSize', mainWindow);
    
    
    
    
    %-------------------------------%
    % 3. INITIALIZE VISUAL ELEMENTS % 
    %-------------------------------%
    
    %Color
    whiteColorForAllVisualElements = [255, 255, 255];
    
    %FixationCross
    fixCrossHeight = 25;
    xCoordinatesCross = [-fixCrossHeight fixCrossHeight 0 0];
    yCoordinatesCross = [0 0 -fixCrossHeight fixCrossHeight];
    allCoordinatesCross = [xCoordinatesCross; yCoordinatesCross];
    lineWidthPix = 4;
    
    %StartButton
    rectangleSizeStart = [0 0 250 100];
    rectangleBottom = CenterRectOnPoint(rectangleSizeStart, screenXpixels/2, screenYpixels-120);
    [xCenterRectBottom, yCenterRectBottom] = RectCenter(rectangleBottom);
    startButtonText = 'Start';
    
    %Define Yes/No Buttons
    rectangleSize = [0 0 150 100];
    rectangleLeft = CenterRectOnPoint(rectangleSize, 100, 150);
    rectangleRight = CenterRectOnPoint(rectangleSize, screenXpixels-100, 150);
    [xCenterRectLeft, yCenterRectLeft] = RectCenter(rectangleLeft);
    [xCenterRectRight, yCenterRectRight] = RectCenter(rectangleRight);
    yesButtonText = 'Ja';
    noButtonText = 'Nein';
    xCenterRectLeftOffset = 23;
    xCenterRectRightOffset = 12;
    yCenterRectOffset = 10;
    
    %Create random array with 1 and 2 for placement of yes no buttons
    randomNumbersWhichDeterminePlacementOfYesNoButtons = randi([1 2],1,experimentalTrials);
    
    
    
    
    %-------------------------%
    % 4. PRESENT INSTRUCTONS  %
    %-------------------------%
    
    %Instructions for participants
    welcomeText = ['Hallo und herzlich Willkommen zu unserem Experiment.\n'... 
    'Zunächst vielen Dank, dass du dabei bist.\n'... 
    'Bei diesem Experiment bekommst du Fragen auf dem Monitor oder über die Kopfhörer präsentiert.\n'...
    'Zudem erscheinen zwei Antwortbuttons in der linken und rechten oberen Bildschirmecke.\n'...
    'Hier klickst du bitte so schnell wie möglich mit der Maus auf einen der beiden Antwortbuttons.\n'...
    'Wenn die Fragen über die Kopfhörer präsentiert werden, bitte ich dich auf das Fixationskreuz in der Mitte zu schauen.\n'... 
    'Sobald du eine beliebige Taste drückst, verschwindet dieser Text und das Experiment startet direkt.\n'... 
    'Bist du bereit?'];
    endText = 'Du hast alle Durchgänge absolviert. Vielen Dank für deine Teilnahme!';
    DrawFormattedText(mainWindow, welcomeText, 'center', 'center', whiteColorForAllVisualElements, [], [], [], 2);
    Screen('Flip', mainWindow);
    
    %Wait for keyboard input and start the actual experiment
    KbWait([], 2);
    Screen('Flip', mainWindow);
    
    
    
    
    %--------------------%
    % 5. RUN EXPERIMENT  %
    %--------------------%
    
    for trial = 1:experimentalTrials
    
        %Present StartButton
        Screen('FrameRect', mainWindow, whiteColorForAllVisualElements, rectangleBottom);
        Screen('DrawText', mainWindow, startButtonText, xCenterRectBottom-xCenterRectLeftOffset, yCenterRectBottom-yCenterRectOffset,whiteColorForAllVisualElements);
        Screen('Flip', mainWindow);
        
        
        %Wait until the start button is pressed
        startButtonPressed = 0;
        while ~startButtonPressed
            [clicks, xClick,yClick]= GetClicks;
            insideStartRect = IsInRect(xClick,yClick,rectangleBottom);
            if insideStartRect == 1
                startButtonPressed = 1;
            end
        end
        Screen('Flip', mainWindow);
        
        %Present Yes/No Buttons in random order
        Screen('FrameRect', mainWindow, whiteColorForAllVisualElements, rectangleLeft);
        Screen('FrameRect', mainWindow, whiteColorForAllVisualElements, rectangleRight);
        
        if randomNumbersWhichDeterminePlacementOfYesNoButtons(trial) == 1
            Screen('DrawText', mainWindow, yesButtonText, xCenterRectLeft-xCenterRectRightOffset, yCenterRectLeft-yCenterRectOffset,whiteColorForAllVisualElements);
            Screen('DrawText', mainWindow, noButtonText, xCenterRectRight-xCenterRectLeftOffset, yCenterRectRight-yCenterRectOffset,whiteColorForAllVisualElements);
            
        else
            Screen('DrawText', mainWindow, noButtonText, xCenterRectLeft-xCenterRectLeftOffset, yCenterRectLeft-yCenterRectOffset, whiteColorForAllVisualElements);
            Screen('DrawText', mainWindow, yesButtonText, xCenterRectRight-xCenterRectRightOffset, yCenterRectRight-yCenterRectOffset, whiteColorForAllVisualElements);
            
        end
        
        
        %Present stimuli
        %Present visual stimuli
        if presentation(trial) == 1
            currentVisualQuestion = convertStringsToChars(trialOrderQuestion{trial,1});
            DrawFormattedText(mainWindow, currentVisualQuestion, 'center', 'center', whiteColorForAllVisualElements, [], [], [], 2);
            Screen('Flip', mainWindow);
        
        %Present auditory stimuli
        else
            currentAuditiveQuestion = trialOrderQuestion{trial,1};
            PsychPortAudio('FillBuffer', audio_port, currentAuditiveQuestion{1,1});
            Screen('DrawLines', mainWindow, allCoordinatesCross,lineWidthPix, whiteColorForAllVisualElements, [xCenter yCenter]);
            Screen('Flip', mainWindow);
            PsychPortAudio('Start', audio_port, numberOfRepetitionQuestion, 0, 1);
        end
        
        
        counterMouseTracking = 1;
        answerButtonPressed = 0;

        %Waits until one of the answer buttons is pressed
        while ~answerButtonPressed
            [xCoor, yCoor, buttons] = GetMouse(mainWindow);
            insideLeftRect = IsInRect(xCoor,yCoor,rectangleLeft);
            insideRightRect = IsInRect(xCoor,yCoor,rectangleRight);
            
            %Result arrays are filled
            xCoordinatesMouse(counterMouseTracking) = xCoor;
            yCoordinatesMouse(counterMouseTracking) = yCoor;
            trialCounter(counterMouseTracking) = trial;
            participantsIDs(counterMouseTracking) = participantID;
            questionCategory(counterMouseTracking) = questions(trial);
            stimuliPresentation(counterMouseTracking) = presentation(trial);
            buttonOrder(counterMouseTracking) = randomNumbersWhichDeterminePlacementOfYesNoButtons(trial);
            counterMouseTracking = counterMouseTracking + 1;
            
            if insideRightRect
                whichButtonPressed(counterMouseTracking) = 2;

            elseif insideLeftRect
                whichButtonPressed(counterMouseTracking) = 1;
            end
            
            %Detects if one of the answer buttons is pressed, waits for
            %0.1s for realistic behavior and sets the
            %bool answerButtonPressed to true
            if (insideLeftRect || insideRightRect) && any(buttons)
                WaitSecs(0.1);
                Screen('Flip', mainWindow);
                answerButtonPressed = 1;
            end
            %if no WaitSecs is used, the while loop would write to many
            %results in the result arrays
            WaitSecs(0.01);
        end
        
        
        %Remove the rest of non used result arrays before writing to result
        %file
        xCoordinatesMouse = xCoordinatesMouse(1:counterMouseTracking-1);
        yCoordinatesMouse = yCoordinatesMouse(1:counterMouseTracking-1);
        participantsIDs = participantsIDs(1:counterMouseTracking-1);
        trialCounter = trialCounter(1:counterMouseTracking-1);
        questionCategory = questionCategory(1:counterMouseTracking-1);
        stimuliPresentation = stimuliPresentation(1:counterMouseTracking-1);
        buttonOrder = buttonOrder(1:counterMouseTracking-1);
        whichButtonPressed = whichButtonPressed(1:counterMouseTracking-1);
        trialData = [participantsIDs trialCounter xCoordinatesMouse yCoordinatesMouse questionCategory stimuliPresentation buttonOrder whichButtonPressed];
        
        fprintf(resultFile, resultFileFormatSpecifier, trialData');
       
    end
    
    
    
    
    %--------------% 
    % 6. CLEAN UP  % 
    %--------------%
    
    fclose(resultFile);
    PsychPortAudio('Close', audio_port);
    Priority(0);
    DrawFormattedText(mainWindow, endText, 'center', 'center', whiteColorForAllVisualElements, [], [], [], 2);
    Screen('Flip', mainWindow);
    WaitSecs(10);
    clearvars;
    sca;
     
    
catch
    psychrethrow(psychlasterror);
    Screen('CloseAll')
end
end