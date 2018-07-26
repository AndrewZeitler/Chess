%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                    CHESS BOARD GAME                   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                   BY: ANDREW ZEITLER                  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%            &&&   CULMINATING ACTIVITY  &&&            %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                                                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


View.Set ("graphics:480;480,nobuttonbar") %Set window size and remove buttons


var mousex, mousey, button : int %Declare mouse variables
var x, y : int %Declare grid variables

var selected1 : array 1 .. 2 of int %Selected variables
var selected2 : array 1 .. 2 of int
selected1 (1) := -1
selected1 (2) := -1

var prevMovePiece : int %Holds preious move index

var board : array 0 .. 7, 0 .. 7 of int %Will store the index location on a space on the board
%First element is the index value, second element is x location, third element is y location
var possibleMoves : array 1 .. 32, 0 .. 7, 0 .. 7 of boolean

%ID values
%Pawn = 1, Knight = 2, Bishop = 3, Rook = 4, Queen = 5, King = 6
%White = 1, Black = 2
var xPiece : array 1 .. 32 of int %Gives the x location of the piece
var yPiece : array 1 .. 32 of int % Gives the y location of the piece
var typePiece : array 1 .. 32 of int %Gives the type of piece
var colourPiece : array 1 .. 32 of int %Gives the colour of the piece
var movedPiece : array 1 .. 32 of boolean %Tells us if the piece has been moved
var alivePiece : array 1 .. 32 of boolean %Tells if the piece is alive or not
var picPiece : array 1 .. 32 of int %Draws the picture for the piece

var whoseTurn : int := 1 %To find out whose turn it is
var turnSwitch : int := -1 %Used to switch turns without if statement

var endGame : boolean := false %For ending the game
var lived : boolean := false

%%%%%%%%%%%%%%%%%%Initializing boards%%%%%%%%%%%%%%%%%%

procedure initBoard
    for x : 0 .. 7
	for y : 0 .. 7
	    board (x, y) := 0 %Sets entire board to 0
	end for
    end for

    var ctr : int := 0 %Used to count each piece made and create index location

    %Declare pawns
    for x : 0 .. 7
	for y : 0 .. 1
	    ctr := ctr + 1 %Increase counter by 1
	    board (x, 1 + y * 5) := ctr %Set the board location to the index
	    xPiece (ctr) := x %Set the x value of the index
	    yPiece (ctr) := 1 + y * 5 %Set the y value of the index
	    typePiece (ctr) := 1 %Set the piece type to the index
	    colourPiece (ctr) := y + 1 %Set the colour of the piece to the index
	end for
    end for

    %Declare Rooks, Bishops, and Knights
    for x : 0 .. 1
	for y : 0 .. 1

	    %Rook
	    ctr := ctr + 1
	    board (x * 7, y * 7) := ctr
	    xPiece (ctr) := x * 7
	    yPiece (ctr) := y * 7
	    typePiece (ctr) := 4
	    colourPiece (ctr) := y + 1

	    %Knight
	    ctr := ctr + 1
	    board (1 + x * 5, y * 7) := ctr
	    xPiece (ctr) := 1 + x * 5
	    yPiece (ctr) := y * 7
	    typePiece (ctr) := 2
	    colourPiece (ctr) := y + 1

	    %Bishop
	    ctr := ctr + 1
	    board (2 + x * 3, y * 7) := ctr
	    xPiece (ctr) := 2 + x * 3
	    yPiece (ctr) := y * 7
	    typePiece (ctr) := 3
	    colourPiece (ctr) := y + 1

	end for
    end for

    %Declaring Queen and King
    for y : 0 .. 1

	%Queen
	ctr := ctr + 1
	board (3, y * 7) := ctr
	xPiece (ctr) := 3
	yPiece (ctr) := y * 7
	typePiece (ctr) := 5
	colourPiece (ctr) := y + 1
	%King
	ctr := ctr + 1
	board (4, y * 7) := ctr
	xPiece (ctr) := 4
	yPiece (ctr) := y * 7
	typePiece (ctr) := 6
	colourPiece (ctr) := y + 1

    end for


    for i : 1 .. 32
	movedPiece (i) := false %No piece has moved yet
	alivePiece (i) := true %All pieces are alive
    end for

end initBoard

%Sets all possible moves to be false
procedure initMoveBoard
    for p : 1 .. 32
	for x : 0 .. 7
	    for y : 0 .. 7
		possibleMoves (p, x, y) := false
	    end for
	end for
    end for
end initMoveBoard

%%%%%%%%%%%%%%%%%Drawing%%%%%%%%%%%%%%%%%

%Sets picture values for piece
procedure setPicPiece
    for i : 1 .. 32
	if colourPiece (i) = 1 then
	    if typePiece (i) = 1 then
		picPiece (i) := Pic.FileNew ("whitePawn.bmp")
	    elsif typePiece (i) = 2 then
		picPiece (i) := Pic.FileNew ("whiteKnight.bmp")
	    elsif typePiece (i) = 3 then
		picPiece (i) := Pic.FileNew ("whiteBishop.bmp")
	    elsif typePiece (i) = 4 then
		picPiece (i) := Pic.FileNew ("whiteRook.bmp")
	    elsif typePiece (i) = 5 then
		picPiece (i) := Pic.FileNew ("whiteQueen.bmp")
	    elsif typePiece (i) = 6 then
		picPiece (i) := Pic.FileNew ("whiteKing.bmp")
	    end if
	elsif colourPiece (i) = 2 then
	    if typePiece (i) = 1 then
		picPiece (i) := Pic.FileNew ("blackPawn.bmp")
	    elsif typePiece (i) = 2 then
		picPiece (i) := Pic.FileNew ("blackKnight.bmp")
	    elsif typePiece (i) = 3 then
		picPiece (i) := Pic.FileNew ("blackBishop.bmp")
	    elsif typePiece (i) = 4 then
		picPiece (i) := Pic.FileNew ("blackRook.bmp")
	    elsif typePiece (i) = 5 then
		picPiece (i) := Pic.FileNew ("blackQueen.bmp")
	    elsif typePiece (i) = 6 then
		picPiece (i) := Pic.FileNew ("blackKing.bmp")
	    end if
	end if
    end for
end setPicPiece

procedure drawBoard
    for x : 0 .. 7 %Sets x location
	for y : 0 .. 7 %Sets y location
	    if ((x + y) mod 2 = 1) then %If the board is in an odd location it draws it as the darker square
		Draw.FillBox (x * 60, y * 60, (x + 1) * 60, (y + 1) * 60, 65) %Dark square
	    else %If the this is in an even location then draw lighter square
		Draw.FillBox (x * 60, y * 60, (x + 1) * 60, (y + 1) * 60, 114) %Light square
	    end if
	end for
    end for
end drawBoard

%Draw pieces in index locations
procedure drawPieces
    for i : 1 .. 32
	if alivePiece (i) = true then
	    Pic.Draw (picPiece (i), xPiece (i) * 60, yPiece (i) * 60, picMerge) %Draw picture in proper location
	end if
    end for
end drawPieces



%%%%%%%%!Piece Movements!%%%%%%%%

%%%%%%%%%Pawn%%%%%%%%%%%
procedure pawn (indx : int)
    %Moving pawn by two spaces
    if colourPiece (indx) = 1 then %If the piece is white
	if (yPiece (indx) + 2 < 8 & movedPiece (indx) = false) then %White piece
	    if (board (xPiece (indx), yPiece (indx) + 2) = 0) then
		possibleMoves (indx, xPiece (indx), yPiece (indx) + 2) := true
	    end if
	end if
	%Moving pawn by one space
	if (yPiece (indx) + 1 < 8) then
	    if (board (xPiece (indx), yPiece (indx) + 1) = 0) then %White piece
		possibleMoves (indx, xPiece (indx), yPiece (indx) + 1) := true
	    end if
	end if
	%Attacking
	if (yPiece (indx) + 1 < 8 & xPiece (indx) + 1 < 8) then
	    if (board (xPiece (indx) + 1, yPiece (indx) + 1) not= 0) then %If the board diagonally from the piece is not empty
		possibleMoves (indx, xPiece (indx) + 1, yPiece (indx) + 1) := true
	    end if
	end if
	if (yPiece (indx) + 1 < 8 & xPiece (indx) - 1 > -1) then
	    if (board (xPiece (indx) - 1, yPiece (indx) + 1) not= 0) then
		possibleMoves (indx, xPiece (indx) - 1, yPiece (indx) + 1) := true
	    end if
	end if
    elsif colourPiece (indx) = 2 then %If the colour is black
	if (yPiece (indx) - 2 > -1 & movedPiece (indx) = false) then
	    if (board (xPiece (indx), yPiece (indx) - 2) = 0) then
		possibleMoves (indx, xPiece (indx), yPiece (indx) - 2) := true
	    end if
	end if

	if (yPiece (indx) - 1 > -1) then
	    if (board (xPiece (indx), yPiece (indx) - 1) = 0) then
		possibleMoves (indx, xPiece (indx), yPiece (indx) - 1) := true
	    end if
	end if

	%Pawn attacking
	if (yPiece (indx) - 1 > -1 & xPiece (indx) + 1 < 8) then
	    if (board (xPiece (indx) + 1, yPiece (indx) - 1) not= 0) then
		possibleMoves (indx, xPiece (indx) + 1, yPiece (indx) - 1) := true
	    end if
	end if
	if (yPiece (indx) - 1 > -1 & xPiece (indx) - 1 > -1) then
	    if (board (xPiece (indx) - 1, yPiece (indx) - 1) not= 0) then
		possibleMoves (indx, xPiece (indx) - 1, yPiece (indx) - 1) := true
	    end if
	end if
    end if

end pawn


%%%%%%%%%Knight%%%%%%%%%%
%Checks all L moves
procedure knight (indx : int)
    %Up L
    for i : 0 .. 1
	if (xPiece (indx) + 1 - 2 * i < 8 & xPiece (indx) + 1 - 2 * i > -1 & yPiece (indx) + 2 < 8) then
	    possibleMoves (indx, xPiece (indx) + 1 - 2 * i, yPiece (indx) + 2) := true
	end if
	%Down L
	if (xPiece (indx) + 1 - 2 * i < 8 & xPiece (indx) + 1 - 2 * i > -1 & yPiece (indx) - 2 > -1) then
	    possibleMoves (indx, xPiece (indx) + 1 - 2 * i, yPiece (indx) - 2) := true
	end if
	%Left L
	if (yPiece (indx) + 1 - 2 * i < 8 & yPiece (indx) + 1 - 2 * i > -1 & xPiece (indx) + 2 < 8) then
	    possibleMoves (indx, xPiece (indx) + 2, yPiece (indx) + 1 - 2 * i) := true
	end if
	%Right L
	if (yPiece (indx) + 1 - 2 * i < 8 & yPiece (indx) + 1 - 2 * i > -1 & xPiece (indx) - 2 > -1) then
	    possibleMoves (indx, xPiece (indx) - 2, yPiece (indx) + 1 - 2 * i) := true
	end if
    end for
end knight


%%%%%%%%Bishop%%%%%%%%%%
procedure bishop (indx : int)
    var ctr : int := 0 %Counter used to increase x and y position
    %Make up right moves
    loop
	ctr := ctr + 1 %Increase counter
	%If the location goes off the board then stop searching in that direction
	if (xPiece (indx) + ctr > 7| yPiece (indx) + ctr > 7) then
	    exit
	    %If the location finds a piece then make that an available move but exit afterwards
	elsif (board (xPiece (indx) + ctr, yPiece (indx) + ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx) + ctr) := true
	    exit
	    %Otherwise, the move is completely possible, so make that an available move
	else
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx) + ctr) := true
	end if
    end loop
    ctr := 0 %Reset counter
    %Make up left moves
    loop
	ctr := ctr + 1
	if (xPiece (indx) - ctr < 0| yPiece (indx) + ctr > 7) then
	    exit
	elsif (board (xPiece (indx) - ctr, yPiece (indx) + ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx) + ctr) := true
	    exit

	else
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx) + ctr) := true
	end if
    end loop
    ctr := 0
    %Make down right moves
    loop
	ctr := ctr + 1
	if (xPiece (indx) + ctr > 7| yPiece (indx) - ctr < 0) then
	    exit
	elsif (board (xPiece (indx) + ctr, yPiece (indx) - ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx) - ctr) := true
	    exit

	else
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx) - ctr) := true
	end if
    end loop
    ctr := 0
    %Make down left moves
    loop
	ctr := ctr + 1
	if (xPiece (indx) - ctr < 0| yPiece (indx) - ctr < 0) then
	    exit
	elsif (board (xPiece (indx) - ctr, yPiece (indx) - ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx) - ctr) := true
	    exit

	else
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx) - ctr) := true
	end if
    end loop
end bishop


%%%%%%%Rook%%%%%%%%%
%Similar movements to bishop so comments are only there
procedure rook (indx : int)
    var ctr : int := 0 %Counter increases x or y positions

    %Declare up movements
    loop
	ctr := ctr + 1
	if yPiece (indx) + ctr > 7 then
	    exit
	elsif (board (xPiece (indx), yPiece (indx) + ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx), yPiece (indx) + ctr) := true
	    exit
	else
	    possibleMoves (indx, xPiece (indx), yPiece (indx) + ctr) := true
	end if
    end loop
    ctr := 0
    %Declare right movements
    loop
	ctr := ctr + 1
	if xPiece (indx) + ctr > 7 then
	    exit
	elsif (board (xPiece (indx) + ctr, yPiece (indx)) not= 0) then
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx)) := true
	    exit
	else
	    possibleMoves (indx, xPiece (indx) + ctr, yPiece (indx)) := true
	end if
    end loop
    ctr := 0
    %Declare down movements
    loop
	ctr := ctr + 1
	if yPiece (indx) - ctr < 0 then
	    exit
	elsif (board (xPiece (indx), yPiece (indx) - ctr) not= 0) then
	    possibleMoves (indx, xPiece (indx), yPiece (indx) - ctr) := true
	    exit
	else
	    possibleMoves (indx, xPiece (indx), yPiece (indx) - ctr) := true
	end if
    end loop
    ctr := 0
    %Declare left movements
    loop
	ctr := ctr + 1
	if xPiece (indx) - ctr < 0 then
	    exit
	elsif (board (xPiece (indx) - ctr, yPiece (indx)) not= 0) then
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx)) := true
	    exit
	else
	    possibleMoves (indx, xPiece (indx) - ctr, yPiece (indx)) := true
	end if
    end loop
end rook


%%%%%%%%Queen%%%%%%%%%%
%Repeats possible moves for a rook and bishop
procedure queen (indx : int)
    rook (indx)
    bishop (indx)
end queen


%%%%%%%%%%%King%%%%%%%%%%%%
procedure king (indx : int)
    var obstructed : boolean := false %Used to declare whether the castling is being stopped or not
    for x : -1 .. 1
	for y : -1 .. 1
	    %Sets possible moves for king all around piece
	    if (((x not= 2) & (y not= 2)) & (xPiece (indx) + x < 8 & xPiece (indx) + x > -1) & (yPiece (indx) + y < 8 & yPiece (indx) + y > -1)) then
		possibleMoves (indx, xPiece (indx) + x, yPiece (indx) + y) := true
	    end if
	end for
    end for
    %Castle right
    if movedPiece (indx) = false then %If king hasn't moved
	for x : 1 .. 2
	    if board (xPiece (indx) + x, yPiece (indx)) not= 0 then %If there is a piece in the way
		obstructed := true
	    else
		for i : 1 .. 32
		    if colourPiece (i) not= colourPiece (indx) then %If there is another piece attacking a castle square
			if possibleMoves (i, xPiece (indx) + x, yPiece (indx)) = true then
			    obstructed := true
			end if
		    end if
		end for
	    end if
	end for
	if board (xPiece (indx) + 3, yPiece (indx)) not= 0 then %If there is nothing obstructing then create possible move
	    if movedPiece (board (xPiece (indx) + 3, yPiece (indx))) = false & obstructed = false then
		possibleMoves (indx, xPiece (indx) + 2, yPiece (indx)) := true
	    end if
	end if
	obstructed := false
	%Castle left %Repeated from castle left
	for x2 : 1 .. 3
	    if board (xPiece (indx) - x2, yPiece (indx)) not= 0 then
		obstructed := true
	    else
		for i : 1 .. 32
		    if colourPiece (i) not= colourPiece (indx) then
			if possibleMoves (i, xPiece (indx) - x2, yPiece (indx)) = true then
			    obstructed := true
			end if
		    end if
		end for
	    end if
	end for
	if board (xPiece (indx) - 4, yPiece (indx)) not= 0 then
	    if movedPiece (board (xPiece (indx) - 4, yPiece (indx))) = false & obstructed = false then
		possibleMoves (indx, xPiece (indx) - 2, yPiece (indx)) := true
	    end if
	end if
    end if

end king





%%%%%%%%%%%%%%%%%%%%Check Pieces%%%%%%%%%%%%%%%%%%%%

%%%Checks piece moves%%%
procedure checkOne (indx : int)
    if alivePiece (indx) = true then
	var tempType : int := typePiece (indx)

	if tempType = 1 then
	    pawn (indx)
	elsif tempType = 2 then
	    knight (indx)
	elsif tempType = 3 then
	    bishop (indx)
	elsif tempType = 4 then
	    rook (indx)
	elsif tempType = 5 then
	    queen (indx)
	elsif tempType = 6 then
	    king (indx)
	end if

    end if
end checkOne

%%%Checks all piece moves%%%
procedure checkAll

    for i : 1 .. 32
	checkOne (i)
    end for

    checkOne (30)

end checkAll



%%%Checks to see if any king is in check and returns king if so%%%
function checkCheck () : int     %Is this thing on?
    for i : 1 .. 32
	if typePiece (i) = 6 then
	    for I : 1 .. 32
		if possibleMoves (I, xPiece (i), yPiece (i)) = true & colourPiece (I) not= colourPiece (i) then
		    result i %Results king ID
		end if
	    end for
	end if
    end for
    result 0
end checkCheck



%%%%%%%%%%%Pawn reaching end%%%%%%%%%%%%%%%%%%%

%%%Creates menu when a pawn reaches the end%%%
procedure pawnUpgrade (indx : int)
    var piece : int := 0
    loop
	%Draw normal board
	drawBoard
	drawPieces

	%Drawing menu screen
	Draw.FillBox (180, 180, 300, 300, white)
	Draw.Box (180, 180, 300, 300, black)

	%Mouse checks
	Mouse.Where (mousex, mousey, button)
	for x : 0 .. 1
	    for y : 0 .. 1
		%Set piece type to what was selected on the menu
		if mousex > 180 + x * 60 & mousex < 180 + (x + 1) * 60 & mousey > 180 + y * 60 & mousey < 180 + (y + 1) * 60 & button = 1 then
		    piece := (x + 1 + (1 * y)) + (y + 1) %Algorithm for finding which piece selected without if statement
		    typePiece (indx) := piece
		    setPicPiece %Reset picture
		    initMoveBoard %Reset move board
		    checkAll
		    %Highlight piece if you hover over it black
		elsif mousex > 180 + x * 60 & mousex < 180 + (x + 1) * 60 & mousey > 180 + y * 60 & mousey < 180 + (y + 1) * 60 then
		    Draw.FillBox (180 + x * 60, 180 + y * 60, 180 + (x + 1) * 60, 180 + (y + 1) * 60, black)

		end if
	    end for
	end for

	%Draw pictures on menu
	if colourPiece (indx) = 1 then
	    Pic.Draw (picPiece (18), 180, 180, picMerge)
	    Pic.Draw (picPiece (19), 240, 180, picMerge)
	    Pic.Draw (picPiece (17), 180, 240, picMerge)
	    Pic.Draw (picPiece (29), 240, 240, picMerge)
	else
	    Pic.Draw (picPiece (21), 180, 180, picMerge)
	    Pic.Draw (picPiece (22), 240, 180, picMerge)
	    Pic.Draw (picPiece (20), 180, 240, picMerge)
	    Pic.Draw (picPiece (31), 240, 240, picMerge)
	end if
	View.Update
	exit when piece not= 0 %Exit when a piece is selected
    end loop
end pawnUpgrade

procedure endPawn %If a pawn reaches the end the run procedure pawnUpgrade
    for i : 1 .. 32
	if typePiece (i) = 1 then
	    if yPiece (i) = 7 or yPiece (i) = 0 then
		pawnUpgrade (i) %Gives index of piece
	    end if
	end if
    end for
end endPawn

%%%%%%%%%%%%%%Movement of Pieces and Checkmate%%%%%%%%%%%%%%%%%%%

%%%Changing location of pieces%%%
procedure movePiece (x1 : int, y1 : int, x2 : int, y2 : int)

    xPiece (board (x1, y1)) := x2 %Change location to new one
    yPiece (board (x1, y1)) := y2
    movedPiece (board (x1, y1)) := true %Show that the piece has now moved
    board (x2, y2) := board (x1, y1) %Set the new location to have the board's index value
    board (x1, y1) := 0 %Set old location to have nothing on it

    initMoveBoard %Reinitialize move locations
    checkAll

    turnSwitch := turnSwitch * -1 %Switch turn
    whoseTurn := whoseTurn + turnSwitch

end movePiece

%%%Checkmate%%%
%Second half to checkmate
procedure checkMate2 (x1 : int, y1 : int, x2 : int, y2 : int, previousPiece : int, moved : boolean)
    movePiece (x1, y1, x2, y2) %MovePiece to new place

    if checkCheck () = 0| checkCheck () not= 0 & colourPiece (checkCheck ()) not= colourPiece (board (x2, y2)) then
	lived := true %Check if we're still in check and if not then we live
    end if
    movePiece (x2, y2, x1, y1) %Move piece back

    turnSwitch := turnSwitch * -1 %Switch turn
    whoseTurn := whoseTurn + turnSwitch

    if previousPiece not= 0 then %If we took a piece then revive them
	alivePiece (previousPiece) := true
	board (x2, y2) := previousPiece
	movedPiece (previousPiece) := moved %Make sure their move value stays the same
    end if
end checkMate2
%Checks to see if checkmate occurs
procedure checkMate (indx : int)
    var previousPiece : int %Used to revive piece
    var moved : boolean %See if the previousPiece has moved
    for i : 1 .. 32 %Index values
	if colourPiece (i) = colourPiece (indx) then %If the colour is equal to king
	    for x : 0 .. 7
		for y : 0 .. 7
		    if possibleMoves (i, x, y) = true then %Check to see if move is possible
			if board (x, y) not= 0 then %If there is a piece already there who is not my colour
			    if colourPiece (board (x, y)) not= colourPiece (indx) then
				alivePiece (board (x, y)) := false %Kill piece
				previousPiece := board (x, y) %Set previous piece
				moved := movedPiece (previousPiece) %Set moved
				checkMate2 (xPiece (i), yPiece (i), x, y, previousPiece, moved) %Run checkMate2 to reduce lines
			    end if
			else %if no enemies are there
			    checkMate2 (xPiece (i), yPiece (i), x, y, 0, false)
			end if
		    end if
		end for
	    end for
	end if
    end for
    turnSwitch := turnSwitch * -1 %Switch turn
    whoseTurn := whoseTurn + turnSwitch
    if lived = false then %If we never were able to protect ourselves then the game is finished
	endGame := true
    else %Otherwise reser lived and we're good!
	lived := false
    end if
end checkMate


%%%Selecting piece after clicking%%%
procedure selectPiece (x : int, y : int)
    if selected1 (1) = -1 then %If there is no piece already selected
	if board (x, y) not= 0 then %If there is a piece there
	    if colourPiece (board (x, y)) = whoseTurn then %If the colour of the piece is equal to whose turn it is
		selected1 (1) := x %Assign x location to first array location
		selected1 (2) := y %Assign y location to second array location
	    end if
	end if
    else %If there already is a piece selected
	selected2 (1) := x %Assign x and y locations
	selected2 (2) := y
	%If the selected move is equal to a possible location for that piece
	if possibleMoves (board (selected1 (1), selected1 (2)), selected2 (1), selected2 (2)) = true then
	    %Assign where a previous location took place
	    if board (selected2 (1), selected2 (2)) not= 0 then
		prevMovePiece := board (selected2 (1), selected2 (2))
	    else
		prevMovePiece := 0
	    end if
	    %If there is a piece in the destination that isn't my piece then kill the piece and move there
	    if board (selected2 (1), selected2 (2)) not= 0 then
		if colourPiece (board (selected2 (1), selected2 (2))) not= colourPiece (board (selected1 (1), selected1 (2))) then
		    alivePiece (board (selected2 (1), selected2 (2))) := false %Killing the piece
		    movePiece (selected1 (1), selected1 (2), selected2 (1), selected2 (2)) %Moving there

		end if
	    else %Otherwise just move the piece
		movePiece (selected1 (1), selected1 (2), selected2 (1), selected2 (2))

	    end if
	    if typePiece (board (selected2 (1), selected2 (2))) = 6 then
		if selected1 (1) - selected2 (1) = -2 then %Check if we castled on right side
		    selected1 (1) := 7 %Set piece we're going to move
		    selected2 (1) := 5
		    turnSwitch := turnSwitch * -1 %Switch turn to balance once again
		    whoseTurn := whoseTurn + turnSwitch

		    movePiece (selected1 (1), selected1 (2), selected2 (1), selected2 (2)) %Move piece again
		elsif selected1 (1) - selected2 (1) = 2 then %Check if we castle on left side
		    selected1 (1) := 0
		    selected2 (1) := 3
		    turnSwitch := turnSwitch * -1
		    whoseTurn := whoseTurn + turnSwitch

		    movePiece (selected1 (1), selected1 (2), selected2 (1), selected2 (2))
		end if

	    end if

	    endPawn %Check if a pawn has reached an end
	    if checkCheck () not= 0 then %Check to see if king is in check and it's the same turn
		if colourPiece (checkCheck ()) not= whoseTurn then
		    movePiece (selected2 (1), selected2 (2), selected1 (1), selected1 (2)) %Move the piece back
		    checkMate (checkCheck ()) %Check if it is check mate
		    if prevMovePiece not= 0 then %If there was a piece that we took before
			alivePiece (prevMovePiece) := true %Revive piece
			board (selected2 (1), selected2 (2)) := prevMovePiece %Put piece back to previous location
		    end if
		end if
	    end if
	end if
	selected1 (1) := -1 %Reset selected piece

    end if
end selectPiece

%%%%%%%%%%%%%%%%Set grid location%%%%%%%%%%%%%%%%%%%

function grid (num : int) : int
    if num < 480 & num > -1 then %Check to see if the location is within the screen
	result num div 60 %Return the grid value of num
    else %If num is out of bounds then return 0
	result 0
    end if
end grid

%%% Set values %%%
initBoard %Set board values before starting
setPicPiece
initMoveBoard
checkAll

%%%%%%%%%%%%%%%%%%%%%%Main Loop%%%%%%%%%%%%%%%%%%%%%%

procedure mainGame
    loop
	View.Set ("offscreenonly") %Stop flickering

	drawBoard %Draw the playing board
	if checkCheck () not= 0 then %Draw a box around the king if in check
	    Draw.FillBox (xPiece (checkCheck ()) * 60, yPiece (checkCheck ()) * 60, (xPiece (checkCheck ()) + 1) * 60, (yPiece (checkCheck ()) + 1) * 60, red)
	end if
	drawPieces %Draw board piece

	if selected1 (1) not= -1 then
	    Draw.Box (selected1 (1) * 60, selected1 (2) * 60, (selected1 (1) + 1) * 60, (selected1 (2) + 1) * 60, yellow) %Draw a box around the selected piece
	end if

	View.Update %Stop flickering
	cls
	Mouse.Where (mousex, mousey, button) %Finding x and y location and button pressed
	if button = 1 then %Check if the mouse clicks
	    x := grid (mousex) %Set the x location to fit with the chess board
	    y := grid (mousey) %Set the y location to fit with the chess board
	    selectPiece (x, y) %Run the selectPiece procedure sending out the grid locations
	    loop %Wait until the player stops holding down the button
		Mouse.Where (mousex, mousey, button)
		exit when button = 0
	    end loop
	end if

	exit when endGame = true
    end loop
end mainGame

mainGame %Main game loop
cls
loop
    drawBoard
    drawPieces
    Draw.FillBox (xPiece (checkCheck ()) * 60, yPiece (checkCheck ()) * 60, (xPiece (checkCheck ()) + 1) * 60, (yPiece (checkCheck ()) + 1) * 60, brightred)
    drawPieces
    View.Update
    delay (500)
    drawBoard
    drawPieces
    View.Update
    delay (500)
end loop

