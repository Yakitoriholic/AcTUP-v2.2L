function [ F, G, IPow ] = bcimp( B1, B2, B3, B4, rho, X, BCType, BotTop, cpHS, csHS, rhoHS, cIns, rhoIns )

%     Compute Boundary Condition IMPedance

global omega sigma NMedia N NFirstAcoustic NLastAcoustic
global thetaBot RBot phiBot NBotPts thetaTop RTop phiTop NTopPts

IPow   = 0;
omega2 = omega^2;

% compute impedance for specified boundary type

switch BCType(1:1)
case 'V'  % Vacuum with Kirchoff roughness
   F     = 1.0;
   G     = -i * sqrt( omega2 / cIns ^ 2 - X ) * sigma( 1 ) ^ 2;
   YV = [ F G 0 0 0];
case { 'S', 'H', 'T', 'I' }  % Vacuum with Twersky scatter model
   omega = sqrt( omega2 );
   KX    = sqrt( X );
   F     = 1.0;
   C0    = real( cIns );
   G     = Twersk( BCType, omega, BumDen, xi, eta, KX, rhoIns, C0 );
   G     = G / ( i * omega * rhoIns );
   YV = [ F G 0 0 0];
case 'R'   % Rigid
   F     = 0.0;
   G     = 1.0;
   YV = [ F G 0 0 0];
case 'A' %     *** Acousto-elastic half-space ***
   if ( real( csHS ) > 0.0 )
      gammaS2 = X - omega2 / csHS ^ 2;
      gammaP2 = X - omega2 / cpHS ^ 2;
      gammaS  = sqrt( gammaS2 );
      gammaP  = sqrt( gammaP2 );
      RMU   = rhoHS * csHS ^ 2;
      
      YV(1) = ( gammaS*gammaP - X ) / RMU;
      YV(2) = ( ( gammaS2 + X ) ^ 2 - 4.0 * gammaS * gammaP * X ) * RMU;
      YV(3) = 2.0*gammaS*gammaP - gammaS2 - X;
      YV(4) = gammaP * ( X - gammaS2 );
      YV(5) = gammaS * ( gammaS2 - X );
      
      F = omega2 * YV( 4 );
      G = YV( 2 );
   else
      gammaP = sqrt( X - omega2 / cpHS^2 );
      F    = 1.0;
      G    = rhoHS / gammaP;
   end
case 'F'   %     *** Tabulated reflection coefficient ***
   % Compute the grazing angle Theta
   kx     = sqrt( X );
   kz     = sqrt( omega2 / cIns^2 - kx^2 );
   RadDeg = 180.0 / pi;
   thetaInt = RadDeg * atan2( real( kz ), real( kx ) );

   % Evaluate R( TheInt )
   if ( strcmp( BotTop(1:3), 'TOP' ) )
      RInt   = interp1( thetaTop, RTop,   real( thetaInt ), 'linear', 'extrap' );   % Linear interpolation for reflection amplitude
      phiInt = interp1( thetaTop, phiTop, real( thetaInt ), 'linear', 'extrap' );   % Linear interpolation for reflection phase

   else
      RInt   = interp1( thetaBot, RBot,   real( thetaInt ), 'linear', 'extrap' );   % Linear interpolation for reflection amplitude
      phiInt = interp1( thetaBot, phiBot, real( thetaInt ), 'linear', 'extrap' );   % Linear interpolation for reflection phase
   end
   % Convert R( Theta ) to (f,g) in Robin BC
   RCmplx = RInt * exp( i * phiInt );
   F      = 1.0;
   G      = ( 1.0 + RCmplx ) / ( i * kz * ( 1.0 - RCmplx ) );
case 'P'       % Precalculated reflection coef
   IRCInt( X, F, G, IPow, XTab, FTab, GTab, ITab, NkPtsTab )
   'following added when select/case used, following lines had appeared before this ...'
   G = -G;
end

%  *** Shoot through elastic layers ***
if ( strcmp( BotTop(1:3), 'TOP' ) )
   G = -G;   % top BC has the sign flipped relative to a bottom BC
   if ( NFirstAcoustic > 1 )
      for Medium = 1 : NFirstAcoustic - 1  	 	% Shooting down from top
         [ YV, IPow ] = elasdn( B1, B2, B3, B4, rho, X, YV, IPow, Medium );
      end
      F = omega2 * YV( 4 );
      G = YV( 2 );
   end
else
   if ( NLastAcoustic < NMedia )
      for Medium = NMedia : -1 : NLastAcoustic + 1  	% Shooting up from bottom
         [ YV, IPow ] = elasup( B1, B2, B3, B4, rho, X, YV, IPow, Medium );
      end
      F = omega2 * YV( 4 );
      G = YV( 2 );
   end
end
