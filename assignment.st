"Build the board object"
Object subclass: #TicTacToe.
TicTacToe instanceVariableNames: 'boardMatrix moves winner xwins owins'.

TicTacToe extend [
	"Set the size of the board"
	initialize [
		"Initialize rows"
		boardMatrix := (Array new: 3).
		"Initialize columns"
		1 to: 3 do: [:x|
			boardMatrix at: x put: (Array new: 3).
		].
		"Init wins"
		xwins := 0.
		owins := 0.
	]
	
	"Make a new game"
	makeNewGame [
		1 to: (boardMatrix size) do: [:x|
			boardMatrix at: x put: (Array new: 3).
		].
      '' displayNl.
      'A clean board has been created.' displayNl.
      '' displayNl.
	]
	
	"Print the scoreboard"
	printScore [
		'' displayNl.
		' Scoreboard' displayNl.
		'-----------------------' displayNl.
		'| Your Wins: ' display.
		xwins printNl.
		'| Comp Wins: ' display.
		owins printNl.
		'-----------------------' displayNl.
	]

	"Print the board"
	printBoard [|rowCount columnCount|
		boardMatrix do: [:x|
			"Printing rows"
			x do: [:y|
				' ---' display.
			].
			'' displayNl.
			columnCount := 1.
			x do: [:y|
				'| ' display.
				"Display the move"
				(y = nil) ifTrue: [ '  ' display ] ifFalse: [ ((y asString), ' ') display ].
				(columnCount = (boardMatrix size)) ifTrue: [ '|' display ] ifFalse: [ columnCount := columnCount + 1 ].
			].
			'' displayNl.
		].
		"Print bottom line."
		boardMatrix do: [:x| ' ---' display ].
		'' displayNl.
		'' displayNl.
	]

	runCommand: str [|tokenizedCommand command x y|
		'Running command' displayNl.
		tokenizedCommand := str subStrings: ','.
		x := (tokenizedCommand at: 1) asInteger.
		y := (tokenizedCommand at: 2) asInteger.
		(boardMatrix at: x) at: y put: $X.
	]

	runComputer [|rand rand1 rand2 running|
		"Pick a number one through 9 and MOD it to get row and column. Keep going"
		rand := Random new.
		"Initial random nums"
		rand1 := (((rand next) * 2) asInteger) + 1.
		rand2 := (((rand next) * 2) asInteger) + 1.
		"Get the value at x,y"
		running := true.
		[running] whileTrue: [
			"Determine if we can actually mark the point."
			(((boardMatrix at: rand1) at: rand2) = nil) ifTrue: [
				"Mark the point"
				(boardMatrix at: rand1) at: rand2 put: $O.
				running := false.
			] ifFalse: [
				"Generate new points"
				rand1 := (((rand next) * 2) asInteger) + 1.
				rand2 := (((rand next) * 2) asInteger) + 1.
			].
		].
	]
	
	"Check if we have a winner and store the winner."
	checkWinner [|xc1 xc2 xc3 oc1 oc2 oc3 rx ro d1x d1o d2x d2o count element|
		"It would have been easier to use a 9 slot array, but I'm
       too far to quit now!"
      "Column counting"
		xc1 := 0.
		xc2 := 0.
		xc3 := 0.
		oc1 := 0.
		oc2 := 0.
		oc3 := 0.

		"Check rows"
		1 to: (boardMatrix size) do: [:x|

         rx := 0.
         ro := 0.
         
         1 to: (boardMatrix size) do: [:y|
            (((boardMatrix at: x) at: y) = $X) ifTrue: [ rx := rx + 1. ].
            (((boardMatrix at: x) at: y) = $O) ifTrue: [ ro := ro + 1. ].
         ].

         (rx = 3) ifTrue: [
            xwins := xwins + 1.
            winner := 'Player'.
            ^true.
         ].

         (ro = 3) ifTrue: [
            owins := owins + 1.
            winner := 'Computer'.
            ^true.
         ].
		].

		"Check columns"
		1 to: (boardMatrix size) do: [:x|
			"Increment row counts"
			(((boardMatrix at: x) at: 1) = $X) ifTrue: [ xc1 := xc1 + 1. ].
         (((boardMatrix at: x) at: 1) = $O) ifTrue: [ oc1 := oc1 + 1. ].

			(((boardMatrix at: x) at: 2) = $X) ifTrue: [ xc2 := xc2 + 1. ].
         (((boardMatrix at: x) at: 2) = $O) ifTrue: [ oc2 := oc2 + 1. ].
			
         (((boardMatrix at: x) at: 3) = $X) ifTrue: [ xc3 := xc3 + 1. ].
         (((boardMatrix at: x) at: 3) = $O) ifTrue: [ oc3 := oc3 + 1. ].
		].
      
		"Perform logical check."
		((xc1 = 3 ) | (xc2 = 3) | (xc3 = 3)) ifTrue: [
			xwins := xwins + 1.
			winner := 'Player'.
			^true.
		].
		((oc1 = 3) | (oc2 = 3) | (oc3 = 3)) ifTrue: [
			owins := owins + 1.
			winner := 'Computer'.
			^true.
		].
	
		"Check diagonals"

      "Set diagonal count"
      d1x := 0.
      d2x := 0.
      d1o := 0.
      d2o := 0.
		
      "Check for player X"
      (((boardMatrix at: 1) at: 1) = $X) ifTrue: [ d1x := d1x + 1. ].
      (((boardMatrix at: 2) at: 2) = $X) ifTrue: [ d1x := d1x + 1. d2x := d2x + 1. ].
      (((boardMatrix at: 3) at: 3) = $X) ifTrue: [ d1x := d1x + 1. ].
      (((boardMatrix at: 1) at: 3) = $X) ifTrue: [ d2x := d2x + 1. ].
      (((boardMatrix at: 3) at: 1) = $X) ifTrue: [ d2x := d2x + 1. ].
      
      "Check for player O"
      (((boardMatrix at: 1) at: 1) = $O) ifTrue: [ d1o := d1o + 1. ].
      (((boardMatrix at: 2) at: 2) = $O) ifTrue: [ d1o := d1o + 1. d2o := d2o + 1. ].
      (((boardMatrix at: 3) at: 3) = $O) ifTrue: [ d1o := d1o + 1. ].
      (((boardMatrix at: 1) at: 3) = $O) ifTrue: [ d2o := d2o + 1. ].
      (((boardMatrix at: 3) at: 1) = $O) ifTrue: [ d2o := d2o + 1. ].
      
      d1x displayNl.
      d2x displayNl.
      d1o displayNl.
      d2o displayNl.

      ((d1x = 3) | (d2x = 3)) ifTrue: [
         xwins := xwins + 1.
         winner := 'Player'.
         ^true.
      ].

      ((d1o = 3) | (d2o = 3)) ifTrue: [
         owins := owins + 1.
         winner := 'Computer'.
         ^true.
      ].

		"Tie or loss. Check loop and count all slots/check nil."
      count := 0.
      1 to: (boardMatrix size) do: [:x|
         1 to: (boardMatrix size) do: [:y|
            (((boardMatrix at: x) at: y) ~= nil) ifTrue: [ count := count + 1. ].
         ].
      ].
      
      "No one won"
      (count = 9) ifTrue: [
         winner := 'No one'.
         ^true.
      ].
		
		^false.
	]
	
	"Get the winner's name."
	getWinner [
		^winner.
	]
].

"Determine which player is who"
'Name of Player: ' display.
player := stdin nextLine.

'' displayNl.
'A clean board has been created.' displayNl.
'' displayNl.

"Create the new board based on the user input."

"The actual game definition."
game := (TicTacToe new) initialize.
game printScore.
game printBoard.

"Loop variables"
terminator := 'quit'.
quit := false.
computersTurn := false.
winner := false.
playerStarts := true.
winnerName := nil.

"The main game loop"
[quit] whileFalse: [
	(computersTurn) ifTrue: [
		('Computer is playing.') displayNl.
		game runComputer.
		('Computer has made a move. Your turn!') displayNl.
		'' displayNl.
		computersTurn := false.
		game printScore.
		game printBoard.
	] ifFalse: [
	'Enter a point in the form x,y: ' display.
		input := stdin nextLine.
		(input = terminator) ifTrue: [ quit := true ] ifFalse: [
			game runCommand: input.
			computersTurn := true.
			game printScore.
			game printBoard.
		].
	].
	"Check for winner"
	winner := game checkWinner.
	(winner) ifTrue: [
		"Get the winner and display their name."
		winnerName := game getWinner.
		(winnerName, ' has won the game.') displayNl.
      game printScore.
		'' displayNl.
		'Would you like to play again? (y/n): ' display.
		in := stdin nextLine.
		"Check for yes to continue"
		((in = 'y') | (in = 'Y')) ifTrue: [
			(playerStarts) ifTrue: [
				playerStarts := false.
				computersTurn := true.
            game makeNewGame.
			] ifFalse: [
				playerStarts := true.
				computersTurn := false.
            game makeNewGame.
            game printBoard.
			].
		] ifFalse: [ quit := true. ].
	].
].
