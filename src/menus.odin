package main


// import ray "vendor:raylib"
import bb "blitzbasic3d"


Loader :: proc(scriptA, scriptB: string) {
	bb.Cls()
	// ray.TextureWrap
	// logos
	// bb.TileImage(bb.gTile)
	// bb.DrawMainLogo(bb.rX(400), bb.rY(300))


// Cls
// ;logos
// TileImage gTile
// DrawMainLogo(rX#(400),rY#(300))
// DrawImage gMDickie,rX#(400),rY#(515)
// ;message
// DrawOption(-1,rX#(400),rY#(415),scriptA$,scriptB$)
// ;map reference
// If screen=50 Or screen=52 Then DisplayMap(400,125)
// Flip




}


QuickLoader :: proc(x, y:f32, scriptA, scriptB: string) {
	
}


/*
;STANDARD LOADING DISPLAY
Function Loader(scriptA$,scriptB$)
 Cls
  ;logos
  TileImage gTile
  DrawMainLogo(rX#(400),rY#(300))
  DrawImage gMDickie,rX#(400),rY#(515)
  ;message
  DrawOption(-1,rX#(400),rY#(415),scriptA$,scriptB$)
  ;map reference
  If screen=50 Or screen=52 Then DisplayMap(400,125)
 Flip
End Function



Function QuickLoader(x#,y#,scriptA$,scriptB$)
 SetFont font(1)
 DrawOption(-1,x#,y#,scriptA$,scriptB$)
 Flip
End Function



*/