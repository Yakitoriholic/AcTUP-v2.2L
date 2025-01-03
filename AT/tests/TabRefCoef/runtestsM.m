% Tabulated Reflection Coefficient test cases
% mbp

bounce( 'neggradB' )   % make the tabulated reflection coefficient

%krakenc( 'neggradC_geo' )   % reference solution (full geoacoustic bottom)
%plotshd( 'neggradC_geo.shd', 3, 1, 1 )
%caxis( [ 60 130 ] ); colorbar( 'horiz' )

%copyfile( 'neggradB.brc', 'neggradC_brc.brc' )  % for KRAKENC input
%krakenc( 'neggradC_brc' )   % using the BRC file
%plotshd( 'neggradC_brc.shd', 3, 1, 2 )
%caxis( [ 60 130 ] ); colorbar( 'horiz' )

%copyfile( 'neggradB.irc', 'neggradC_irc.irc' )  % for KRAKENC input
%krakenc( 'neggradC_irc' )   % using the IRC file
%plotshd( 'neggradC_irc.shd', 3, 1, 3 )
%caxis( [ 60 130 ] ); colorbar( 'horiz' )

scooterM( 'neggradS_geo' )   % reference solution (full geoacoustic bottom)
plotshd( 'neggradS_geo.mat', 3, 1, 1 )
caxis( [ 60 130 ] ); colorbar( 'horiz' )

movefile( 'neggradB.brc', 'neggradS_brc.brc' )  % for KRAKENC input
scooterM( 'neggradS_brc' )   % using the BRC file
plotshd( 'neggradS_brc.mat', 3, 1, 2 )
caxis( [ 60 130 ] ); colorbar( 'horiz' )

scooter( 'neggradS_brc' )   % using the BRC file
plotshd( 'neggradS_brc.mat', 3, 1, 3 )
caxis( [ 60 130 ] ); colorbar( 'horiz' )

%copyfile( 'neggradB.irc', 'neggradS_irc.irc' )  % for KRAKENC input
%scooterM( 'neggradS_irc' )   % using the IRC file
%plotshd( 'neggradS_irc.mat', 3, 1, 3 )
%caxis( [ 60 130 ] ); colorbar( 'horiz' )
