function task(subID, session)
    
    %cd('C:\Users\Nik\FernUni Schweiz\NiksDiss - exercise and memory\task');
    
    % Ask for session and participant ID
    prompt = {"Participant", "Session"};
    dlgtitle = 'Session';
    dims = [1 1];
    
    if exist('subID', 'var') == 1 && exist('session','var')
        definput = {num2str(subID), num2str(session)};
    elseif exist('subID', 'var') == 1 && ~exist('session','var')
        definput = {num2str(subID), ''};
    elseif exist('session','var') && ~exist('subID','var')
        definput = {'', num2str(session)};
    else
        definput = {'', ''};
    end
    
    answer = inputdlg(prompt, dlgtitle, dims, definput);
      
    subID = str2num(answer{1});
    session = str2num(answer{2});
    
    
    pkg load io
    
    IDPos = subID - 100;                      % The first participant has the participant number 101 and so on. This variable defines the position of each participant in the procedure and other files
    participantID = num2str(subID);           % Save participant number as string for folder name and results file
    
    
    %% Get the time and set up random number generator
    cl = clock;
    rand('state', sum(100*cl)); % Initialize the random number generator
    time = sprintf('%s-%d-%d-%d',date,cl(4),cl(5),round(cl(6)));      % This will give you a string containing the current time stamp

    
    %% Experiment setup
    % Create a variable for each textdisplay
    introductionTextImmediate = { ...
        'In diesem Experiment werden Sie jeweils ein deutsches Wort auf dem Bild-'; ...
        'schirm sehen und werden die Übersetzung auf Suaheli aufschreiben müssen'; ...
        'und mit Enter eingeben oder aus einer von vier Antwortmöglichkeiten mit den'; ...
        'Zahlentasten 1-4 auswählen. Zu Beginn kennen Sie die Worte natürlich noch'; ...
        'nicht, Sie können dann aber einfach etwas raten und weiterfahren. Nachdem'; ...
        'Sie geantwortet haben, wird das korrekte Wort für ein paar Sekunden auf dem'; ...
        'Bildschirm angezeigt. Während dieser Zeit können Sie versuchen die Worte zu'; ...
        'lernen.'; ...
        ' '; ...
        'Zu Beginn des Experiments lernen Sie so lange Worte auf Suaheli, bis Sie eine'; ...
        'gewisse Menge der Worte in einem Durchgang korrekt aufschreiben oder aus den'; ...
        'Antwortmöglichkeiten erkennen können. Es gibt dabei vier Teile. Sobald'; ...
        'Sie das Ziel im ersten Teil erreicht haben beginnt der zweite Teil mit der'; ...
        'selben Anzahl Worten u.s.w. bis der vierte Teil abgeschlossen wird.'; ...
        'Anschliessend an die vier Teile, nach einer kurzen Pause, werden einige der'; ...
        'gelernten Worte noch einmal abgefragt, wie gut Sie sich erinnern können.'};
    
    introductionTextDelayed = { ...
        'Im dieser Sitzung werden einige der vor zwei Tagen gelernten Worte nochmal ab-'; ...
        'gefragt um zu sehen wie gut Sie sich noch an die einzelnen Worte erinnern können.'; ...
        'Dazu werden Ihnen Worte auf Suaheli präsentiert und entweder müssen Sie die Über-'; ...
        'setzung aufschreiben und mit Enter bestätigen, oder Sie können mit den Zahlen-'; ...
        'tasten 1-4 aus vier Antwortmöglickeiten auswählen. Es gibt dabei keine Rückmeldung'; ...
        'ob die Antwortt korrekt oder falsch war.'; ...
        ' '; ...
        'Falls Sie die Übersetzung nicht kennen, können Sie einfach raten.'};
    
    encodingText = { ...
        'Nun beginnt das eigentliche Experiment. Falls Sie noch Fragen zum Ablauf haben,'; ...
        'können Sie diese jetzt noch stellen.'; ...
        ' '; ...
        'Das Experiment startet, sobald der Versuchsleiter weiter drückt.'};
    
    retrievalText = { ...
        'Im nächsten Teil werden einige der gelernten Worte noch jeweils einmal abgefragt'; ...
        'um zu sehen wie gut Sie sich noch an die einzelnen Worte erinnern können. Im'; ...
        'Gegensatz zum Lernen gibt es jetzt aber keine Rückmeldung mehr.'; ...
        ' '; ...
        'Falls Sie die Übersetzung nicht kennen, können Sie einfach raten.'};
    
    distractorText = { ...
        'Nun folgt eine kurze Zwischenaufgabe. Zählen Sie dabei laut für 30 Sekunden'; ... 
        'von der Zahl 92 in 3er-Schritten Rückwärts (z.B. 98, 95, 92, usw.).'; ...
        ' '; ...
        'Die Aufgabe beginnt, sobald der Versuchsleiter weiter drückt.'};
    
    practiceIntro = { ...
      'Zu Beginn gibt es ein paar Übungsdurchgänge, damit Sie sehen wie die Aufgabe'; ...
      'genau aussieht. Diese Worte müssen Sie noch nicht lernen.'};
    
    
    %% Load all the necessary files
    % Load the procedure file (change link if necessary)
    procedure=xlsread('procedure/procedure.xlsx');
    
    % Load the wordlist and remove first row(change link if necessary)
    fullDataset = csv2cell('wordlists/wordlist.csv', ',');
    fullDataset = fullDataset(2:end,:);
    
    % Load the file with the practice words
    listPr=csv2cell('wordlists/practicelist.csv', ',');
    
    
    %% Define the conditions wor each word in the session
    % Define the activity condition based on the procedure 
    if (procedure(IDPos, 2) == 1 && (session == 1 | session == 2)) | (procedure(IDPos, 2) == 2 && (session == 3 | session == 4))
      activityCondition = "Rest";
    elseif (procedure(IDPos, 2) == 1 && (session == 3 | session == 4)) | (procedure(IDPos, 2) == 2 && (session == 1 | session == 2))
      activityCondition = "PA";
    end
    
    % Define the retrieval condition based on the session
    if mod(session, 2) == 1
      retentionName = 'immediate';
    else
      retentionName = 'delayed';
    end
    
    % Assign the wordlists to the different coonditions based on the session and procedure
    if session == 1 | session == 2
      immediateDeep = procedure(IDPos, 3);
      immediateShallow = procedure(IDPos, 4);
      delayedDeep = procedure(IDPos, 5);
      delayedShallow = procedure(IDPos, 6);
    elseif session == 3 | session == 4
      immediateDeep = procedure(IDPos, 7);
      immediateShallow = procedure(IDPos, 8);
      delayedDeep = procedure(IDPos, 9);
      delayedShallow = procedure(IDPos, 10);
    end
    
    % Name the encoding condition of each stimulus in the wordlist
    pos = 1;        % Start at 1
    
    for wli = 1:length(fullDataset)
      
      if strcmp(fullDataset(wli, 5), 's') && (fullDataset{wli, 4} == immediateDeep | fullDataset{wli, 4} == delayedDeep)
        fullDataset(wli, 6) = "Deep";
      elseif strcmp(fullDataset(wli, 5), 's') && (fullDataset{wli, 4} == immediateShallow | fullDataset{wli, 4} == delayedShallow)
        fullDataset(wli, 6) = "Shallow";
      end
      
      if fullDataset{wli, 4} == immediateDeep | fullDataset{wli, 4} == immediateShallow | fullDataset{wli, 4} == delayedDeep | fullDataset{wli, 4} == delayedShallow
        wordlist(pos, :) = fullDataset(wli, :);
        pos = pos + 1;
      end
      
    end
    
    % Name the retention condition of each stimulus in the wordlist 
    if session == 1 | session == 2
      
      for wli = 1:length(wordlist)
        if wordlist{wli, 4} == procedure(IDPos, 3) | wordlist{wli, 4} == procedure(IDPos, 4)
          wordlist(wli, 7) = 'Immediate';
        elseif wordlist{wli, 4} == procedure(IDPos, 5) | wordlist{wli, 4} == procedure(IDPos, 6)
          wordlist(wli, 7) = 'Delayed';
        end
      end
      
    elseif session == 3 | session == 4
      
      for wli = 1:length(wordlist)
        if wordlist{wli, 4} == procedure(IDPos, 7) | wordlist{wli, 4} == procedure(IDPos, 8)
          wordlist(wli, 7) = 'Immediate';
        elseif wordlist{wli, 4} == procedure(IDPos, 9) | wordlist{wli, 4} == procedure(IDPos, 10)
          wordlist(wli, 7) = 'Delayed';
        end
      end
      
    end
    
    
    %% Create seperate lists for the German words and the Swahili counterpart
    % Practice list
    prListDE = listPr(:,1);
    prListSW = listPr(:,2);
    
    % Encoding list
    enListDE = wordlist(:,1);
    enListSW = wordlist(:,2);
    
    % Retrieval list
    reListDE = wordlist(:,1);
    reListSW = wordlist(:,2);
    
    
    %% Find the number of stimulus items and define which positions in the list they are
    % Practice list
    numPracticeitems = sum(strcmp(listPr(:,4), 's'));
    practiceTrials = find(strcmp(listPr(:,4), 's')');
    
    % Encoding list
    numStimulusItems = sum(strcmp(wordlist(:,5), 's'));
    stimuli = find(strcmp(wordlist(:,5), 's')');
    
    
    %% Assign the positions of each word in the list to their condition
    % Find all the stimulus trials based on one condition at a time
    immediateTrials = find(strcmp(wordlist(:,7), 'Immediate')');
    immediateTrials = intersect(stimuli, immediateTrials);  
    delayedTrials = find(strcmp(wordlist(:,7), 'Delayed')');
    delayedTrials = intersect(stimuli, delayedTrials);
    deepTrials = find(strcmp(wordlist(:,6), 'Deep')');
    shallowTrials = find(strcmp(wordlist(:,6), 'Shallow')');
    
    % Define the positions of all retrieval items
    if mod(session, 2) == 1
      retrievalTrials = intersect(stimuli, immediateTrials);
    else  
      retrievalTrials = intersect(stimuli, delayedTrials);
    end
    numRetrievalItems = length(retrievalTrials);
    
    % Define the positions of all the stimuli based on all conditions combined
    immediateDeepStimuli = intersect(deepTrials, immediateTrials);
    immediateShallowStimuli = intersect(shallowTrials, immediateTrials);
    delayedDeepStimuli = intersect(deepTrials, delayedTrials);
    delayedShallowStimuli = intersect(shallowTrials, delayedTrials);
    
    % Define the number of stimuli per condition
    numConditionItems = length(immediateDeepStimuli);
    
    
    %% Define the trials for each block from all the conditions
    % Take 2 words per condition and combine them into different list
    trials1 = horzcat(immediateDeepStimuli(1:2), ...
        immediateShallowStimuli(1:2), ...
        delayedDeepStimuli(1:2), ...
        delayedShallowStimuli(1:2));
    trials2 = horzcat(immediateDeepStimuli(3:4), ...
        immediateShallowStimuli(3:4), ...
        delayedDeepStimuli(3:4), ...
        delayedShallowStimuli(3:4));
    trials3 = horzcat(immediateDeepStimuli(5:6), ...
        immediateShallowStimuli(5:6), ...
        delayedDeepStimuli(5:6), ...
        delayedShallowStimuli(5:6));
    trials4 = horzcat(immediateDeepStimuli(7:8), ...
        immediateShallowStimuli(7:8), ...
        delayedDeepStimuli(7:8), ...
        delayedShallowStimuli(7:8));
    
    % Define the position of each list based on the procedure
    if procedure(IDPos, 11) == 1
    
      block1Trials = trials1;
      block2Trials = trials2;
      block3Trials = trials3;
      block4Trials = trials4;
    
    elseif procedure(IDPos, 11) == 2
    
      block1Trials = trials2;
      block2Trials = trials3;
      block3Trials = trials4;
      block4Trials = trials1;
        
    elseif procedure(IDPos, 11) == 3
    
      block1Trials = trials3;
      block2Trials = trials4;
      block3Trials = trials1;
      block4Trials = trials2;
      
    elseif procedure(IDPos, 11) == 4
    
      block1Trials = trials4;
      block2Trials = trials1;
      block3Trials = trials2;
      block4Trials = trials3;
    
    end
        
    %Define the number of stimuli per block
    numBlockItems = length(block1Trials);
    
    
    %% Set variables for the result file and to monitor correct answers
    runBlock1 = 0;
    runBlock2 = 0;
    runBlock3 = 0;
    runBlock4 = 0;
    correctAnswersDeepBlock1 = 0;
    correctAnswersShallowBlock1 = 0;
    correctAnswersDeepBlock2 = 0;
    correctAnswersShallowBlock2 = 0;
    correctAnswersDeepBlock3 = 0;
    correctAnswersShallowBlock3 = 0;
    correctAnswersDeepBlock4 = 0;
    correctAnswersShallowBlock4 = 0;
    criterionBlock1 = 0;
    criterionBlock2 = 0;
    criterionBlock3 = 0;
    criterionBlock4 = 0;
    abort = 0;
    
    
    %% Set up the output file
    resultsFolder = 'results';                          % Where to save results (Change link if necessary)
    subFolder = participantID;                          % Subfolder name = participant number
    if ~exist([resultsFolder '/' subFolder], 'dir')     % Check if folder exists and create it
        mkdir([resultsFolder]);
        mkdir([resultsFolder '/' subFolder]);
    end
    
    % Create encoding results file
    if mod(session, 2) == 1
      enFilename = [resultsFolder '/' subFolder '/' participantID '_' activityCondition '_encoding_' time '.txt'];
      abortedEnFilename = [resultsFolder '/CANCELLED_' subFolder '/CANCELLED_' participantID '_' activityCondition '_encoding_' time '.txt'];
      
      encodingfile = fopen(enFilename,'a','n');
      fprintf(encodingfile, 'id\t activity\t block\t run\t trial\t encodingStrategy\t retentionInterval\t textItemSw\t textItemDe\t response\t correct\t rt\n');
    end  
    
    % Create retrieval results file
    reFilename = [resultsFolder '/' subFolder '/' participantID '_' activityCondition '_' retentionName '_' time '.txt'];
    abortedReFilename = [resultsFolder '/CANCELLED_' subFolder '/CANCELLED_' participantID '_' activityCondition '_' retentionName '_' time '.txt'];
    
    retrievalfile = fopen(reFilename,'a','n');
    fprintf(retrievalfile, 'id\t activity\t retrievalStrategy\t trial\t encodingStrategy\t retentionInterval\t textItemSw\t textItemDe\t response\t correct\t rt\n');
    
    
    % Setup the experiment for psychtoolbox
    % Keyboard setup and allowed keys
    KbName('UnifyKeyNames');
    KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('Return'),KbName('q'),KbName('1!'),KbName('2@'),KbName('3#'),KbName('4$')];
    RestrictKeysForKbCheck(KbCheckList);
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Get the screen numbers
    screens = Screen('Screens');
    
    % Select the external screen if it is present, else revert to the native screen
    screenNumber = max(screens);
    
    % Define colors
    black = BlackIndex(screenNumber);
    white = WhiteIndex(screenNumber);
    grey = white / 2;
    red = [1 0 0];
    green = [0.16 0.75 0.02];
    lightGrey = [0.70 0.70 0.70];
    lighterGrey = [0.78 0.78 0.78];
    
    % Open an on-screen window and color it grey
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, lighterGrey);
    
    % Calculate slack
    slack = Screen('GetFlipInterval', window)/2;
    
    % Get the size of the on screen window in pixels
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    % Get the centre coordinate of the window in pixels
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Create a textbox for answers
    textBox = [0 0 300 35];
    textBoxPos = CenterRectOnPointd(textBox, xCenter, yCenter+160);
    
    % Create footer
    footerBox = [0 0 screenXpixels 150];
    footerBoxPos = CenterRectOnPointd(footerBox, xCenter, screenYpixels-75);
    
    
    %% Start of the experiment
    %% Introduction to the experiment
    % Choose correct introduction text
    if mod(session, 2) == 1
      introColumns = length(introductionTextImmediate);
      introductionText = introductionTextImmediate;
    else
      introColumns = length(introductionTextDelayed);
      introductionText = introductionTextDelayed;
    end
    
    % Define text size
    Screen('TextSize', window, 30);
    
    % Display text
    for introLength = 1:introColumns
        introText = introductionText{introLength};
        DrawFormattedText(window,introText,'center',yCenter-380+introLength*40);
    end
    
    % Start screen
    Screen('Flip',window);
    
    % Wait for examiner to press q to start next screen
    while 1   
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            Screen('Close');
            break
        end
    end
    
    
    %% Practice trials introduction
    if mod(session, 2) == 1
    
      % Introduction text for practice trials
      practiceColumns = length(practiceIntro);
      
      % Setup screen
      Screen('TextSize', window, 30);
      Screen(window,'FillRect',lightGrey,footerBoxPos);
      Screen('FrameRect',window,grey,footerBoxPos,2);
      
      % Display text
      for introPracticeLength = 1:practiceColumns
          introPracticeText = practiceIntro{introPracticeLength};
          DrawFormattedText(window,introPracticeText,'center',yCenter-200+introPracticeLength*40);
      end
      
      % Add additional text
      DrawFormattedText(window,'Drücken Sie die Leertaste um zu beginnen','center',screenYpixels-75);
      
      % Start screen
      Screen('Flip',window);
      
      % Wait for participant to press space to start practice trials
      while 1
          [~,~,keyCode] = KbCheck;
          if keyCode(KbName('space'))==1
              break
          end
      end
      
      
      %% Practice trials
      % Randomize order of practice trials
      practiceOrder = practiceTrials(randperm(numPracticeitems));
      
      % Present the trials one after another
      for pi = practiceOrder
          
          if strcmp(listPr(pi, 5), 'Deep') == 1   % Deep encoding practice trials
              
              % Display text and answer field
              itemDe = prListDE{pi};
              itemSw = prListSW{pi};
              Screen('TextSize', window, 40);
              Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
              Screen(window,'FillRect',white,textBoxPos);
              Screen('FrameRect',window,black,textBoxPos,2);
              DrawFormattedText(window,itemDe,'center',(yCenter),black);
              Screen('TextSize', window, 25);
              DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
              [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);
              
              %only for octave version
              %answer(! isascii (answer)) = [];
              
              Screen('Flip', window);
              
              % Wait for participant to enter the answer with the return key
              while 1
                  [~,~,keyCode] = KbCheck;
                  if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1 && keyCode(KbName('ESCAPE')) ~= 1  
                      responseTime = GetSecs;
                      break
                  elseif keyCode(KbName('ESCAPE')) == 1         % Quit the experiment with escape
                      fclose(encodingfile);
                      fclose(retrievalfile);
                      movefile(enFilename, abortedEnFilename);
                      movefile(reFilename, abortedReFilename);
                      clear all;
                      close all;
                      sca;
                      return;
                  end
              end
          
          else                                    % Shallow encoding practice trials
              
              % Define the stimuli and the distractors in the list
              prDistAnswers = [pi:(pi+3)];
              prDistAnswerPosition = prDistAnswers(randperm(4));
              
              % Display text and answer field
              itemDe = prListDE{pi};
              itemSw = prListSW{pi};
              Screen('TextSize', window, 40);
              Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
              DrawFormattedText(window,itemDe,'center',(yCenter),black);
              DrawFormattedText(window,strcat('[1]        ', ...
                  prListSW{prDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
              DrawFormattedText(window,strcat('[2]        ', ...
                  prListSW{prDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
              DrawFormattedText(window,strcat('[3]        ', ...
                  prListSW{prDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
              DrawFormattedText(window,strcat('[4]        ', ...
                  prListSW{prDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);
              
              %only for octave version
              %answer(! isascii (answer)) = [];
              
              Screen('Flip', window);
              
              % Wait for participant to enter the answer with the return key
              while 1
                  [~,~,keyCode] = KbCheck;
                  if keyCode(KbName('1!'))==1
                      answer = prListSW{prDistAnswerPosition(1)};
                      responseTime = GetSecs;
                      break
                  elseif keyCode(KbName('2@'))==1
                      answer = prListSW{prDistAnswerPosition(2)};
                      responseTime = GetSecs;
                      break
                  elseif keyCode(KbName('3#'))==1
                      answer = prListSW{prDistAnswerPosition(3)};
                      responseTime = GetSecs;
                      break
                  elseif keyCode(KbName('4$'))==1
                      answer = prListSW{prDistAnswerPosition(4)};
                      responseTime = GetSecs;
                      break
                  elseif keyCode(KbName('ESCAPE')) == 1           % Quit the experiment with escape
                      fclose(encodingfile);
                      fclose(retrievalfile);
                      movefile(enFilename, abortedEnFilename);
                      movefile(reFilename, abortedReFilename);
                      clear all;
                      close all;
                      sca;
                      return;
                  end
              end
          end
          
          % Feedback screens
          if strcmpi(answer,itemSw)                                              % Correct answer feedback
              Screen('TextSize', window, 40);
              Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
              DrawFormattedText(window,'Richtig','center',yCenter-60,green);
              Screen('TextSize', window, 25);
              DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter+60,black);
              Screen('TextSize', window, 40);
              DrawFormattedText(window,itemSw,'center',yCenter+120,black);
              feedbackCorrect = Screen('Flip', window);
              Screen(window, 'FillRect', lighterGrey);
              Screen('Flip', window, feedbackCorrect + 2 - slack,0);
              %Screen('Close');
          else                                                                   % Incorrect answer feedback
              Screen('TextSize', window, 40);
              Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
              DrawFormattedText(window,'Falsch','center',yCenter-180,red);
              Screen('TextSize', window, 25);
              DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter-60,black);
              Screen('TextSize', window, 40);
              DrawFormattedText(window,itemSw,'center','center',black);
              Screen('TextSize', window, 25);
              DrawFormattedText(window,'Ihre Antwort war','center',yCenter+120,black);
              Screen('TextSize', window, 40);
              DrawFormattedText(window,answer,'center',yCenter+180,black);
              feedbackWrong = Screen('Flip', window);
              Screen(window, 'FillRect', lighterGrey);
              Screen('Flip', window, feedbackWrong + 5 - slack,0);
              %Screen('Close');
          end
                  
          % Inter stimulus screen with 0.5s interval
          Screen(window,'FillRect',lighterGrey);
          isiScreen = Screen('Flip',window);
          Screen('Flip', window, isiScreen + 0.5 - slack,0);
          
      end
      
      
      %% Encoding trials introduction
      % Introduction text for encoding trials
      encodingColumns = length(encodingText);
      
      % Set up screen
      Screen(window,'FillRect',lighterGrey);
      Screen('TextSize', window, 30);
      
      % Display text
      for encodingLength = 1:encodingColumns
          introEncodingText = encodingText{encodingLength};
          DrawFormattedText(window,introEncodingText,'center',yCenter-200+encodingLength*40);
      end
      
      % Start screen
      Screen('Flip',window);
      
      % Wait for experimenter to press 'q' to start with encoding
      while 1
          [~,~,keyCode] = KbCheck;
          if keyCode(KbName('q'))==1
              break
          elseif keyCode(KbName('ESCAPE')) == 1               % Quit the experiment with escape
              fclose(encodingfile);
              fclose(retrievalfile);
              movefile(enFilename, abortedEnFilename);
              movefile(reFilename, abortedReFilename);
              clear all;
              close all;
              sca;
              return;
          end
      end
      WaitSecs(1);
      
      
      %% Encoding trials
      % Block 1
      block = 1;
      
      while criterionBlock1 == 0              % Until criterion reached
          
          % Initiate variables for result file and criterion calculations
          trial = 0;        
          runBlock1 = runBlock1+1;
          correctAnswersDeepBlock1 = 0;
          correctAnswersShallowBlock1 = 0;
          
          % Randomize order of stimuli
          block1Order = block1Trials(randperm(numBlockItems));
          
          % Start block
          for b1i = block1Order
              
              % Update variables for result file
              trial = trial + 1;
              startTime = GetSecs;
              retentionInterval = wordlist{b1i,7};
              
              % Set up display for deep trials
              if strcmp(wordlist(b1i,6), 'Deep') == 1
                  
                  % Variable for results file
                  encodingStrategy = 'Deep';
                  
                  % Display text and answer field
                  itemDe = enListDE{b1i};
                  itemSw = enListSW{b1i};
                  Screen('TextSize', window, 40);
                  Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                  Screen(window,'FillRect',white,textBoxPos);
                  Screen('FrameRect',window,black,textBoxPos,2);
                  DrawFormattedText(window,itemDe,'center',(yCenter),black);
                  Screen('TextSize', window, 25);
                  DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
                  [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);

                  %only for octave version
                  %answer(! isascii (answer)) = [];

                  Screen('Flip', window);

                  % Wait for participant to enter the answer with the return key
                  while 1
                      [~,~,keyCode] = KbCheck;
                      if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1
                          responseTime = GetSecs;
                          break
                      elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                          answer = 'Abort';
                          responseTime = GetSecs;
                          abort = 1;
                          criterionBlock1 = 1;
                          rt = responseTime - startTime;
                          fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock1, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                          break
                      end
                  end
              
              % Set up display for shallow trials
              else
                  
                  % Variable for results file
                  encodingStrategy = 'Shallow';
                  
                  % Define positions of stimuli and distractors and randomize positions of answers in mc
                  enDistAnswers = [b1i,(b1i+8),(b1i+16),(b1i+24)];
                  enDistAnswerPosition = enDistAnswers(randperm(4));
                  
                  % Display text and answer field
                  itemDe = enListDE{b1i};
                  itemSw = enListSW{b1i};
                  Screen('TextSize', window, 40);
                  Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                  DrawFormattedText(window,itemDe,'center',(yCenter),black);
                  DrawFormattedText(window,strcat('[1]        ', ...
                    enListSW{enDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
                  DrawFormattedText(window,strcat('[2]        ', ...
                    enListSW{enDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
                  DrawFormattedText(window,strcat('[3]        ', ...
                    enListSW{enDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
                  DrawFormattedText(window,strcat('[4]        ', ...
                    enListSW{enDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);

                  %only for octave version
                  %answer(! isascii (answer)) = [];

                  Screen('Flip', window);

                  % Wait for participant to enter the answer with the return key
                  while 1
                      [~,~,keyCode] = KbCheck;
                      if keyCode(KbName('1!'))==1
                        answer = enListSW{enDistAnswerPosition(1)};
                        responseTime = GetSecs;
                        break              
                      elseif keyCode(KbName('2@'))==1
                        answer = enListSW{enDistAnswerPosition(2)};
                        responseTime = GetSecs;
                        break
                      elseif keyCode(KbName('3#'))==1
                        answer = enListSW{enDistAnswerPosition(3)};
                        responseTime = GetSecs;
                        break
                      elseif keyCode(KbName('4$'))==1
                        answer = enListSW{enDistAnswerPosition(4)};
                        responseTime = GetSecs;
                        break  
                      elseif keyCode(KbName('ESCAPE')) == 1                % Quit the experiment with escape
                          answer = 'Abort';
                          responseTime = GetSecs;
                          abort = 1;
                          criterionBlock1 = 1;
                          rt = responseTime - startTime;
                          fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock1, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                          break 
                      end
                  end
              end
              
              % Skip to retrieval if aborted (Retrieval still has to be finished if aborted due to time limit reached)
              if abort == 1;
                break
              
              % Otherwise show feedback
              else
                % Feedback screens
                if strcmpi(answer,itemSw)                                              % Correct answer feedback
                    
                    if strcmp(encodingStrategy, 'Deep')
                        correctAnswersDeepBlock1 = correctAnswersDeepBlock1 + 1; 
                    elseif strcmp(encodingStrategy, 'Shallow')
                        correctAnswersShallowBlock1 = correctAnswersShallowBlock1 + 1;
                    end
                    
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    DrawFormattedText(window,'Richtig','center',yCenter-60,green);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter+60,black);
                    Screen('TextSize', window, 40);
                    DrawFormattedText(window,itemSw,'center',yCenter+120,black);
                    feedbackCorrect = Screen('Flip', window);
                    Screen(window, 'FillRect', lighterGrey);
                    Screen('Flip', window, feedbackCorrect + 2 - slack,0);
                    %Screen('Close');
                else                                                                        % Incorrect answer feedback
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    DrawFormattedText(window,'Falsch','center',yCenter-180,red);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter-60,black);
                    Screen('TextSize', window, 40);
                    DrawFormattedText(window,itemSw,'center','center',black);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Ihre Antwort war','center',yCenter+120,black);
                    Screen('TextSize', window, 40);
                    DrawFormattedText(window,answer,'center',yCenter+180,black);
                    feedbackWrong = Screen('Flip', window);
                    Screen(window, 'FillRect', lighterGrey);
                    Screen('Flip', window, feedbackWrong + 5 - slack,0);
                    %Screen('Close');
                end
              end
              
              % Calculate response time
              rt = responseTime - startTime;
              
              % Save results to file
              fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                  subID, activityCondition, block, runBlock1, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
              
              % Inter stimulus screen with 0.5s interval
              Screen(window,'FillRect',lighterGrey);
              isiScreen = Screen('Flip',window);
              Screen('Flip', window, isiScreen + 0.5 - slack,0);

          end
          
          % Check if criterion was reached
          if correctAnswersDeepBlock1 >= 3 && correctAnswersShallowBlock1 >= 3
              criterionBlock1 = 1;
          end
          
          % Restart block if criterion was not reached
          if criterionBlock1 == 0
              Screen('TextSize', window, 40);
              % Start screen
              DrawFormattedText(window,'Weiter mit der Leertaste','center','center',black);
              Screen('Flip',window);
          
          % Continue if criterion was reached
          else
              Screen('Close');
          end
          
          % Wait for subject to press spacebar (Only if criterion not reached and block repeated)
          while criterionBlock1 == 0
              [~,~,keyCode] = KbCheck;
              if keyCode(KbName('space'))==1
                  break
              end
          end
          WaitSecs(1);
      end
      
      % Display "after block 1"-text
      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
      DrawFormattedText(window,'Der erste Teil ist geschafft, nun folgt der zweite Teil', ...
          'center',yCenter);
      DrawFormattedText(window,'Weiter mit der Leertaste','center',yCenter + 120,black);
      Screen('Flip',window);
      
      % Wait for subject to press spacebar
      while 1
          [~,~,keyCode] = KbCheck;
          if keyCode(KbName('space'))==1
              break
          end
      end
      WaitSecs(1);
      
      
      % Block 2
      if abort == 0
        block = 2;
        
        while criterionBlock2 == 0
            
            trial = 0;        
            runBlock2 = runBlock2+1;
            correctAnswersDeepBlock2 = 0;
            correctAnswersShallowBlock2 = 0;
            block2Order = block2Trials(randperm(numBlockItems));
        
            for b2i = block2Order
                                
                trial = trial + 1;
                startTime = GetSecs;
                retentionInterval = wordlist{b2i,7};
                
                if strcmp(wordlist(b2i,6), 'Deep') == 1
                    
                    encodingStrategy = 'Deep';
                    
                    % Display text and answer field
                    itemDe = enListDE{b2i};
                    itemSw = enListSW{b2i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    Screen(window,'FillRect',white,textBoxPos);
                    Screen('FrameRect',window,black,textBoxPos,2);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
                    [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1
                            responseTime = GetSecs;
                            break
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock2 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock2, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break
                        end
                    end
                else
                    
                    encodingStrategy = 'Shallow';
                    
                    enDistAnswers = [b2i,(b2i+8),(b2i+16),(b2i+24)];
                    enDistAnswerPosition = enDistAnswers(randperm(4));
                    
                    % Display text and answer field
                    itemDe = enListDE{b2i};
                    itemSw = enListSW{b2i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    DrawFormattedText(window,strcat('[1]        ', ...
                      enListSW{enDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
                    DrawFormattedText(window,strcat('[2]        ', ...
                      enListSW{enDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
                    DrawFormattedText(window,strcat('[3]        ', ...
                      enListSW{enDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
                    DrawFormattedText(window,strcat('[4]        ', ...
                      enListSW{enDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if keyCode(KbName('1!'))==1
                          answer = enListSW{enDistAnswerPosition(1)};
                          responseTime = GetSecs;
                          break              
                        elseif keyCode(KbName('2@'))==1
                          answer = enListSW{enDistAnswerPosition(2)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('3#'))==1
                          answer = enListSW{enDistAnswerPosition(3)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('4$'))==1
                          answer = enListSW{enDistAnswerPosition(4)};
                          responseTime = GetSecs;
                          break  
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock2 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock2, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break 
                        end
                    end
                end

                if abort == 1;
                  break
                else
                  % Feedback screens
                  if strcmpi(answer,itemSw)                                              % Correct answer feedback
                      
                      if strcmp(encodingStrategy, 'Deep')
                          correctAnswersDeepBlock2 = correctAnswersDeepBlock2 + 1; 
                      elseif strcmp(encodingStrategy, 'Shallow')
                          correctAnswersShallowBlock2 = correctAnswersShallowBlock2 + 1;
                      end
                      
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Richtig','center',yCenter-60,green);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter+60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center',yCenter+120,black);
                      feedbackCorrect = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackCorrect + 2 - slack,0);
                      %Screen('Close');
                  else                                                                        % Incorrect answer feedback
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Falsch','center',yCenter-180,red);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter-60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center','center',black);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Ihre Antwort war','center',yCenter+120,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,answer,'center',yCenter+180,black);
                      feedbackWrong = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackWrong + 5 - slack,0);
                      %Screen('Close');
                  end
                end
                
                rt = responseTime - startTime;
                
                % Save results to file
                fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                    subID, activityCondition, block, runBlock2, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                
                
                % Inter stimulus screen with 0.5s interval
                Screen(window,'FillRect',lighterGrey);
                isiScreen = Screen('Flip',window);
                Screen('Flip', window, isiScreen + 0.5 - slack,0);

            end
            
            if correctAnswersDeepBlock2 >= 3 && correctAnswersShallowBlock2 >= 3
                criterionBlock2 = 1;
            end
            
            if criterionBlock2 == 0
                Screen('TextSize', window, 40);
                % Start screen
                DrawFormattedText(window,'Weiter mit der Leertaste','center','center',black);
                Screen('Flip',window);
            else
                Screen('Close');
            end
            
            % Wait for subject to press spacebar
            while criterionBlock2 == 0
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                end
            end
            WaitSecs(1);
        end
        
        %% After block 2 text
        Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
        DrawFormattedText(window,'Der zweite Teil ist geschafft, nun folgt der dritte Teil', ...
            'center',yCenter);
        DrawFormattedText(window,'Weiter mit der Leertaste','center',yCenter + 120,black);
        Screen('Flip',window);
        
        % Wait for subject to press spacebar
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            end
        end
        WaitSecs(1);
      end  
      
      % Block 3
      if abort == 0
      
        block = 3;
        
        while criterionBlock3 == 0
            
            trial = 0;        
            runBlock3 = runBlock3+1;
            correctAnswersDeepBlock3 = 0;
            correctAnswersShallowBlock3 = 0;
            block3Order = block3Trials(randperm(numBlockItems));
        
            for b3i = block3Order
                                
                trial = trial + 1;
                startTime = GetSecs;
                retentionInterval = wordlist{b3i,7};
                
                if strcmp(wordlist(b3i,6), 'Deep') == 1
                    
                    encodingStrategy = 'Deep';
                    
                    % Display text and answer field
                    itemDe = enListDE{b3i};
                    itemSw = enListSW{b3i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    Screen(window,'FillRect',white,textBoxPos);
                    Screen('FrameRect',window,black,textBoxPos,2);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
                    [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1
                            responseTime = GetSecs;
                            break
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock3 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock3, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break
                        end
                    end
                else
                    
                    encodingStrategy = 'Shallow';
                    
                    enDistAnswers = [b3i,(b3i+8),(b3i+16),(b3i+24)];
                    enDistAnswerPosition = enDistAnswers(randperm(4));
                    
                    % Display text and answer field
                    itemDe = enListDE{b3i};
                    itemSw = enListSW{b3i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    DrawFormattedText(window,strcat('[1]        ', ...
                      enListSW{enDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
                    DrawFormattedText(window,strcat('[2]        ', ...
                      enListSW{enDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
                    DrawFormattedText(window,strcat('[3]        ', ...
                      enListSW{enDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
                    DrawFormattedText(window,strcat('[4]        ', ...
                      enListSW{enDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if keyCode(KbName('1!'))==1
                          answer = enListSW{enDistAnswerPosition(1)};
                          responseTime = GetSecs;
                          break              
                        elseif keyCode(KbName('2@'))==1
                          answer = enListSW{enDistAnswerPosition(2)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('3#'))==1
                          answer = enListSW{enDistAnswerPosition(3)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('4$'))==1
                          answer = enListSW{enDistAnswerPosition(4)};
                          responseTime = GetSecs;
                          break  
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock3 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock3, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break 
                        end
                    end
                end

                if abort == 1;
                  break
                else
                  % Feedback screens
                  if strcmpi(answer,itemSw)                                              % Correct answer feedback
                      
                      if strcmp(encodingStrategy, 'Deep')
                          correctAnswersDeepBlock3 = correctAnswersDeepBlock3 + 1; 
                      elseif strcmp(encodingStrategy, 'Shallow')
                          correctAnswersShallowBlock3 = correctAnswersShallowBlock3 + 1;
                      end
                      
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Richtig','center',yCenter-60,green);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter+60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center',yCenter+120,black);
                      feedbackCorrect = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackCorrect + 2 - slack,0);
                      %Screen('Close');
                  else                                                                        % Incorrect answer feedback
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Falsch','center',yCenter-180,red);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter-60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center','center',black);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Ihre Antwort war','center',yCenter+120,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,answer,'center',yCenter+180,black);
                      feedbackWrong = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackWrong + 5 - slack,0);
                      %Screen('Close');
                  end
                end
                
                rt = responseTime - startTime;
                
                % Save results to file
                fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                    subID, activityCondition, block, runBlock3, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                
                
                % Inter stimulus screen with 0.5s interval
                Screen(window,'FillRect',lighterGrey);
                isiScreen = Screen('Flip',window);
                Screen('Flip', window, isiScreen + 0.5 - slack,0);

            end
            
            if correctAnswersDeepBlock3 >= 3 && correctAnswersShallowBlock3 >= 3
                criterionBlock3 = 1;
            end
            
            if criterionBlock3 == 0
                Screen('TextSize', window, 40);
                % Start screen
                DrawFormattedText(window,'Weiter mit der Leertaste','center','center',black);
                Screen('Flip',window);
            else
                Screen('Close');
            end
            
            % Wait for subject to press spacebar
            while criterionBlock3 == 0
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                end
            end
            WaitSecs(1);
        end
        
        %% After block 3 text
        Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
        DrawFormattedText(window,'Der dritte Teil ist geschafft, nun folgt der letzte Teil', ...
            'center',yCenter);
        DrawFormattedText(window,'Weiter mit der Leertaste','center',yCenter + 120,black);
        Screen('Flip',window);
        
        % Wait for subject to press spacebar
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            end
        end
        WaitSecs(1);
      end    
      
      % Block 4
      if abort == 0
      
        block = 4;
        
        while criterionBlock4 == 0
            
            trial = 0;        
            runBlock4 = runBlock4+1;
            correctAnswersDeepBlock4 = 0;
            correctAnswersShallowBlock4 = 0;
            block4Order = block4Trials(randperm(numBlockItems));
        
            for b4i = block4Order
                                
                trial = trial + 1;
                startTime = GetSecs;
                retentionInterval = wordlist{b4i,7};
                
                if strcmp(wordlist(b4i,6), 'Deep') == 1
                    
                    encodingStrategy = 'Deep';
                    
                    % Display text and answer field
                    itemDe = enListDE{b4i};
                    itemSw = enListSW{b4i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    Screen(window,'FillRect',white,textBoxPos);
                    Screen('FrameRect',window,black,textBoxPos,2);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    Screen('TextSize', window, 25);
                    DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
                    [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1
                            responseTime = GetSecs;
                            break
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock4 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock4, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break
                        end
                    end
                else
                    
                    encodingStrategy = 'Shallow';
                    
                    enDistAnswers = [b4i,(b4i+8),(b4i+16),(b4i+24)];
                    enDistAnswerPosition = enDistAnswers(randperm(4));
                    
                    % Display text and answer field
                    itemDe = enListDE{b4i};
                    itemSw = enListSW{b4i};
                    Screen('TextSize', window, 40);
                    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                    DrawFormattedText(window,itemDe,'center',(yCenter),black);
                    DrawFormattedText(window,strcat('[1]        ', ...
                      enListSW{enDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
                    DrawFormattedText(window,strcat('[2]        ', ...
                      enListSW{enDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
                    DrawFormattedText(window,strcat('[3]        ', ...
                      enListSW{enDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
                    DrawFormattedText(window,strcat('[4]        ', ...
                      enListSW{enDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);

                    %only for octave version
                    %answer(! isascii (answer)) = [];

                    Screen('Flip', window);

                    % Wait for participant to enter the answer with the return key
                    while 1
                        [~,~,keyCode] = KbCheck;
                        if keyCode(KbName('1!'))==1
                          answer = enListSW{enDistAnswerPosition(1)};
                          responseTime = GetSecs;
                          break              
                        elseif keyCode(KbName('2@'))==1
                          answer = enListSW{enDistAnswerPosition(2)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('3#'))==1
                          answer = enListSW{enDistAnswerPosition(3)};
                          responseTime = GetSecs;
                          break
                        elseif keyCode(KbName('4$'))==1
                          answer = enListSW{enDistAnswerPosition(4)};
                          responseTime = GetSecs;
                          break  
                        elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                            answer = 'Abort';
                            responseTime = GetSecs;
                            abort = 1;
                            criterionBlock4 = 1;
                            rt = responseTime - startTime;
                            fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                              subID, activityCondition, block, runBlock4, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                            break 
                        end
                    end
                end

                if abort == 1;
                  break
                else
                  % Feedback screens
                  if strcmpi(answer,itemSw)                                              % Correct answer feedback
                      
                      if strcmp(encodingStrategy, 'Deep')
                          correctAnswersDeepBlock4 = correctAnswersDeepBlock4 + 1; 
                      elseif strcmp(encodingStrategy, 'Shallow')
                          correctAnswersShallowBlock4 = correctAnswersShallowBlock4 + 1;
                      end
                      
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Richtig','center',yCenter-60,green);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter+60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center',yCenter+120,black);
                      feedbackCorrect = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackCorrect + 2 - slack,0);
                      %Screen('Close');
                  else                                                                        % Incorrect answer feedback
                      Screen('TextSize', window, 40);
                      Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
                      DrawFormattedText(window,'Falsch','center',yCenter-180,red);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Die korrekte Antwort ist','center',yCenter-60,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,itemSw,'center','center',black);
                      Screen('TextSize', window, 25);
                      DrawFormattedText(window,'Ihre Antwort war','center',yCenter+120,black);
                      Screen('TextSize', window, 40);
                      DrawFormattedText(window,answer,'center',yCenter+180,black);
                      feedbackWrong = Screen('Flip', window);
                      Screen(window, 'FillRect', lighterGrey);
                      Screen('Flip', window, feedbackWrong + 5 - slack,0);
                      %Screen('Close');
                  end
                end
                
                rt = responseTime - startTime;
                
                % Save results to file
                fprintf(encodingfile, '%d\t %s\t %d\t %d\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
                    subID, activityCondition, block, runBlock4, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
                
                
                % Inter stimulus screen with 0.5s interval
                Screen(window,'FillRect',lighterGrey);
                isiScreen = Screen('Flip',window);
                Screen('Flip', window, isiScreen + 0.5 - slack,0);

            end
            
            if correctAnswersDeepBlock4 >= 3 && correctAnswersShallowBlock4 >= 3
                criterionBlock4 = 1;
            end
            
            if criterionBlock4 == 0
                Screen('TextSize', window, 40);
                % Start screen
                DrawFormattedText(window,'Weiter mit der Leertaste','center','center',black);
                Screen('Flip',window);
            else
                Screen('Close');
            end
            
            % Wait for subject to press spacebar
            while criterionBlock4 == 0
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                end
            end
            WaitSecs(1);
        end
      end
      
      
      %% Distractor task
      %Distractor task introduction text
      distractorColumns = length(distractorText);
      
      % Set up screen
      Screen(window,'FillRect',lighterGrey);
      Screen('TextSize', window, 30);

      % Draw text
      for distLength = 1:distractorColumns
          distText = distractorText{distLength};
          DrawFormattedText(window,distText,'center',yCenter-380+distLength*40);
      end
      
      % Start screen
      Screen('Flip',window);
      
      while 1   % Wait for examiner to press q
          [~,~,keyCode] = KbCheck;
          if keyCode(KbName('q'))==1
              Screen('Close');
              break
          end
      end  
      WaitSecs(0.5);
      
      % Add text to distractor task
      DrawFormattedText(window,'In 30 Sekunden geht es automatisch weiter.','center',yCenter,black);
      
      % Flip to the screen
      Screen('Flip', window);
      
      while 1   % Wait for 30 seconds
          WaitSecs(30);
          break
      end
      
      %Screen('Close');
      
      
      %% Retrieval trials introduction
      % Retrieval introduction text
      retrievalColumns = length(retrievalText);
      
      % Set up screen
      Screen('TextSize', window, 30);
      
      % Draw text
      for retrievalLength = 1:retrievalColumns
          retrievalLine = retrievalText{retrievalLength};
          DrawFormattedText(window,retrievalLine,'center',yCenter-140+retrievalLength*40,black);
      end
      
      % Start screen
      Screen('Flip',window);
      
      while 1   % Wait for experimenter to press 'q'
          [~,~,keyCode] = KbCheck;
          if keyCode(KbName('q'))==1
              break
          end
      end
      WaitSecs(1);
      
    end
    
    
    %% Retrieval trials
    %% Cued retrieval
    % Define variables and randomize order
    trial = 0;
    retrievalOrder = retrievalTrials(randperm(numRetrievalItems));
    retrievalStrategy = 'Deep';
    
    for rdi = retrievalOrder
        
        % Update variables
        trial = trial + 1;
        startTime = GetSecs;
        retentionInterval = wordlist{rdi,7};
        
        if strcmp(wordlist(rdi,6), 'Deep') == 1
            encodingStrategy = 'Deep';
        else
            encodingStrategy = 'Shallow';
        end
        
        % Display text and answer field
        itemDe = reListDE{rdi};
        itemSw = reListSW{rdi};
        Screen('TextSize', window, 40);
        Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
        Screen(window,'FillRect',white,textBoxPos);
        Screen('FrameRect',window,black,textBoxPos,2);
        DrawFormattedText(window,itemDe,'center',(yCenter),black);
        Screen('TextSize', window, 25);
        DrawFormattedText(window,'Antwort:','center',(yCenter+125),black);
        [answer, ~] = GetEchoString(window,' ',[xCenter-148],[yCenter+150],black,white);
        
        %only for octave version
        %answer(! isascii (answer)) = [];
        
        Screen('Flip', window);
        
        % Wait for participant to enter the answer with the return key
        while 1
            [~,~,keyCode] = KbCheck;
            if strcat(KbName(keyCode), 'Return') && keyCode(KbName('ESCAPE')) ~= 1
                responseTime = GetSecs;
                break
            elseif keyCode(KbName('ESCAPE')) == 1                                    % Quit the experiment with escape
                fclose("all");
                if mod(session, 2) == 1
                  movefile(enFilename, abortedEnFilename);
                end
                movefile(reFilename, abortedReFilename);
                clear all;
                close all;
                sca;
                return;
            end
        end
        
        % Calculate response time
        rt = responseTime - startTime;
        
        % Save results to file
        fprintf(retrievalfile, '%d\t %s\t %s\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
            subID, activityCondition, retrievalStrategy, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
            
        % Inter stimulus screen with 0.5s interval
        Screen(window,'FillRect',lighterGrey);
        isiScreen = Screen('Flip',window);
        Screen('Flip', window, isiScreen + 0.5 - slack,0);
    end
    
    
    %% MC retrieval
    % Initiate/define variables and randomize order
    trial = 0;
    retrievalOrder = retrievalTrials(randperm(numRetrievalItems));
    retrievalStrategy = 'Shallow';
    
    for rsi = retrievalOrder
        
        % Update variables
        trial = trial + 1;
        startTime = GetSecs;
        retentionInterval = wordlist{rsi,7};
        
        if strcmp(wordlist(rsi,6), 'Deep') == 1
            encodingStrategy = 'Deep';
        else
            encodingStrategy = 'Shallow';
        end
        
        % Find stimulus and distractors and randomize their position in the answer
        reDistAnswers = [rsi,(rsi+8),(rsi+16),(rsi+24)];
        reDistAnswerPosition = reDistAnswers(randperm(4));
                
        % Display text and answer field
        itemDe = reListDE{rsi};
        itemSw = reListSW{rsi};
        Screen('TextSize', window, 40);
        Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
        DrawFormattedText(window,itemDe,'center',(yCenter),black);
        DrawFormattedText(window,strcat('[1]        ', ...
          reListSW{reDistAnswerPosition(1)}),(xCenter-200),(yCenter+175),black);
        DrawFormattedText(window,strcat('[2]        ', ...
          reListSW{reDistAnswerPosition(2)}),(xCenter-200),(yCenter+250),black);
        DrawFormattedText(window,strcat('[3]        ', ...
          reListSW{reDistAnswerPosition(3)}),(xCenter-200),(yCenter+325),black);
        DrawFormattedText(window,strcat('[4]        ', ...
          reListSW{reDistAnswerPosition(4)}),(xCenter-200),(yCenter+400),black);
          
        %only for octave version
        %answer(! isascii (answer)) = [];
        
        Screen('Flip', window);
        
        % Wait for participant to enter the answer with the return key
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('1!'))==1
              answer = reListSW{reDistAnswerPosition(1)};
              responseTime = GetSecs;
              break              
            elseif keyCode(KbName('2@'))==1
              answer = reListSW{reDistAnswerPosition(2)};
              responseTime = GetSecs;
              break
            elseif keyCode(KbName('3#'))==1
              answer = reListSW{reDistAnswerPosition(3)};
              responseTime = GetSecs;
              break
            elseif keyCode(KbName('4$'))==1
              answer = reListSW{reDistAnswerPosition(4)};
              responseTime = GetSecs;
              break  
            elseif keyCode(KbName('ESCAPE')) == 1             % Quit the experiment with escape
                fclose("all");
                if mod(session, 2) == 1
                  movefile(enFilename, abortedEnFilename);
                end
                movefile(reFilename, abortedReFilename);
                clear all;
                close all;
                sca;
                return;
            end
        end
        
        % Calculate response time
        rt = responseTime - startTime;
        
        % Save results to file
        fprintf(retrievalfile, '%d\t %s\t %s\t %d\t %s\t %s\t %s\t %s\t %s\t %d\t %f\n', ...
            subID, activityCondition, retrievalStrategy, trial, encodingStrategy, retentionInterval, itemSw, itemDe, answer, strcmpi(answer,itemSw), rt);
            
        % Inter stimulus screen with 0.5s interval
        Screen(window,'FillRect',lighterGrey);
        isiScreen = Screen('Flip',window);
        Screen('Flip', window, isiScreen + 0.5 - slack,0);
    end
    
    WaitSecs(1);

    
    %% Final screen
    % Set up screen
    Screen('TextSize', window, 40);
    Screen('DrawText',window,' ',xCenter,yCenter,black,lighterGrey);
    
    % Draw text
    DrawFormattedText(window,'Vielen Dank für Ihre Teilnahme', ...
        'center',(yCenter-40),black);
    DrawFormattedText(window,'Drücken Sie die Leertaste um die Aufgabe zu beenden', ...
        'center',(yCenter+40),black);
    
    % Start screen
    Screen('Flip',window);
    
    % Wait for participant to end the experiment with space
    while 1
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            fclose("all");
            sca;
            break
        end
    end
    return
end