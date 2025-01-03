function [ c, gradc, crr, crz, czz, Layer ]= ssp( x, zSSPV, cSSPV, czV, TopOpt ) 

global Layer 

% ssp
% tabulates the sound speed profile and its derivatives
% also returns a vector Layer indicating the layer a depth point is in

% Layer is a vector of indices indicating the layer that each ray is in
% [zSSPV, sSSPV] contains the depth/sound speed values
% cSSPV is a vector containing the 
% all vectors are set up as column vectors ...

Npts    = length( x( :, 1 ) );
w       = zeros( Npts, 1 ); % weights for interpolation (proportional distance through layer)
LayerTemp   = uint16( zeros( Npts, 1 ) );
Layer       = uint16( zeros( Npts, 1 ) );
%Layer = find( x( :, 2 ) > zSSPV( : ) );

[ z, I ] = sort( x( :, 2 ) );   % sort the rays by depth so that we can identify their layers sequentially

ilayer = 1;
NSSPLayers = length( zSSPV ) - 1;

for iz = 1 : Npts
  while ( z( iz ) > zSSPV( ilayer + 1 ) & ilayer < NSSPLayers )
    ilayer = ilayer + 1;
  end
 LayerTemp( iz ) = ilayer;
end

Layer( I ) = LayerTemp; % re-order info to match original ray sequence
w  = x( :, 2 ) - zSSPV( Layer ); % distance into layer
cz = czV(   Layer );
c  = cSSPV( Layer ) + w .* cz;
  
%c  = interp1( zSSPV, cSSPV, x( :, 2 ), 'spline', 'extrap' );
%cz = interp1( zSSPV( 1:end-1) + HV, czV, x( :, 2 ), 'spline', 'extrap' );

gradc = [ zeros(Npts, 1 ) cz ];
crr   = zeros( Npts, 1 );
crz   = zeros( Npts, 1 );
czz   = zeros( Npts, 1 );
