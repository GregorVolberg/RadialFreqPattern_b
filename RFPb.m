% =======================
% function[] = RFPb(run_mode)
% map tone to figure
% figures are RFPs (varying spikness)
% tones are pure sine and triangular waves
%
% Now contains weighted average over two waveforms to reveal 1.5, 1.7 etc harmonics
% =======================

function[outmat] = RFPb(run_mode)
Screen('Preference', 'SkipSyncTests', 1);

% run_mode = 1; normal experiment
% run_mode = 2; demo with 10 blocks
if ~ismember(run_mode, [1 2])
    error('Wrong runmode argument\n'); end

% set up paths, responses, monitor, ...
addpath('./func');
isOctave = check_octave;
%rawdir = [cd, '\raw\'];
if isOctave
rawdir = [cd, '/raw/'];
else 
rawdir = [cd, '\raw\'];
end

[vp, response_mapping, instruct] = get_experimentInfo(run_mode);
[TastenVector, response_keys] = prepare_responseKeys(response_mapping); % manual responses
MonitorSelection = 3;
MonitorSpecs = getMonitorSpecs(MonitorSelection); % subfunction, gets specification for monitor

%% sound generation 
fade       = 0.02; %fade-in, fade-out
%Freq       = 2200; %in Hz, über conmat!
duration   = 0.8;
%betw_pause = 0.4;
Fs         = 44000; % sampling freq

%% RFP
penwidth = 2;
nvertices = 360*5;

% RFP base form ('Rbase')
br0   = 100;
bA    = 0.2;
%bfrq  = 4; % 2 und 4
%bphi  = pi/2; % rotates
bnodd = 0;   % number of odd harmonics to add (0 for Rbase)

% RFP outline
r0 = 100;
A  = 0.15;
%frq = 20; % (20-30)
phi = 0; % can be constant
%nodd = 5;   % 0 bis 5
            % number of odd harmonics to add
            % set to 0 for sine wave
            % see DOI: 10.1038/srep26681
            % or  https://en.wikipedia.org/wiki/Triangle_wave

bigconmat = get_conmat(); % see subfunction
bigconmat = Shuffle(bigconmat,2); % randomize trial order
% col1: running number
% col2: n odd harmonics (0 to 5)
% col3: waveform, 1 = sine, 2 = triangle
% col4: frequency of RFP base, [3, 4]
% col5: frequency of RFP outline, [20, 30]
% col6: audio frequency, [2000 2200 2400]

ISI = [0.8 1.2];
pahandle = PsychPortAudio('Open');

try
    Priority(1);
    HideCursor;
    [win, ~] = Screen('OpenWindow', MonitorSpecs.ScreenNumber, 127); 

    Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [width, height] = Screen('WindowSize', win)
    hz = Screen('NominalFrameRate', win);
    Screen('Flip', win);
    Screen('TextSize', win, 25); %fontsize 34
    Screen('TextFont', win, 'Helvetica');

    % Construct and start response queue
    KbQueueCreate([],TastenVector);
    KbQueueStart;
    
    blocknum = 0;
    instTexture = Screen('MakeTexture', win, instruct);
    escpress = show_instruction(win, instTexture, run_mode, blocknum);
%escpress=0
    % block loop
    while ~escpress
       
       blocknum = blocknum + 1; 
       tstring = datestr(clock,30);  
       outfilename = [vp, '_', tstring, '.mat'];
       outm = []; 
       WaitSecs(1); 

       conmat = bigconmat(1:48,:); % 12 block with 48 trials each
       bigconmat(1:48,:) = [];

       % trial loop
        for trial = 1:size(conmat, 1)
        
        % prepare stimuli
        snd = get_sound(conmat(trial,3), duration, conmat(trial, 6), fade, Fs);
        PsychPortAudio('DeleteBuffer'); % clear
        PsychPortAudio('FillBuffer', pahandle, snd);
        
        bphi = randsample(-pi:pi,1); % random phase
        sizeFact = randsample(0.7:0.1:1,1); % random phase
        [~, ~, Rbase] = generate_wave(br0*sizeFact, bA, conmat(trial, 4), bnodd, bphi); % base            
        [x, y, ~]     = generate_waveRFPb(Rbase, A, conmat(trial, 5), conmat(trial,2), phi); 
        % use "plot(x, y);" to plot on command line
        polygon = round([x + width/2, y + height/2]);
        Screen('FramePoly', win, [0 0 0], polygon, penwidth);
        
        % present stimuli
        FlipTime = Screen('Flip', win);
        PsychPortAudio('Start', pahandle);
        Screen('Flip', win, FlipTime + duration);
        
        % get response
        [key_code, RT, isRound] = get_behavioralresponse(FlipTime, response_keys);
                
        actISI = randsample((ISI(1)*1000):(ISI(2)*1000),1)/1000;
        WaitSecs(actISI);
   
        outmat(trial,:) = [trial, blocknum, conmat(trial,:), bphi, RT, key_code, isRound, actISI, sizeFact];
        
        end
        
    RFP         = [];
    RFP.vp      = vp;
    RFP.mapping = response_mapping;
    RFP.date    = tstring;
    RFP.block   = blocknum;
    RFP.outmat  = outmat;
    RFP.experiment = 'RFPb';
    RFP.isOctave = isOctave;
    
    
    if run_mode == 1
    save([rawdir, outfilename], 'RFP');
    escpress = show_instruction(win, instTexture, run_mode, blocknum);
  else
    save([rawdir, 'demo'], 'RFP');
        escpress = 1;
    end
    
    end % while
catch
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
Screen('CloseAll');
end

%% =================== subfunctions =========

function [key_code, RT, isRound] = get_behavioralresponse(FlipTime, response_keys)

    KbQueueFlush(); pressed = 0; % flush queue
    while ~pressed           
         [pressed, timevec] = KbQueueCheck; 
    end
[KEYvec, RTvec] = GetBehavioralPerformance(timevec); % get RT; see subfunction
key_code = KEYvec(1);
RT = RTvec(1) - FlipTime;
isRound = key_code == response_keys(1);
end






function [snd] = get_sound(type, duration, Freq, fade, Fs)

t         = (0:(1/Fs):duration-(1/Fs))';
fade_samp = length((0:(1/Fs):fade-(1/Fs)));
fadefunc  = ones(length(t), 1);
fadefunc(1:fade_samp) = linspace(0, 1, fade_samp);
fadefunc(end-fade_samp+1:end) = linspace(1, 0, fade_samp);

if type == 1
snd = sin(2*pi*Freq*t) .* fadefunc;
elseif type == 2
snd = sawtooth(2*pi*Freq*t, 1) .* fadefunc;
else 
    error('Unknown waveform specified in conmat');
end
snd = repmat(snd',2,1); % for PsychAudio
end

function [escpress] = show_instruction(windowPointer, instTexture, run_mode, blocknum)
       if run_mode == 1
       Screen('Flip', windowPointer);
       Screen('DrawTexture', windowPointer, instTexture);
       Screen('Flip', windowPointer); 
       KbQueueFlush();
       [~, keyCode, ~] = KbStrokeWait();
       escpress = (find(keyCode) == KbName('ESCAPE'));
       elseif run_mode == 2
        escpress = 0;
       else
        error('Wrong runmode');
       end
       WaitSecs(0.2);
       Screen('Flip', windowPointer);
end

function [KEYvec, RTvec] = GetBehavioralPerformance(TimeVector)
indi=find(TimeVector); % wo ungleich 0, also responses
[~, i]=sort(TimeVector(indi)); % sortiere nach Zeit
KEYvec = indi(i); % key, aufsteigend nach Zeit
RTvec  = TimeVector(indi(i)); % rt, aufsteigend nach Zeit, relativ zum letzte KbEventFlush
% stop experiment if ESC is pressed
    if ismember(KbName('ESCAPE'), KEYvec) %ESC-taste
       sca; end
end



function [vp, response_mapping, instruct] = get_experimentInfo(run_mode)
if run_mode == 1
  fprintf('\nParticipant (three characters, e.g. S01)?\n');
  vp = input('EINGABE: ', 's');
    if length(vp)~=3 
       error ('Wrong input!'); end
    fprintf('\nResponse mapping?\n1: y = rund,  m = spitz\n2: y = spitz, m = rund\n');   
    response_mapping = str2num(input('EINGABE (1 oder 2): ', 's'));    
      if ~ismember(response_mapping, [1, 2])
        error('\nUnknown mapping!'); end
else
      vp = 'tmp';
      response_mapping = 1;
end

switch response_mapping
    case  1
        instruct = imread('./org/instruction_mapping1.png');
    case  2
        instruct = imread('./org/instruction_mapping2.png');
end
instruct = 255-instruct; instruct(instruct == 255) = 127;
end




function [TastenVector, response_keys] = prepare_responseKeys(response_mapping)
KbName('UnifyKeyNames');
TastenCodes  = KbName({'y','m', 'ESCAPE'}); 
TastenVector = zeros(1,256); TastenVector(TastenCodes) = 1;
if response_mapping == 1
respk_rund = KbName('y');
respk_spitz = KbName('m');
%response_instruction = 'y = Neutral, m = Emotion';
elseif response_mapping == 2
respk_rund = KbName('m');
respk_spitz = KbName('y');
%response_instruction = 'y = Emotion, m = Neutral';
end
response_keys = [respk_rund, respk_spitz]; % 1 = rund, 2 = spitz; for response classification
                                                % response_keys(stim.cond(trial)) == actual_response;
end
