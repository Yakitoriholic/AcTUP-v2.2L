function Status = GUI_GInputQuery(Text)
%Status = GUI_GInputQuery(Text)
%Status = 1 if Continue pressed, 0 if cancel pressed

ContinueString='set(gcbf,''UserData'',''Continue'');uiresume';
CancelString='set(gcbf,''UserData'',''Cancel'');uiresume';

   h0 = figure('Units','points', ...
      'NumberTitle', 'off', ...
   'Name', 'Values:', ...
   'Position',[312 300 232.5 102.75], ...
	'WindowStyle', 'modal',...
	'Tag','Fig2');
h1 = uicontrol('Parent',h0, ...
   'Units','points', ...
   'FontSize', 12, ...
   'FontWeight', 'bold', ...
   'FontName', 'Times New Roman', ...
	'ListboxTop',0, ...
	'Position',[15 35.75 200.25 60.25], ...
	'Style','text', 'String', Text, ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback', ContinueString, ...
	'ListboxTop',0, ...
	'Position',[15 7.5 45 15], ...
	'String', 'Continue', ...
	'Tag','GInputContinue');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback', CancelString, ...
	'ListboxTop',0, ...
	'Position',[170.25 7.5 45 15], ...
	'String','Cancel', ...
	'Tag','GInputCancel');

uiwait(h0);

if ishandle(h0)
   Status = strcmp(get(h0,'UserData'),'Continue');
   delete(h0);
else
   Status = 0;
end
