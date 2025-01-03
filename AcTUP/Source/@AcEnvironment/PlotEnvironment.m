function PlotEnvironment(Obj)
%PlotEnvironment           This is Alec's code ... what I've done is replace his original version (commented out below) 
%                          with essentially a cut down version of alec's code for the EnvironmentArray plot routine... 
%
%                          Needs some cleaning up but cannabe right at the minute
%
%                          Both those plot funcitons should have simply been called "plot.m" ... 
%
%
%
%Revision 0.0    ???       AJD
%
%Revision 1.0    25 August 2006 ... ALM moving schtuff from AJD's EnvArr code code

Done = 0;
MenuTxt = {'Plot Cp', 'Plot Cs', 'Plot Density', 'Plot Ap', 'Plot As', 'Done'};
%Always 'Line'
%AllPlotType = {'Pseudo colour',  'Line'};
PlotType = 'Line';
AllPlotRegion = {'Water column', 'Seabed', 'Both'};
Style = {'b', 'r', 'y', 'g', 'm', 'c', 'k', 'b:', 'r:', 'y:', 'g:', 'm:', 'c:', 'k:', ...
   'b--', 'r--', 'y--', 'g--', 'm--', 'c--', 'k--', 'b-.', 'r-.', 'y-.', 'g-.', 'm-.', 'c-.', 'k-.'};
NStyle = length(Style);
IEnv   = 1;

State = 'Menu';
while ~Done
   switch State
      case 'Menu'
         MenuOpt = menu('Environment plotting options', MenuTxt);
         State = MenuTxt{MenuOpt};

      case {'Plot Cp', 'Plot Cs', 'Plot Density', 'Plot Ap', 'Plot As'}
         % ALM - grab next figure number ---------------------         
         [fhdls, currentfig, nextfig, unusedfig] = FindFigures();
         % ALM -----------------------------------------------         
         Ans = inputdlg({'Figure number'}, '', 1, {num2str(nextfig)});
         if ~isempty(Ans)
            FigNum = str2num(Ans{1});
            RegionOpt = menu('Plot data for:', AllPlotRegion);
            PlotRegion = AllPlotRegion{RegionOpt};

            switch State
               case 'Plot Cp',
                  DatType = 'Cp';
                  Label = 'Compressional sound speed (m/s)';
               case 'Plot Cs',
                  DatType = 'Cs';
                  Label = 'Shear sound speed (m/s)';
               case 'Plot Density',
                  DatType = 'Rho';
                  Label = 'Density (kg.m^-^3)';
               case 'Plot Ap',
                  DatType = 'Ap';
                  Label = 'Compressional attenuation (dB/wavelength)';
               case 'Plot As'
                  DatType = 'As';
                  Label = 'Shear attenuation (dB/wavelength)';
            end            
            figure(FigNum);
            GUI_SetupGraphMenu('plot');
            hold on;
            NLayer = GetNumLayers(Obj);
            Data = [];
            Z = [];
            ZOff = 0;
            % ALM - lifted this from 'Pseudo color' option in PlotEnvArr to handle HalfSpaces ... currently plotting single point!!
            HalfspaceZ = 100;  %Plot halfspace this thick
            % --------------------------------------------------------------------------
            switch PlotRegion
               case {'Water column', 'Both'}
                  Layer = GetLayer(Obj, 1);
                  Profile = GetProfile(Layer, DatType, 1);
                  if IsHalfSpace(Layer)
                     Zadd = [ZOff, ZOff+HalfspaceZ] + Profile(1, :);
                     Z    = [Z, Zadd];
                     Data = [Data, ones(size(Zadd)).* Profile(2, :)];
                  else
                     Z = [Z, ZOff + Profile(1, :)];
                     Data = [Data, Profile(2, :)];
                  end
                  ZOff = Z(end)+1e-5;  %Small ofset to prevent interpolation problems
            end
            switch PlotRegion
               case {'Seabed', 'Both'}
                  for ILayer = 2:NLayer
                     Layer = GetLayer(Obj, ILayer);
                     Profile = GetProfile(Layer, DatType, 1);
                     if IsHalfSpace(Layer)
                        Zadd = [ZOff, ZOff+HalfspaceZ] + Profile(1, :);
                        Z    = [Z, Zadd];
                        Data = [Data, ones(size(Zadd)).* Profile(2, :)];
                     else
                        Z = [Z, ZOff + Profile(1, :)];
                        Data = [Data, Profile(2, :)];
                     end
                     ZOff = Z(end)+1e-5;  %Small ofset to prevent interpolation problems
                  end
            end
            IStyle = mod((IEnv-1), NStyle) + 1;
            plot(Data, Z, Style{IStyle});
            xlabel(Label)
            ylabel('Depth (m)');
            view(0, -90);
            
         end
         State = 'Menu';

      case 'Done'
         Done = 1;
   end
end




% Ans = inputdlg({'Figure number'}, '', 1, {num2str(gcf)});
% if ~isempty(Ans)
%    figure(str2num(Ans{1}));
%    clf;
%    if exist('GUI_SetupGraphMenu.m', 'file');
%       GUI_SetupGraphMenu('plot');
%    end
%    
%    MinArr = [];
%    MaxArr = [];
%    
%    NLayers = length(Obj.LayerArr);
%    ZTop = 0;
%    for ILayer = 1:NLayers
%       [NPlt, XLabels, MinVals, MaxVals] = PlotLayer(Obj.LayerArr{ILayer}, ZTop);
%       MinArr = [MinArr; MinVals];
%       MaxArr = [MaxArr; MaxVals];
%       
%       ZTop = ZTop + GetLayerThickness(Obj.LayerArr{ILayer});
%    end
%    AllMin = min(MinArr);
%    AllMax = max(MaxArr);
%    
%    for IPlt = 1:NPlt
%       subplot(1, NPlt, IPlt);
%       xlabel(XLabels{IPlt});
%       view(0, -90);
%       LowLim = 0.9*AllMin(IPlt);
%       HighLim = 1.1*AllMax(IPlt);
%       if LowLim == 0
%           if HighLim == 0
%               LowLim = -1;
%               HighLim = 1;
%           else
%               LowLim = -0.1*HighLim;
%           end
%       end
%       axis([LowLim HighLim -inf inf]);
%    end
%    
%    subplot(1,NPlt, 1);
%    ylabel('Depth (m)');
%    
%    subplot(1,NPlt,ceil(NPlt/2));
%    title(Obj.Name, 'FontSize', 12);
% end
