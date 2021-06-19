
// Project: yframework tst 
// Created: 2021-06-17

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "yframework tst" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#insert "yengine2d.agc"

//load inages
 global phid = 1
 LoadImage(phid,"ph.png")

//worlds

gamew as yworld
menuw as yworld

gamew = newyworld("game")
menuw = newyworld("menu")

//entitys
global start_btn as yentity
tst1 as yentity
tst2 as yentity

start_btn = newyentity(200,200,0,phid)
tst1 = make_mover(120,200)
tst2 = make_target(320,200)


//add entityes to world
yaddw("menu",start_btn)
yaddw("game",tst1)
yaddw("game",tst2)

//change to menu world at the start
changeworld("menu")

//print stuff for testing
global targ_hp as string
do
    
	yengineupdate()
    Sync()
loop

function myupdate()
	
	if worlds[current_worldi].name ="menu" 
		print("click box to go to game world")
		if is_clicked(start_btn) then changeworld("game")
	endif
	
	if worlds[current_worldi].name ="game"
		print("in game world")
		print(targ_hp)
	endif
endfunction


function update_yentity_custom(e as yentity)
	if e.ytype = "mover" and e.yactive then update_mover(e)
	if e.ytype = "targ" and e.yactive then update_target(e)
endfunction


function make_mover(x,y)
	
	e as yentity
	speed = 3
	e = newyentity(x,y,speed,phid)
	e.ytype = "mover"
	e.yints.insert(1) //dmg
endfunction e

function update_mover(e as yentity)
	move_by(e,e.speed,0)
endfunction

function make_target(x,y)
	e as yentity
	e = newyentity(x,y,0,phid)
	e.ytype = "targ"
	e.yints.insert(40) //hp
endfunction e


function update_target(e as yentity)
	targ_hp = "target hp:" +str(e.yints[0])
	
	//hit test between mover
	t as yentity
	t = hit_test(e,"mover")
	
	if ise(t)
		print("hit target")
		ei_change(e,0,-t.yints[0]) //reduce target hp my mover dmg
	endif
	
endfunction
