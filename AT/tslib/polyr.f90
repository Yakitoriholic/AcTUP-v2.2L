FUNCTION PR( X0, X, F, N, ERRMSG )

  ! Polynomial approximant at X0
  ! Limited to N = 10

  PARAMETER ( MAXN = 10 )
  REAL X0, X( N ), F( N ), FT( MAXN ), H( MAXN )
  CHARACTER*80 ERRMSG

  ERRMSG = ' '

  ! Initialize arrays

  H  = X - X0
  FT = F

  ! Recursion for solution
  IF ( N >= 2) THEN
     DO I = 1, N - 1
        DO J = 1, N - I
           FT(J) = ( H( J + I ) * FT( J ) - H( J ) * FT( J + 1 ) ) / &
                &            ( H( J + I ) - H( J ) )
        END DO
     END DO
  ENDIF

  PR = FT( 1 )

  RETURN
END FUNCTION PR
