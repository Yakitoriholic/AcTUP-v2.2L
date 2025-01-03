function fig = DrawEditGUI(Obj)

%load EditGUI
	%'Colormap',mat0, ...
	%'PointerShapeCData',mat1, ...

%Figure window
h0 = figure('Color',[0.8 0.8 0.8], ...
	'Units','points', ...
	'MenuBar','none', ...
	'Name','Edit acoustic environment array', ...
	'Position',[200 100 330 300], ...
	'Tag','Fig1');

MyData.IsDone = 0;
MyData.IsOK = 0;
MyData.Obj = Obj;
set(h0, 'UserData', MyData);

%Static text - environment name
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[33 285 171.75 13.5], ...
	'String','Acoustic environment array name:', ...
	'Style','text', ...
   'Tag','StaticText1');

%Name edit control
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[33 270 172.5 15], ...
   'Style','edit', ...
   'String', Obj.Name, ...
   'HorizontalAlignment', 'left', ...
   'Tag','AcEnvArrName');
   
%Static text - Range interpolation step
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[33 235 171.75 23], ...
	'String','Range step for interpolating acoustic environments (m), 0 for no interpolation:', ...
	'Style','text', ...
   'Tag','RInterpLabel');

%Range interpolation edit control
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[33 220 172.5 15], ...
   'Style','edit', ...
   'String', num2str(Obj.dRInterp), ...
   'HorizontalAlignment', 'left', ...
   'Tag','RInterp');


%Static text - environment list title
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[33 190 150 23], ...
	'String','Range, Environment (range independent codes use first in list)', ...
	'Style','text', ...
   'Tag','StaticText2');

%List of current environments
Str = GetEnvironmentNames(Obj);
NEnv = length(Obj.RangeVec);
for IEnv = 1:NEnv
    Str{IEnv} = [num2str(Obj.RangeVec(IEnv)), 'm,  ', Str{IEnv}];
end

h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','AcEnvArrCallback', ...
	'Position',[30 50 175 140], ...
	'String', Str, ...
	'Style','listbox', ...
	'Tag','EnvList', ...
   'Value',1);


ButWidth = 100;
ButHeight = 15;

%Edit button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 185 ButWidth ButHeight], ...
	'String','Edit environment', ...
   'Tag','EditEnv');

%Delete environment button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 165 ButWidth ButHeight], ...
	'String','Delete environment', ...
   'Tag','DeleteEnv');

%Insert before button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 130 ButWidth ButHeight], ...
	'String','Insert environment before', ...
   'Tag','InsertBefore');

%Insert after button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 110 ButWidth ButHeight], ...
	'String','Insert environment after', ...
   'Tag','InsertAfter');

%Move environment up button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 75 ButWidth ButHeight], ...
	'String','Move environment up', ...
   'Tag','MoveUp');

%Move environment down button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[220 55 ButWidth ButHeight], ...
	'String','Move environment down', ...
   'Tag','MoveDown');

%OK button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[162 16.5 45 ButHeight], ...
	'String','OK', ...
   'Tag','OKButton');

%Cancel button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','AcEnvArrCallback', ...
	'ListboxTop',0, ...
	'Position',[34.5 15.75 45 ButHeight], ...
	'String','Cancel', ...
	'Tag','CancelButton');
if nargout > 0, fig = h0; end
