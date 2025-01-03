function SrcBmPat = readpat( sbpfil, SBP )
% reads in a source beam pattern

if ( SBP == '*' )
    disp( '*********************************' )
    disp( 'Using source beam pattern file' )
    fid = fopen( sbpfil, 'r' );
    NSBPPts = fscanf( fid, '%i', 1 );
    fprintf( 'Number of source beam pattern points = %i \n', NSBPPts )
    SrcBmPat = zeros( NSBPPts, 2 );
    disp( ' ' );
    disp( ' Angle (degrees)  Power (dB)' )

    for I = 1 : NSBPPts
        SrcBmPat( I, : ) = fscanf(  fid, '%f %f ', 2 );
        fprintf( ' %f         %f \n', SrcBmPat( I, : ) )
    end
    fclose( fid );
else   % no pattern given, use omni source pattern
    SrcBmPat = zeros( 2, 2 );
    SrcBmPat( 1, : ) = [ -180.0, 0.0 ];
    SrcBmPat( 2, : ) = [  180.0, 0.0 ];
end

SrcBmPat( :, 2 ) = 10 .^ ( SrcBmPat( :, 2 ) / 20 );  % convert dB to linear scale


