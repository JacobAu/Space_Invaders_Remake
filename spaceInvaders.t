%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer  : Jacob,Christian, Alan
% Teacher     : Mr.Chow
% Course      : ICS4U1
% Program Name: Space Invaders


%%%%% IMPORTANT INFO %%%%%

% After doing some tiring research, I've come to the realization
% that sprites in turing can only be drawn 1000 times, thus, a player
% can't infinetly play this game and must restart the program.

% Only 5 pellets are allowed on the screen at once. 

%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Import List %%
import shooter in "shooter.t", pellet in "pellet.t", battlefield in "battlefield.t"

setscreen ("graphics:400;400, nocursor")
%setscreen("graphics:1000;600,offscreenonly") % quick testing

%% Variables/Initializing Classes  %%
% Fonts and Menu Variables
var x, y, button, font : int
font := Font.New ("Bahnschrift SemiBold:46")
var font1 := Font.New ("calibri:13")
var font2 := Font.New ("sans serif:30:bold")
var font3 := Font.New ("tahoma:65:Bold")
var font4 := Font.New ("tahoma:55:bold")
var font5 := Font.New ("tahoma:40:bold")
var font6 := Font.New ("calibri:45:bold")
var font7 := Font.New ("tahoma:30:Bold")
var font8 := Font.New ("sans serif:30:Bold")

% Misc.
var userInput : array char of boolean
var gameLose : boolean := false
var gameWin : boolean := false
var lives : int := 3
var randCol : int
var randRow : int
var graceTimeCounter : int := 0
var graceTime : boolean := false

% Initialize Pellets %
var pelletId : array 1 .. 11 of ^pellet
for i : 1 .. 11
    new pelletId (i)
    ^ (pelletId (i)).centrePos (-50, -50)
end for

% Initiate Aliens %
var battlegrid : array 1 .. 9, 1 .. 5 of ^battlefield
var alienX : array 1 .. 9, 1 .. 5 of int
var alienY : array 1 .. 9, 1 .. 5 of int

% Alien Method Altering Variables
var alienDirection : int := 1
var futureAlienY : array 1 .. 9, 1 .. 5 of int
var descentFactor : int := 1
var alienDescent : boolean := false
var alienIsCentre : boolean := true
var lastAlienDirection : int
var numAlienPellets : int := 7


% Counters to draw the starting board
var counterx : int := 225
var countery : int
% give and draw starting aliens coordinates
proc startGame
    Draw.FillBox (0, 0, maxx, maxy, black)
    for i : 1 .. 9
	counterx += 50
	countery := 500
	for j : 1 .. 5
	    new battlegrid (i, j)
	    if j = 1 then
		^ (battlegrid (i, j)).setCentre (counterx, countery, 3)
	    elsif j = 2 then
		^ (battlegrid (i, j)).setCentre (counterx, countery, 2)
	    elsif j = 3 then
		^ (battlegrid (i, j)).setCentre (counterx, countery, 2)
	    elsif j = 4 then
		^ (battlegrid (i, j)).setCentre (counterx, countery, 1)
	    elsif j = 5 then
		^ (battlegrid (i, j)).setCentre (counterx, countery, 1)
	    end if
	    alienX (i, j) := counterx
	    alienY (i, j) := countery
	    countery -= 50
	    ^ (battlegrid (i, j)).drawAlien
	    futureAlienY (i, j) := -50
	end for
    end for
    alienDescent := false
    alienIsCentre := true
    gameWin := false
    gameLose := false
    counterx := 225
end startGame


%%% Procedures and Functions %%%

% Check if game is won
function aliensDead : boolean
    var counter : int := 0
    for i : 1 .. 9
	for j : 1 .. 5
	    if ^ (battlegrid (i, j)).getAlienStatus then 
		counter += 1
	    end if
	end for
    end for
    if counter = 0 then
	result true
    else
	result false
    end if
end aliensDead

% Check Alien/Shooter Hitboxes
function shooterHitbox (shooterX, shooterY, pelletX, pelletY : int) : boolean
    if (pelletX - 1 > shooterX - 33 and pelletX - 1 < shooterX + 33) or
	    (pelletX + 1 > shooterX - 33 and pelletX + 1 < shooterX + 33) then
	if pelletY - 5 < shooterY + 15 then
	    result true
	end if
    end if
    result false
end shooterHitbox

function squidHitbox (squidX, squidY, pelletX, pelletY : int) : boolean
    if (pelletX - 1 > squidX and pelletX - 1 < squidX + 33)
	    or (pelletX + 1 > squidX and pelletX + 1 < squidX + 33) then
	if pelletY + 5 > squidY then
	    result true
	end if
    end if
    result false
end squidHitbox

function ghostHitbox (ghostX, ghostY, pelletX, pelletY : int) : boolean
    if (pelletX - 1 > ghostX and pelletX - 1 < ghostX + 50)
	    or (pelletX + 1 > ghostX and pelletX - 1 < ghostX + 50) then
	if pelletY + 5 > ghostY then
	    result true
	end if
    end if
    result false
end ghostHitbox

function bugHitbox (bugX, bugY, pelletX, pelletY : int) : boolean
    if (pelletX - 1 > bugX and pelletX - 1 < bugX + 46)
	    or (pelletX + 1 > bugX and pelletX + 1 < bugX + 46) then

	if pelletY + 5 > bugY then
	    result true
	end if
    end if
    result false
end bugHitbox

proc gameOver
    Draw.FillBox (0, 0, maxx, maxy, black)
    %Game Over animation
    Font.Draw ("G", 350, 310, font3, 40)
    delay (200)
    Font.Draw ("A", 420, 310, font3, 40)
    delay (200)
    Font.Draw ("M", 485, 310, font3, 40)
    delay (200)
    Font.Draw ("E", 563, 310, font3, 40)
    delay (200)
    Font.Draw ("O", 355, 215, font3, 40)
    delay (200)
    Font.Draw ("V", 425, 215, font3, 40)
    delay (200)
    Font.Draw ("E", 490, 215, font3, 40)
    delay (200)
    Font.Draw ("R", 550, 215, font3, 40)
    delay (200)

    loop
	Mouse.Where (x, y, button)
	if button = 1 and x > 380 and y > 120 and x < 600 and y < 170 then
	    exit
	elsif button = 0 and x > 380 and y > 120 and x < 600 and y < 170 then
	    Draw.Box (380, 120, 600, 170, 70)
	    Font.Draw ("Play Again", 390, 130, font8, 70)
	else
	    Draw.Box (380, 120, 600, 170, 49)
	    Font.Draw ("Play Again", 390, 130, font8, 49)
	end if
    end loop
end gameOver

procedure menu
    Draw.FillBox (0, 0, maxx, maxy, black)

    % Starting game animation
    Font.Draw ("S", 70, 310, font3, 49)
    delay (200)
    Font.Draw ("p", 120, 310, font3, 49)
    delay (200)
    Font.Draw ("a", 173, 310, font3, 49)
    delay (200)
    Font.Draw ("c", 223, 310, font3, 49)
    delay (200)
    Font.Draw ("e", 270, 310, font3, 49)
    delay (200)
    Font.Draw ("I", 40, 215, font4, 49)
    delay (200)
    Font.Draw ("n", 76, 215, font4, 49)
    delay (200)
    Font.Draw ("v", 122, 215, font4, 49)
    delay (200)
    Font.Draw ("a", 164, 215, font4, 49)
    delay (200)
    Font.Draw ("d", 206, 215, font4, 49)
    delay (200)
    Font.Draw ("e", 250, 215, font4, 49)
    delay (200)
    Font.Draw ("r", 294, 215, font4, 49)
    delay (200)
    Font.Draw ("s", 327, 215, font4, 49)
    delay (200)

    % This whole loop structure is to basically continuously check the coordinates
    % of the user's mouse and apply a if statement accordingly.
    loop
	Mouse.Where (x, y, button)
	if button = 1 and x > 155 and y > 120 and x < 255 and y < 170 then 
	    cls
	    setscreen ("graphics:1000;600,offscreenonly")
	    exit
	elsif button = 0 and x > 155 and y > 120 and x < 255 and y < 170 then
	    Draw.Box (150, 120, 250, 170, 70)
	    Font.Draw ("Play", 160, 130, font2, 70)
	else
	    Draw.Box (150, 120, 250, 170, 49) 
	    Font.Draw ("Play", 160, 130, font2, 49)
	end if
	if button = 1 and x > 25 and y > 50 and x < 375 and y < 100 then
	    cls
	    Draw.FillBox (0, 0, 400, 400, black)
	    loop
		Font.Draw ("How To Play", 30, 280, font6, 49)
		Font.Draw ("The goal is to survive and to kill the all aliens.", 16, 250, font1, 49)
		Font.Draw ("Shoot by hitting the space key!", 16, 230, font1, 49)
		Font.Draw ("Reposition yourself using the left and right arrow keys!", 16, 210, font1, 49)
		Font.Draw ("", 20, 190, font1, 49)
		Font.Draw ("The game consists of 5 levels.", 16, 170, font1, 49)
		Font.Draw ("Get past all 5 and you win!", 16, 150, font1, 49)
		Font.Draw ("Note that each successive level grants you an extra life.", 16, 130, font1, 49)
		Font.Draw ("Also the game gets harder as you progress.", 16, 110, font1, 49)
		Font.Draw ("Good Luck!", 16, 90, font1, 49)
		Mouse.Where (x, y, button)
		Draw.Box (10, 395, 80, 370, 49)
		Font.Draw ("BACK", 25, 378, font1, 49)
		if button = 1 and x > 10 and y > 370 and x < 80 and y < 395 then
		    cls

		    % Redraw the homescreen, after clicking back.
		    Draw.FillBox (0, 0, maxx, maxy, black)
		    Font.Draw ("S", 70, 310, font3, 49)
		    Font.Draw ("p", 120, 310, font3, 49)
		    Font.Draw ("a", 173, 310, font3, 49)
		    Font.Draw ("c", 223, 310, font3, 49)
		    Font.Draw ("e", 270, 310, font3, 49)
		    Font.Draw ("I", 40, 215, font4, 49)
		    Font.Draw ("n", 76, 215, font4, 49)
		    Font.Draw ("v", 122, 215, font4, 49)
		    Font.Draw ("a", 164, 215, font4, 49)
		    Font.Draw ("d", 206, 215, font4, 49)
		    Font.Draw ("e", 250, 215, font4, 49)
		    Font.Draw ("r", 294, 215, font4, 49)
		    Font.Draw ("s", 327, 215, font4, 49)
		    exit
		elsif button = 0 and x > 10 and y > 370 and x < 80 and y < 395 then
		    Draw.Box (10, 395, 80, 370, 70)
		    Font.Draw ("BACK", 25, 378, font1, 70)
		end if
	    end loop
	elsif button = 0 and x > 65 and y > 50 and x < 335 and y < 100 then
	    Draw.Box (65, 50, 335, 100, 70)
	    Font.Draw ("How To Play", 83, 60, font2, 70)
	else
	    Draw.Box (65, 50, 335, 100, 49)
	    Font.Draw ("How To Play", 83, 60, font2, 49)
	end if
    end loop
end menu
%%% Main Code %%%

menu
% Intialize Shooter %
var shooterId : ^shooter
new shooterId
var playerX, playerY : int
playerX := 500
playerY := 30
^shooterId.centrePos (playerX, playerY)

loop
    startGame
    loop
	% Draws Lives on top right 
	Font.Draw (intstr (lives), 750, 500, font3, 49)
	Font.Draw ("lives", 820, 525, font5, 49)
	Font.Draw ("left", 835, 475, font5, 49)
	
	% Checks for character that the user has pushed down. 
	Input.KeyDown (userInput)
	
	% Move shooter
	if userInput (KEY_LEFT_ARROW) then
	    Draw.FillBox (playerX - 30, playerY - 30, playerX + 30, playerY + 20, black)
	    playerX -= 9
	    ^shooterId.centrePos (playerX, playerY)
	    ^shooterId.draw
	    View.Update
	    delay (12)
	elsif userInput (KEY_RIGHT_ARROW) then
	    Draw.FillBox (playerX - 30, playerY - 30, playerX + 30, playerY + 20, black)
	    playerX += 9
	    ^shooterId.centrePos (playerX, playerY)
	    ^shooterId.draw
	    View.Update
	    Time.DelaySinceLast(12)
	else
	    % Makes sure that the delay is constant even when player isn't moving. 
	    Time.DelaySinceLast (12) 
	end if
	
	% Boundaries for shooter 
	if playerX + 40 > 1000 then
	    playerX := 960
	elsif playerX - 40 < 0 then
	    playerX := 40
	end if
	^shooterId.draw


	% Pellet 1 Called
	if userInput (' ') and ^ (pelletId (1)).getPelletStatus = false then
	    ^ (pelletId (1)).switchPelletBoolean
	    ^ (pelletId (1)).centrePos (playerX, playerY + 22)
	end if

	% Pellet 2 Called
	if userInput (' ') and ^ (pelletId (1)).getPelletStatus = true
		and ^ (pelletId (2)).getPelletStatus = false
		and ^ (pelletId (1)).getCentreY > playerY + 120 then
	    ^ (pelletId (2)).switchPelletBoolean
	    ^ (pelletId (2)).centrePos (playerX, playerY + 22)
	end if

	% Pellet 3 Called
	if userInput (' ') and ^ (pelletId (1)).getPelletStatus = true
		and ^ (pelletId (2)).getPelletStatus = true
		and ^ (pelletId (3)).getPelletStatus = false
		and ^ (pelletId (2)).getCentreY > playerY + 120 then
	    ^ (pelletId (3)).switchPelletBoolean
	    ^ (pelletId (3)).centrePos (playerX, playerY + 22)
	end if

	% Pellet 4 Called
	if userInput (' ') and ^ (pelletId (1)).getPelletStatus = true
		and ^ (pelletId (2)).getPelletStatus = true
		and ^ (pelletId (3)).getPelletStatus = true
		and ^ (pelletId (4)).getPelletStatus = false
		and ^ (pelletId (3)).getCentreY > playerY + 120 then
	    ^ (pelletId (4)).switchPelletBoolean
	    ^ (pelletId (4)).centrePos (playerX, playerY + 22)
	end if

	% Pellet 5 Called

	if userInput (' ') and ^ (pelletId (1)).getPelletStatus = true
		and ^ (pelletId (2)).getPelletStatus = true
		and ^ (pelletId (3)).getPelletStatus = true
		and ^ (pelletId (4)).getPelletStatus = true
		and ^ (pelletId (5)).getPelletStatus = false
		and ^ (pelletId (4)).getCentreY > playerY + 120 then
	    ^ (pelletId (5)).switchPelletBoolean
	    ^ (pelletId (5)).centrePos (playerX, playerY + 22)
	end if

	% Shooter Pellet Animation and Pellet Reset
	for e : 1 .. 5
	    % Animation
	    if ^ (pelletId (e)).getPelletStatus then
		^ (pelletId (e)).draw
		View.Update
		^ (pelletId (e)).erase
		^ (pelletId (e)).pelletMove
	    end if
	    % Reset
	    if ^ (pelletId (e)).getCentreY > 550 then
		^ (pelletId (e)).centrePos (-50, -50)
		^ (pelletId (e)).switchPelletBoolean
	    end if
	end for
	^ (pelletId (1)).draw
	^ (pelletId (2)).draw
	^ (pelletId (3)).draw
	^ (pelletId (4)).draw
	^ (pelletId (5)).draw
	View.Update

	% Alien Pellets Called
	for e : 6 .. numAlienPellets
	    if ^ (pelletId (e)).getPelletStatus = false then
		loop
		    randCol := Rand.Int (1, 9)
		    randRow := Rand.Int (1, 5)
		    if ^ (battlegrid (randCol, randRow)).getAlienStatus then
			exit
		    end if
		end loop
		^ (pelletId (e)).centrePos (alienX (randCol, randRow), alienY (randCol, randRow))
		^ (pelletId (e)).switchPelletBoolean
	    end if
	end for

	% Gives grace time for the player 
	graceTimeCounter += 1
	if graceTimeCounter >= 90 and graceTime = false then
	    graceTime := true
	    graceTimeCounter := 0
	end if
	
	% Alien Pellet Animation and reset
	if graceTime then
	    for i : 6 .. 11
		if ^ (pelletId (i)).getPelletStatus then
		    ^ (pelletId (i)).draw
		    View.Update
		    ^ (pelletId (i)).erase
		    ^ (pelletId (i)).alienPelletMove
		end if
		if ^ (pelletId (i)).getCentreY < 0 then
		    ^ (pelletId (i)).centrePos (-50, -50)
		    ^ (pelletId (i)).switchPelletBoolean
		end if
	    end for
	end if

	if graceTime then
	    for i : 6 .. 11
		^ (pelletId (i)).draw
	    end for
	end if
	View.Update
	%%%  Alien Hitbox Test %%%
	for i : 1 .. 9
	    for j : 1 .. 5
		if ^ (battlegrid (i, j)).getAlienStatus then
		    % Check all Alien Types; aliens have different hitboxes. 
		    if ^ (battlegrid (i, j)).getAlienType = 1 then
			% Checks all pellets
			for e : 1 .. 5
			    if ghostHitbox (alienX (i, j), alienY (i, j),
				    ^ (pelletId (e)).getCentreX, ^ (pelletId (e)).getCentreY) then
				^ (battlegrid (i, j)).switchAlienStatus
				Draw.FillBox (alienX (i, j), alienY (i, j), alienX (i, j) + 50, alienY (i, j) + 50, black)
				^ (pelletId (e)).erase
				^ (pelletId (e)).centrePos (-50, -50)
				^ (pelletId (e)).switchPelletBoolean
			    end if
			end for
		    elsif ^ (battlegrid (i, j)).getAlienType = 2 then
			for e : 1 .. 5
			    if bugHitbox (alienX (i, j), alienY (i, j), 
				    ^ (pelletId (e)).getCentreX, ^ (pelletId (e)).getCentreY) then
				^ (battlegrid (i, j)).switchAlienStatus
				Draw.FillBox (alienX (i, j), alienY (i, j), alienX (i, j) + 50, alienY (i, j) + 50, black)
				^ (pelletId (e)).erase
				^ (pelletId (e)).centrePos (-50, -50)
				^ (pelletId (e)).switchPelletBoolean
			    end if
			end for
		    elsif ^ (battlegrid (i, j)).getAlienType = 3 then
			for e : 1 .. 5
			    if squidHitbox (alienX (i, j), alienY (i, j),
				    ^ (pelletId (e)).getCentreX, ^ (pelletId (e)).getCentreY) then
				^ (battlegrid (i, j)).switchAlienStatus
				Draw.FillBox (alienX (i, j), alienY (i, j), alienX (i, j) + 50, alienY (i, j) + 50, black)
				^ (pelletId (e)).erase
				^ (pelletId (e)).centrePos (-50, -50)
				^ (pelletId (e)).switchPelletBoolean
			    end if
			end for
		    end if
		end if
	    end for
	end for

	%%% Shooter Hitbox  %%%

	for a : 6 .. 11
	    if shooterHitbox (playerX, playerY, ^ (pelletId (a)).getCentreX, ^ (pelletId (a)).getCentreY) and lives not= 1 then
		lives -= 1
		%Font.Draw("Hit",40,500,font3,12)
		delay (2000)
		Draw.FillBox (750, 480, 810, 580, black)
		Draw.FillBox (40, 490, 200, 580, black)
		playerX := 500
		playerY := 30
		^shooterId.centrePos (playerX, playerY)
		
		% If hit, get rid of all pellets that are currently on the screen 
		for e : 1 .. 11
		    ^ (pelletId (e)).erase
		    ^ (pelletId (e)).centrePos (-50, -50)
		    ^ (pelletId (e)).switchPelletBoolean
		end for
		graceTime := false
		graceTimeCounter:= 0
	    elsif shooterHitbox (playerX, playerY, ^ (pelletId (a)).getCentreX, ^ (pelletId (a)).getCentreY) then
		lives -= 1
		Draw.FillBox (750, 480, 810, 580, black)
		Font.Draw (intstr (lives), 750, 500, font3, 49)
		gameLose := true
	    end if
	end for

	%%% Update Alien Position %%%
	for i : 1 .. 9
	    for j : 1 .. 5
		if ^ (battlegrid (i, j)).getAlienStatus then
		    Draw.FillBox (alienX (i, j), alienY (i, j), alienX (i, j) + 50, alienY (i, j) + 50, black)
		    alienX (i, j) += alienDirection
		    if j = 1 then
			^ (battlegrid (i, j)).setCentre (alienX (i, j), alienY (i, j), 3)
		    elsif j = 2 then
			^ (battlegrid (i, j)).setCentre (alienX (i, j), alienY (i, j), 2)
		    elsif j = 3 then
			^ (battlegrid (i, j)).setCentre (alienX (i, j), alienY (i, j), 2)
		    elsif j = 4 then
			^ (battlegrid (i, j)).setCentre (alienX (i, j), alienY (i, j), 1)
		    elsif j = 5 then
			^ (battlegrid (i, j)).setCentre (alienX (i, j), alienY (i, j), 1)
		    end if
		    ^ (battlegrid (i, j)).drawAlien

		    % Make sure aliens move right, down, then left, vice versa. 
		    if (alienX (i, j) + 50 > 1000 or alienX (i, j) < 0) and alienIsCentre then
			lastAlienDirection := alienDirection
			alienDirection := 0
			alienDescent := true
			alienIsCentre := false
			futureAlienY (i, j) := alienY (i, j) - 40
			%put futureAlienY(9,1) % Alternate test
			%put alienY (9,1)
		    end if
		    if alienDescent then
			alienY (i, j) -= descentFactor
		    end if
		    if alienY (i, j) <= futureAlienY (i, j) then
			alienDirection := lastAlienDirection * -1
			alienDescent := false
			alienIsCentre := true
			futureAlienY (i, j) := -50
		    end if
		end if
	    end for
	end for

	%^(pelletId(6)).centrePos(100,30)% end test
	exit when gameLose = true or aliensDead
    end loop

    
    if gameLose then
	cls
	^shooterId.centrePos (-150, -50)
	^shooterId.draw
	gameOver
	playerX := 500
	playerY := 30
	^shooterId.centrePos (playerX, playerY)
	for i : 1 .. 11
	    ^ (pelletId (i)).centrePos (-50, -50)
	    ^ (pelletId (i)).resetPelletBoolean
	end for
	lives := 3
	alienDirection := 1
    else
	for i : 1 .. 11
	    ^ (pelletId (i)).centrePos (-50, -50)
	    ^ (pelletId (i)).resetPelletBoolean
	end for

	for e : 6 .. 11
	    ^ (pelletId (e)).setAlienPelletSpeed ( ^ (pelletId (e)).getAlienPelletSpeed + 2)
	end for
	numAlienPellets += 1
	lives += 1
	if alienDirection < 0 then
	    alienDirection *= -1
	end if
	alienDirection += 1
	if alienDirection > 5 then
	    exit
	end if
	descentFactor += 1
	graceTimeCounter := 0
	graceTime := false 
	delay (1000)
    end if
end loop

^shooterId.centrePos (-150, -50)
^shooterId.draw

Draw.FillBox (0, 0, maxx, maxy, black)
Font.Draw ("YOU WIN", 300, 300, font3, 49)
Font.Draw ("Now go and restart the program!", 150, 200, font7, 49)
Font.Draw ("Turing only allows a max of", 185, 150, font7, 49)
Font.Draw ("1000 sprites to be drawn :(", 195, 100, font7, 49)
