"Build the board object"
Object subclass: #TicTacToe.
TicTacToe instanceVariableNames: 'boardMatrix moves winner'.

TicTacToe extend [
	"Set the size of the board"
	setSize: size [
		"Initialize rows"
		boardMatrix := (Array new: (size asInteger)).
		"Initialize columns"
		1 to: size do: [:x|
			boardMatrix at: x put: (Array new: (size asInteger)).
		]
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
	checkWinner [
		"Check first row"
		
		"Check second row"

		"Check third row"

		"Check first column"

		"Check second column"

		"Check third column"

		"Check diagonal 1"

		"Check diagonal 2"

		^false.
	]
	
	"Get the winner's name."
	getWinner [
		^'Watson'.
	]
].

"Computer's name"
computerName := 'Watson'.

"Store the board size"
boardSize := 3.

"Determine which player is who"
'Name of Player: ' display.
player := stdin nextLine.

'' displayNl.

('WARNING ', player asUppercase, ': The computer never loses!. Good luck!') displayNl.
'A clean board has been created.' displayNl.
'' displayNl.

"Create the new board based on the user input."

"The actual game definition."
game := (TicTacToe new) setSize: boardSize.
game printBoard.

"Loop variables"
terminator := 'quit'.
quit := false.
computersTurn := false.
winner := false.
winnerName := nil.

"The main game loop"
[quit] whileFalse: [
	(computersTurn) ifTrue: [
		(computerName, ' is playing.') displayNl.
		game runComputer.
		(computerName, ' has made a move. Your turn!') displayNl.
		'' displayNl.
		computersTurn := false.
		game printBoard.
	] ifFalse: [
	'Enter a point in the form x,y: ' display.
		input := stdin nextLine.
		(input = terminator) ifTrue: [ quit := true ] ifFalse: [
			game runCommand: input.
			computersTurn := true.
			game printBoard.
		].
	].
	"Check for winner"
	winner := game checkWinner.
	(winner) ifTrue: [
		"Get the winner and display their name."
		winnerName := game getWinner.
		(winnerName, ' has won the game!') displayNl.
		'' displayNl.
	].
].
