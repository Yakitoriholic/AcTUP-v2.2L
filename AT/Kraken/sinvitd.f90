!     Last change:  MBP   3 Mar 2001    6:26 pm
      SUBROUTINE SINVIT( N, D, E, IERR, RV1, RV2, RV3, RV4, RV6 ) 
                                                                        
!     Michael B. Porter 7/1/85                                          
                                                                        
!     This subroutine is a modified version of TINVIT in EISPACK                 
!     specialized to the case where we only want a single vector.                                     
                                                                        
!     WARNING: Very probably this routine will fail for              
!     certain difficult cases for which the original tinvit would       
!     not.  For instance, problems with nearly degenerate eigenvectors  
!     or separable problems.                       

!     Refer to the ALGOL procedure TRISTURM by Peters and Wilkinson.    
!     Handbook for Auto. Comp., VOL.II-Linear Algebra, 418-439(1971).   
                                                                        
!     This subroutine finds the eigenvector of a singular, tridiagonal  
!     symmetric matrix corresponding to the zero eigenvalue, using inverse iteration.                                          
                                                                        
!     On input           
!        N is the order of the matrix.                                  
!        D contains the diagonal elements of the input matrix.          
!        E contains the subdiagonal elements of the input matrix        
!          in its last N-1 positions.  E(1), E(N+1) are arbitrary.      
                                                                        
!     On output                                                         
!        All input arrays are unaltered.                                
!        RV6 contains the eigenvector.                                  
!          Any vector which fails to converge is set to zero.           
!        IERR is set to                                                 
!           0       For normal return,                                  
!          -1       If the eigenvector fails to converge in 5 iterations
                                                                        
!        RV1, RV2, RV3, RV4, and RV6 are temporary storage arrays.      

      PARAMETER ( MAXIT = 5 )
                                                                        
      INTEGER I, IERR, N 
      REAL (KIND=8) :: EPS3, EPS4, NORM, U, UK, V, XU, D( N ), E( N+1 ),              &
         RV1( N ), RV2( N ), RV3( N ), RV4( N ), RV6( N )                     
                                                      
      IERR = 0 

!     --- Compute (infinity) norm of matrix                             
!     (this could be pre-calculated for addl speed ...)                 
                                                                        
      NORM = SUM( ABS( D ) ) + SUM( ABS( E( 2:N ) ) )
                                                                        
      EPS3 = 1.0E6 * EPSILON( NORM ) * NORM  ! small number that replaces zero pivots
      UK   = N 
      EPS4 = UK * EPS3   ! small number used in scaling down the iterates
      UK   = EPS4 / DSQRT( UK ) 
                                                                        
!     *** Elimination with interchanges ***                             
                                                                        
      XU = 1.0 
      U  = D( 1 ) 
      V  = E( 2 ) 
                                                                        
      DO I = 2, N
         IF ( ABS( E( I ) ) >= ABS( U ) ) THEN
            XU = U / E( I ) 
            RV4( I   ) = XU 
            RV1( I-1 ) = E( I ) 
            RV2( I-1 ) = D( I ) 
            RV3( I-1 ) = E( I+1 ) 
            U = V - XU * RV2( I-1 ) 
            V =   - XU * RV3( I-1 ) 
         ELSE 
            XU = E( I ) / U 
            RV4( I     ) = XU
            RV1( I - 1 ) = U
            RV2( I - 1 ) = V
            RV3( I - 1 ) = 0.0
            U = D( I ) - XU * V 
            V = E( I + 1 )
         ENDIF
      END DO 
                                                                        
      IF ( U == 0.0 ) U = EPS3 
                                                                        
      RV3( N-1 ) = 0.0 
      RV1( N   ) = U 
      RV2( N   ) = 0.0 
      RV3( N   ) = 0.0 
                                                                        
!     *** Main loop of inverse iteration ***
                                                                        
      RV6 = UK
                                                                        
      DO ITER = 1, MAXIT 
                                                                        
!        ***  Back substitution                                         
         DO I = N, 1, -1

            RV6( I ) = ( RV6( I ) - U * RV2( I ) - V * RV3( I ) ) / RV1( I )
            V = U 
            U = RV6( I )
         END DO
                                                                        
!        *** Compute norm of vector and test for doneness               
                                                                        
         NORM = SUM( ABS( RV6 ) )
         IF ( NORM >= 1.0 ) RETURN 
                                                                        
!        --- Scale the vector down                                      
         XU = EPS4 / NORM 
         RV6 = RV6 * XU
                                                                        
!        --- Forward elimination                                        
                                                                        
         DO I = 2, N 
            U = RV6( I ) 
                                                                        
!           --- IF RV1(I-1) = E(I), rows switched during triangularization
                                                                        
            IF ( RV1( I-1 ) == E( I ) ) THEN 
               U          = RV6( I-1 ) 
               RV6( I-1 ) = RV6( I   ) 
            ENDIF 
            RV6( I ) = U - RV4( I ) * RV6( I-1 )
         END DO 

      END DO   ! next iteration
                                                                        
!     *** Fall through the loop means failure to converge               
                                                                        
      IERR = -1 
      RETURN 
                                                                        
      END                                           
