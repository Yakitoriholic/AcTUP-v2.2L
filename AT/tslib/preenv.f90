SUBROUTINE PREENV( X, N )

  ! Forms the pre-envelope of the function
  ! Real( X( N ) ) is the input time series
  ! The output vector is complex
  ! N must be a power of 2 and <16384

  COMPLEX X( * )

  !  Check N is a power of 2

  IF ( N <= 0 ) STOP 'FATAL ERROR in PREENV: N must be positive'

  NT = 2**( INT( LOG10(REAL(N)) / 0.30104 ) +1 )
  IF ( NT /= N ) STOP 'FATAL ERROR in PREENV: N must be a power of 2'

  CALL CFFT(   X, N, 1 )   ! forward Fourier transform
  CALL CFFTSC( X, N )      ! scaled appropriately

  ! *** Zero-out the negative spectrum (the upper N/2 positions) ***

  IMID = N / 2
  X( IMID+1:N ) = 0.0

  CALL CFFT( X, N, -1 )   ! inverse Fourier transform

  RETURN
END SUBROUTINE PREENV
