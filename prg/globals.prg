//------------------------------------------------------------------------------
//	MODULE IMPORTS
//------------------------------------------------------------------------------

import "mod_mem";

//------------------------------------------------------------------------------
//	TYPE DEFINITIONS
//------------------------------------------------------------------------------

TYPE _tsmap

	// map dimensions
	int layers;
	int width;
	int height;
	
	// fpg id of every layer
	int pointer fpg;
	
	// tiles data ( tile[ (layer * width * height) + (y * width) + x ] )
	int pointer tile;
	
END

//------------------------------------------------------------------------------
//	GLOBALS
//------------------------------------------------------------------------------

GLOBAL

	// scroll configuration
	STRUCT ts
		
		// drawing start point (point on screen)
		int start_x;
		int start_y;
		
		// drawing end point (punto en pantalla)
		int end_x;
		int end_y;
		
		// tiles count
		int tiles_x;
		int tiles_y;
		
		// scroll position
		int pos_x;
		int pos_y;
		
		// scroll limit
		int limit_x;
		int limit_y;

		// tile size and scale
		int tsize;
		int scale;

		// if of every tile on screen
		int pointer tile_id;

		// flag indicates if the scroll must be redrawn
		int draw;

		// shows debug info
		int debuginfo;
		
	END

END
