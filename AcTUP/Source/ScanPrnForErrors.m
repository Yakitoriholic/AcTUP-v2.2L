function ErrType = ScanPrnForErrors(FName)
%Scans a log file generated by Mike Porter's acoustic toolbox programs for warnings and fatal errors
%and displays the error message in a dialog box.
%
%ErrType is 0 if no errors, 1 if one or more warnings are found and 2 if a fatal error is found
%
% Revision 0.1    13 October 2004 ... ALM
%                 - Change line search from "strncmp" to "findstr" since the RAMGeo executable (FORTRAN)
%                   seems to do odd things like add a leading space to the write o/p
%                   Aside - strfind is nearly the same as findstr the latter is ip order independent and not suitable for this app

MaxMsg = 10;   %Maximum number of messages that will be displayed

ErrTag = '*** FATAL ERROR ***';   %String output by Mike's error handler (errout) for a fatal error
WarnTag = '*** WARNING ***';  %String output for a warning
ExtraLineTag = 'Error handler (ERROUT) called with unknown severity level';

ErrType = 0;
ErrMsg{1} = ['Errors and/or warnings detected in file: ' FName];

Abort = 0;

[FileID, Msg] = fopen(FName, 'rt');

MsgCount = 0;

if ~ischar(FileID) & (FileID == -1)
   ErrMsg = lAppendMsg(ErrMsg, Msg);
   MsgCount = MsgCount + 1;
   ErrType = 2;
   Abort = 1;
end

if ~Abort
   Done = 0;
   
   while ~Done
      [Line, Done] = lReadLine(FileID);
      if ~Done
         %Revision 0.1 - replace strncmp with strfind 
         %if strncmp(Line, ErrTag, length(ErrTag));
         Eidx = strfind(Line, ErrTag );
         Widx = strfind(Line, WarnTag);
         if ~isempty(Eidx)
            %Fatal error detected
            ErrType = 2;
            [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg);  %This line should either be blank or the extra line tag
            if ~Done
               %If the error handler is passed an unknown severity level there it outputs an extra line
               if strncmp(Line, ExtraLineTag, length(ExtraLineTag))
                  [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg);  %This line should be blank
               end
            end
            
            if ~Done
               [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg); %This line should contain the module info
            end
            
            if ~Done
               ErrMsg = lAppendMsg(ErrMsg, ' ');
               ErrMsg = lAppendMsg(ErrMsg, ['ERROR: ' Line]);
               MsgCount = MsgCount + 1;

               [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg); %This line should contain the error message
            end
            
            if ~Done
               ErrMsg = lAppendMsg(ErrMsg, Line);
            end
            
         %Revision 0.1 
         %elseif strncmp(Line, WarnTag, length(WarnTag))
         elseif ~isempty(Widx)
            %Warning detected
            if ErrType < 1
               ErrType = 1;
            end

            [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg);   %This line should be blank

            if ~Done
               [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg); %This line should contain the module info
            end

            if ~Done
               ErrMsg = lAppendMsg(ErrMsg, ' ');
               ErrMsg = lAppendMsg(ErrMsg, ['WARNING: ' Line]);
               [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg); %This line should contain the error message
               MsgCount = MsgCount + 1;

            end

            if ~Done
               ErrMsg = lAppendMsg(ErrMsg, Line);
            end
         end
         if MsgCount >= MaxMsg
             ErrMsg = lAppendMsg(ErrMsg, '...');
             Done = 1;
         end
      end
   end
end

if ErrType ~= 0
    h = warndlg(ErrMsg);
   uiwait(h);
end

% Revision 0.1 
% it was THESE files that were being left open and preventing moving/copying etc ... 
fclose(FileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ErrMsg = lAppendMsg(ErrMsg, ThisMsg)
Index = length(ErrMsg) + 1;
ErrMsg{Index} = ThisMsg;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Line, Done, ErrMsg] = lReadLine(FileID, ErrMsg)
Line = fgetl(FileID);
if ~isempty(Line) & ~ischar(Line) & (Line == -1)
   Done = 1;
   if nargin >= 2
      ErrMsg = lAppendMsg(ErrMsg, 'ERROR: unknown error');
   end
else
   Done = 0;
end


