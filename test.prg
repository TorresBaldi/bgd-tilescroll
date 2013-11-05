import "mod_debug";
import "mod_draw";
import "mod_file";
import "mod_grproc";
import "mod_joy";
import "mod_key";
import "mod_map";
import "mod_math";
import "mod_proc";
import "mod_rand";
import "mod_say";
import "mod_screen";
import "mod_string";
import "mod_scroll";
import "mod_sound";
import "mod_text";
import "mod_time";
import "mod_video";
import "mod_wm";

/*------------------------------------------------------------------------------*/

include "tilescroll.prg";

/*------------------------------------------------------------------------------*/

GLOBAL

	_tsmap example_tilemap;
	
	int map_layers = 3;
	int map_width = 700;
	int map_height = 700;
	
	mouse_tile_x;
	mouse_tile_y;

END

BEGIN

	set_mode(640,480,32,mode_window);
	set_fps(0,0);
	write_var( 0,0,0,0, fps );
	
	write_var( 0, 0, 20, 0, mouse_tile_x );
	write_var( 0, 0, 30, 0, mouse_tile_y );

	// shows debug info
	ts.debuginfo = true;
	
	// variable initialization
	tsMapAlloc( example_tilemap, map_layers, map_width, map_height );
		
	// fills the map with random values
	FOR ( z=0; z<example_tilemap.layers; z++ )
		FOR (x=0; x<example_tilemap.width; x++)
			FOR (y=0; y<example_tilemap.height; y++)
			
				tileSet( example_tilemap, z, x, y, rand(0,3) );
				
			END
		END
	END
	
	tsMapSave( example_tilemap, "mapa.dat" );
	
	tsMapClear( example_tilemap );
	
	tsMapLoad( example_tilemap, "mapa.dat" );
	
	// load FPGs ( only for 2 layers )
	example_tilemap.fpg[0] = load_fpg("fpg/terrain.fpg");
	example_tilemap.fpg[1] = load_fpg("fpg/objects.fpg");
	
	// initialize the scroll
	tsManager(0, 0, 640, 480, example_tilemap, 64, 100);
	
	mouse.graph = 1;
	
	tsDebugMove(8);
	
	LOOP
	
		if ( key(_esc) )
			exit();
		end
		
		// calculate the cursor position in tiles
		tsPixelToTile( ts.pos_x + mouse.x, ts.pos_y + mouse.y, mouse_tile_x, mouse_tile_y );
	
		FRAME;
		
	END

END
