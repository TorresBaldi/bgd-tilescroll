//------------------------------------------------------------------------------
//	SCROLL
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// Manages the scroll drawing
//
PROCESS tsManager(int x0, int y0, int x1, int y1, _tsmap map, int tsize, int tscale)

PRIVATE

	int dim;

	int pointer tile_id;
	
	int tile_index;


BEGIN

	priority = 9999;

	// scroll data initialization
	tsConfig( x0, y0, x1, y1, map, tsize, tscale );
	
	// tiles ids initialization
	for ( z=0; z<map.layers; z++ )
		if ( map.fpg[z] == -1 ) continue; end // skip empty layers
		dim += ts.tiles_x * ts.tiles_y;
	end
	
	ts.tile_id = calloc( dim, sizeof(INT) );
	
	// create tile proceses
	FOR ( z=0; z<map.layers; z++ )

		if ( map.fpg[z] == -1 ) continue; end // skip empty layers
		
		FOR ( x=0; x<ts.tiles_x; x++ )
			FOR ( y=0; y<ts.tiles_y; y++ )
			
				tile_index = (z * ts.tiles_x * ts.tiles_y) + (y * ts.tiles_x) + x;
				ts.tile_id[ tile_index ] = tile();
				signal( ts.tile_id[tile_index], S_FREEZE );
				
			END
		END
	END
	
	if ( ts.debuginfo )
		say( "tiles_count: " + dim );
		//draw_rect(x0, y0, x1, y1);
	end

	LOOP
	
		if ( ts.draw )
			
			// lower limit
			IF ( ts.pos_x < 0 ) ts.pos_x = 0; END
			IF ( ts.pos_y < 0 ) ts.pos_y = 0; END
			
			// upper limit
			IF ( ts.pos_x > ts.limit_x ) ts.pos_x = ts.limit_x;	END
			IF ( ts.pos_y > ts.limit_y ) ts.pos_y = ts.limit_y;	END
			
			// redraw scroll on screen
			tsDrawScroll( map );
			ts.draw = false;
			
		end
	
		frame;
		
	END

END

//------------------------------------------------------------------------------
//
// Move and draw tiles on screen
//
FUNCTION tsDrawScroll(_tsmap map)

PRIVATE

	// 
	int tile_index;
	
	// position of the tile to draw
	int tile_x;
	int tile_y;
	int tile_graph;
	
	// drawing initial point
	int initial_x;
	int initial_y;

END

BEGIN

	// calculate first tile to draw
	initial_x = ts.pos_x / ts.tsize;
	initial_y = ts.pos_y / ts.tsize;
	
	// clean screen before drawing
	//clear_screen();

	// go over all the layers
	FOR ( z=0; z<map.layers; z++ )

		if ( map.fpg[z] == -1 ) continue; end // skip empty layers
	
		// go over every row
		FOR ( y=initial_y; y < initial_y+ts.tiles_y; y++ )
		
			// go over every column
			FOR ( x=initial_x; x < initial_x+ts.tiles_x; x++ )
			
				// calculate tile position on screen
				tile_x = ts.start_x + (ts.tsize / 2) + (x * ts.tsize) - ts.pos_x;
				tile_y = ts.start_y + (ts.tsize / 2) + (y * ts.tsize) - ts.pos_y;
				tile_graph = tileGet(map, z, x, y);
				
				tile_index = (z * ts.tiles_x * ts.tiles_y) + ( (y-initial_y) * ts.tiles_x) + (x-initial_x);
			
				// updates graphic of every tile on screen
				if ( x >= map.width OR y>= map.height OR !tile_graph )
					ts.tile_id[tile_index].graph = 0;
					//signal(ts.tile_id[tile_index], S_SLEEP);
				else
					ts.tile_id[tile_index].x = tile_x;
					ts.tile_id[tile_index].y = tile_y;
					ts.tile_id[tile_index].z = 1000-z;
					ts.tile_id[tile_index].file = map.fpg[z];
					ts.tile_id[tile_index].graph = tile_graph;
					ts.tile_id[tile_index].size = ts.scale;
					//signal(ts.tile_id[tile_index], S_FREEZE);
				end
			
			END
		
		END
		
	END

END

//------------------------------------------------------------------------------
//
// Change scroll configurations
//
FUNCTION tsConfig(int x0, int y0, int x1, int y1, _tsmap map, int tsize, int tscale)

BEGIN

	// scroll parameters
	// ( size and dimension of scroll on screen )
	ts.start_x = x0;
	ts.start_y = y0;
	
	ts.end_x = x1;
	ts.end_y = y1;

	ts.tsize = tsize;
	ts.scale = tscale;

	// calculates scroll limits
	ts.limit_x = ts.tsize * map.width - (ts.end_x-ts.start_x);
	ts.limit_y = ts.tsize * map.height - (ts.end_y-ts.start_y);

	// calculates amount of tiles to draw
	ts.tiles_x = 1 + (ts.end_x - ts.start_x) / ts.tsize;
	ts.tiles_y = 1 + (ts.end_y - ts.start_y) / ts.tsize;

	// round up division
	IF ( (ts.end_x - ts.start_x) % ts.tsize <> 0 ) ts.tiles_x += 1; END
	IF ( (ts.end_y - ts.start_y) % ts.tsize <> 0 ) ts.tiles_y += 1; END

	// flag indicates if the scroll must be redrawn
	ts.draw = true;
	
	if ( ts.debuginfo )
		say("-- tsConfig --");
		say("start_x: " + ts.start_x + " start_y: " + ts.start_y);
		say("end_x: " + ts.end_x + " end_y: " + ts.end_y);
		say("limit_x: " + ts.limit_x + " limit_y: " + ts.limit_y);
		say("tiles_x: " + ts.tiles_x + " tiles_y: " + ts.tiles_y);
		say("tsize: " + ts.tsize);
		say("scale: " + ts.scale);
	end

END


//------------------------------------------------------------------------------
//
// Tile graph on screen
//
PROCESS tile()

BEGIN
	//signal(id, S_FREEZE);
	LOOP
		frame;
	END

END
