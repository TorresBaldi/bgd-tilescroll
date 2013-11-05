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

	_tsmap mapa_ejemplo;
	
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
	tsMapAlloc( mapa_ejemplo, map_layers, map_width, map_height );
		
	// fills the map with random values
	FOR ( z=0; z<mapa_ejemplo.layers; z++ )
		FOR (x=0; x<mapa_ejemplo.width; x++)
			FOR (y=0; y<mapa_ejemplo.height; y++)
			
				tileSet( mapa_ejemplo, z, x, y, rand(0,3) );
				
			END
		END
	END
	
	tsMapSave( mapa_ejemplo, "mapa.dat" );
	
	tsMapClear( mapa_ejemplo );
	
	tsMapLoad( mapa_ejemplo, "mapa.dat" );
	
	// load FPGs ( only for 2 layers )
	mapa_ejemplo.fpg[0] = load_fpg("fpg/terrain.fpg");
	mapa_ejemplo.fpg[1] = load_fpg("fpg/objects.fpg");
	
	// initialize the scroll
	tsManager(0, 0, 640, 480, mapa_ejemplo, 64, 100);
	
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
