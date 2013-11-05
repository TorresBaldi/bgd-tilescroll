//------------------------------------------------------------------------------
//	FUNCTIONS
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// Allocates memory for the tilemap
//
FUNCTION tsMapAlloc( _tsmap map, int layers, int width, int height );

PRIVATE
	
	int dim;
	int memory_size;

END

BEGIN
	
	// calculates the map total dimension
	dim = width * height * layers;
	
	// set map(structure) values
	map.layers = layers;
	map.width = width;
	map.height = height;
	
	// allocates map memory
	map.tile = calloc( dim, sizeof(INT) );
	map.fpg = calloc( layers, sizeof(INT) );

	// set all the map.fpg to -1 to indicate that wasn't initialized
	memseti( map.fpg, -1, layers );
	
	// calculates memory_size
	memory_size += sizeof(INT) * 3;	// layers, width, height
	memory_size += sizeof(INT) * layers;
	memory_size += sizeof(INT) * dim;

	if ( ts.debuginfo )
		say("-- ALLOC --");
		say( "dim: " + dim );
		say( "layers: " + layers );
		say( "w x h: " + width + "," + height );
		say( "total allocated size: " + memory_size + " bytes" );
	end
	
	return memory_size;
	
END

//------------------------------------------------------------------------------
//
//	Saves (writes) a tilemap to disc
//
FUNCTION tsMapSave( _tsmap map, string filename )

PRIVATE

	int file_handle;
	int file_size;
	
	int dim;

END

BEGIN

	// calculates the map total dimension 
	dim = map.width * map.height * map.layers;
	
	// creates the new file
	file_handle = fopen( filename, O_WRITE );
	
	if (!file_handle) return false; end

	file_size += fwrite( file_handle, map.layers );
	file_size += fwrite( file_handle, map.width );
	file_size += fwrite( file_handle, map.height );

	// don't save fpg info. they're loaded dynamically
	// file_size += fwrite( map.fpg, map.layers * sizeof(INT), file_handle );
	
	file_size += fwrite( map.tile, dim * sizeof(INT), file_handle );
	
	fclose ( file_handle );
	
	if ( ts.debuginfo )
		say("-- SAVE --");	
		say( "dim: " + dim );
		say( "layers: " + map.layers );
		say( "w x h: " + map.width + "," + map.height );
		say( "total saved size: " + file_size + " bytes" );
	end
	
	return file_size;

END

//------------------------------------------------------------------------------
//
//	Load (reads) a tilemap from disk
//
FUNCTION tsMapLoad( _tsmap map, string filename )

PRIVATE

	int file_handle;
	int file_size;
	
	int dim;
	
	int layers, width, height;

END

BEGIN
	
	file_handle = fopen( filename, O_READ );
	
	file_size += fread( file_handle, layers );
	file_size += fread( file_handle, width );
	file_size += fread( file_handle, height );
	
	dim = layers * width * height;
	
	// allocate the necesarry memory to load
	tsMapAlloc( map, layers, width, height );
	
	file_size += fread( map.tile, dim * sizeof(INT), file_handle );
	
	fclose ( file_handle );
	
	if ( ts.debuginfo )
		say("-- LOAD --");	
		say( "dim: " + dim );
		say( "layers: " + map.layers );
		say( "w x h: " + map.width + "," + map.height );
		say( "total saved size: " + file_size + " bytes" );
	end
	
	return file_size;
	
END

//------------------------------------------------------------------------------
//
//	Frees up allocated memory
//
FUNCTION tsMapClear( _tsmap map )

BEGIN

	map.layers = NULL;
	map.width = NULL;
	map.height = NULL;
	
	mem_free( map.layers );
	mem_free( map.tile );
	
	map.layers = NULL;
	map.tile = NULL;

END



//------------------------------------------------------------------------------
//
// Sets the vaule of a tile
//
#define tileSet(map, layer, x, y, value) map.tile[ (layer * map.width * map.height) + (y * map.width) + x ] = value; ts.draw = true;



//------------------------------------------------------------------------------
//
// Gets the vaule of a tile
//
#define tileGet(map, layer, x, y) map.tile[ (layer * map.width * map.height) + (y * map.width) + x ]



//------------------------------------------------------------------------------
//
// Moves a process inside the scroll
// ( in pixels )
//
#define tsMove(scroll_x, scroll_y) x = scroll_x - ts.pos_x; y = scroll_y - ts.pos_y;



//------------------------------------------------------------------------------
//
// Moves a process inside the scroll
// ( in tiles )
//
#define tsMoveTiles( tile_x, tile_y ) x = ( tile_x * (ts.tsize * (ts.scale/100) ) + (ts.tsize/2) ) - ts.pos_x; y = ( tile_y * (ts.tsize * (ts.scale/100) ) + (ts.tsize/2) ) - ts.pos_y;



//------------------------------------------------------------------------------
//
// Gets the tile position o a position in pixels
//
#define tsPixelToTile( scroll_x, scroll_y, pixel_x, pixel_y ) pixel_x = ( (scroll_x) / ts.tsize); pixel_y = ( (scroll_y) / ts.tsize); 
