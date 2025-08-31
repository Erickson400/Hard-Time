package main
//-------------------------------------------------------------------------
///////////////////////////////// HARD TIME ///////////////////////////////
//-------------------------------------------------------------------------
//~~~~~~~~~~~~~~~~~~~~~ Copyright � Mat Dickie 2007 ~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~ This program may not be re-released under any other ~~~~~~~~~~
//~~~~~~~ identity or sold commercially without express permission. ~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// import bb "blitzbasic3d"
import ray "vendor:raylib"


entry_point :: proc() {
	// INITIATE ENGINE 



	for true {
		ray.BeginDrawing()
		ray.ClearBackground(ray.GRAY)

		ray.EndDrawing()
		if ray.WindowShouldClose() do break
	}
}


