function bounceM( filename )

% Wavenumber integration code for ocean acoustics problems
% Based on the earlier Fortran version
% MBP Dec. 24, 2003

clear global
tic

if ( isempty( filename ) )
    warndlg( 'No envfil has been selected', 'Warning' );
end

global omega Bdry
global NMedia N depth NFirstAcoustic NLastAcoustic H

% read in the environmental file
envfil = [ filename '.env' ];
shdfil = [ filename '.mat' ];   % output file name

[ PlotTitle, freq, Bdry, fid ] = readenv( envfil );
PlotTitle = ['BOUNCE(M) -' PlotTitle ];

% phase speed limits
cLow   = fscanf( fid, '%f', 1 );
cHigh  = fscanf( fid, '%f', 1 );
fprintf( '\n cLow = %8.1f cHigh = %8.1f \n', cLow, cHigh )
fgetl( fid );

% read max range, Rmax
RMax  = fscanf( fid, '%f', 1 );
fprintf( 'RMax = %f \n', RMax )
fclose( fid );      % close out the envfil

readrc( TopOpt(2:2), BotOpt(1:1) );   % READ Reflection Coefficients (top and bottom)

omega  = 2 * pi * freq;
omega2 = omega^2;

% Set up vector of wavenumber samples
kMin = omega / cHigh;
kMax = omega / cLow;

NkPts = floor( 1000.0 * RMax * ( kMax - kMin ) / pi );
fprintf( '\n Number of wavenumbers, NkPts = %i \n', NkPts )

% Set-up the vector of k-space points
DeltaK = ( kMax - kMin ) / ( NkPts - 1 );
atten  = DeltaK;
rk     = linspace( kMin, kMax, NkPts );

H( 1:NMedia ) = ( depth( 2:NMedia + 1 ) - depth( 1:NMedia ) ) ./ N( 1:NMedia );   % vector of mesh widths
NptsAll       = sum( N( 1:NMedia ) ) + NMedia;   % number of solution points

[ B1, B2, B3, B4, rho ] = init_matrix( NptsAll );    % Initialize matrices
NptsAcoustic = sum( N( NFirstAcoustic:NLastAcoustic ) ) + 1;   % size of matrix for acoustic part
Green = kernel( B1, B2, B3, B4, rho, NptsAll, rk, atten, NptsAcoustic );

% save Green's function
FileName = 'GRNFIL';
PlotType = 'Green';
XS = 0.0   ;   YS = 0.0   ;   Theta = 0.0;

%figure; imagesc( rk, rd, 20 * log10( abs( Green ) ) )
%caxis( [ -110 -60 ] );colorbar
%save GRNFIL PlotTitle freq atten sd Nsd rd Nrd rk NkPts Green
toc
