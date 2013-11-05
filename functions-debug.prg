//------------------------------------------------------------------------------
//	FUNCTIONS - DEBUG
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// Moves the scroll
// (DEBUG)
//
PROCESS tsDebugMove(int vel)

BEGIN

	LOOP
	
		IF ( ts.debuginfo )

			IF ( key(_RIGHT))
				ts.pos_x+=vel;
				ts.draw = TRUE;
			END
			
			IF ( key(_LEFT) )
				ts.pos_x-=vel;
				ts.draw = TRUE;
			END
			
			IF ( key(_DOWN) )
				ts.pos_y+=vel;
				ts.draw = TRUE;
			END
			
			IF ( key(_UP) )
				ts.pos_y-=vel;
				ts.draw = TRUE;
			END
			
		
			frame;

		END
		
	END

END
