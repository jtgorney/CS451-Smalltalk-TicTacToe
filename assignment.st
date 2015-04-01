"Build the board object"
Object subclass: #TicTacToe.
TicTacToe instanceVariableNames: 'boardMatrix moves winner xwins owins ties'.

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
      ties := 0.
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
      '| Player Wins: ' display.
      owins printNl.
      '| Computer Wins: ' display.
      xwins printNl.
      '| Ties: ' display.
      ties printNl.
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
   
   "Test the user input for validity."
   isValidCommand: command [|regex|
      (command = 'quit') ifTrue: [ ^true. ].
      "Check for match using a regular expression."
      regex := Regex fromString: '[1-3],[1-3]'.
      (command =~ regex) ifMatched: [ ^true. ] ifNotMatched: [ ^false ].
   ]

   "Check if a slot is open."
   isOpenSlot: x andY: y [
      "Locate point"
      (((boardMatrix at: x) at: y) = nil) ifFalse: [ ^false. ] ifTrue: [ ^true. ].
   ]
   
   "Run a command on the game."
   runCommand: str [|tokenizedCommand command x y|
      tokenizedCommand := str subStrings: ','.
      x := (tokenizedCommand at: 1) asInteger.
      y := (tokenizedCommand at: 2) asInteger.
      ((self isOpenSlot: x andY: y)) ifTrue: [
         (boardMatrix at: x) at: y put: $O.
         ^true.
      ] ifFalse: [
         ^false.
      ].
   ]
   
   "Always choose the best point in the matrix. Block the opponent where we can."
   runChallengeComputer [|moveCount c1MoveCount c2MoveCount c3MoveCount d1MoveCount d2MoveCount|    
      
      "STEP 0: Priority trap block"
      "Left side"
      ((((boardMatrix at: 2) at: 1) = $O) & (((boardMatrix at: 2) at: 2) = $O)) ifTrue: [
         "We need to block something here."
         "Check if row 1 has anything in it."
         ((((boardMatrix at: 1) at: 1) = nil) & (((boardMatrix at: 1) at: 2) = nil) & (((boardMatrix at: 1) at: 3) = nil))
         ifTrue: [
            "Block"
            (boardMatrix at: 2) at: 1 put: $X.
            ^nil.
         ].
         "Check row 3"
         ((((boardMatrix at: 3) at: 1) = nil) & (((boardMatrix at: 3) at: 2) = nil) & (((boardMatrix at: 3) at: 3) = nil))
         ifTrue: [
            "Block"
            (boardMatrix at: 3) at: 1 put: $X.
            ^nil.
         ].
      ].

      "Right side"
      ((((boardMatrix at: 2) at: 3) = $O) & (((boardMatrix at: 2) at: 2) = $O)) ifTrue: [
         "We need to block something here."
         "Check if row 1 has anything in it."
         ((((boardMatrix at: 1) at: 1) = nil) & (((boardMatrix at: 1) at: 2) = nil) & (((boardMatrix at: 1) at: 3) = nil))
         ifTrue: [
            "Block"
            (boardMatrix at: 2) at: 3 put: $X.
            ^nil.
         ].
         "Check row 3"
         ((((boardMatrix at: 3) at: 1) = nil) & (((boardMatrix at: 3) at: 2) = nil) & (((boardMatrix at: 3) at: 3) = nil))
         ifTrue: [
            "Block"
            (boardMatrix at: 3) at: 3 put: $X.
            ^nil.
         ].
      ].

      "STEP 1: Check if we can win somewhere"
      
      "Check if we can win on the diagonal"
      d1MoveCount := 0.
      d2MoveCount := 0.
      "Diagonal 1: (1,1), (2,2), (3,3)"
      (((boardMatrix at: 1) at: 1) = $X) ifTrue: [ d1MoveCount := d1MoveCount + 1. ].
      (((boardMatrix at: 2) at: 2) = $X) ifTrue: [ d1MoveCount := d1MoveCount + 1. d2MoveCount := d2MoveCount + 1 ].
      (((boardMatrix at: 3) at: 3) = $X) ifTrue: [ d1MoveCount := d1MoveCount + 1. ].
   
      "Diagonal 2: (1,3), (2,2), (3,1)"
      (((boardMatrix at: 1) at: 3) = $X) ifTrue: [ d2MoveCount := d2MoveCount + 1. ].
      (((boardMatrix at: 3) at: 1) = $X) ifTrue: [ d2MoveCount := d2MoveCount + 1. ].
      
      "Find a winning spot on the first diagonal"
      (d1MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 1) = nil) ifTrue: [
            (boardMatrix at: 1) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 3) = nil) ifTrue: [
            (boardMatrix at: 3) at: 3 put: $X.
            ^nil.
         ].
      ].

      "Find a winning spot on the second diagonal"
      (d2MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 3) = nil) ifTrue: [
            (boardMatrix at: 1) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 1) = nil) ifTrue: [
            (boardMatrix at: 3) at: 1 put: $X.
            ^nil.
         ].
      ].

      "Check if we can win on the rows"
      1 to: (boardMatrix size) do: [:x|
        moveCount := 0.
        (((boardMatrix at: x) at: 1) = $X) ifTrue: [ moveCount := moveCount + 1. ].
        (((boardMatrix at: x) at: 2) = $X) ifTrue: [ moveCount := moveCount + 1. ].
        (((boardMatrix at: x) at: 3) = $X) ifTrue: [ moveCount := moveCount + 1. ].
        (moveCount = 2) ifTrue: [
           1 to: (boardMatrix size) do: [:id|
              (((boardMatrix at: x) at: id) = nil) ifTrue: [ (boardMatrix at: x) at: id put: $X. ^nil. ].
           ].
        ].
      ].

      "Check if we can win on the columns"
      c1MoveCount := 0.
      c2MoveCount := 0.
      c3MoveCount := 0.

      1 to: (boardMatrix size) do: [:x|
         (((boardMatrix at: x) at: 1) = $X) ifTrue: [ c1MoveCount := c1MoveCount + 1. ].
         (((boardMatrix at: x) at: 2) = $X) ifTrue: [ c2MoveCount := c2MoveCount + 1. ].
         (((boardMatrix at: x) at: 3) = $X) ifTrue: [ c3MoveCount := c3MoveCount + 1. ].
      ].
   
      "Logical step"
      "First column"
      (c1MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 1) = nil) ifTrue: [
            (boardMatrix at: 1) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 1) = nil) ifTrue: [
            (boardMatrix at: 2) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 1) = nil) ifTrue: [
            (boardMatrix at: 3) at: 1 put: $X.
            ^nil.
         ].
      ].
      "Second column"
      (c2MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 2) = nil) ifTrue: [
            (boardMatrix at: 1) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 2) = nil) ifTrue: [
            (boardMatrix at: 3) at: 2 put: $X.
            ^nil.
         ].
      ].
      "Third column"
      (c3MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 3) = nil) ifTrue: [
            (boardMatrix at: 1) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 3) = nil) ifTrue: [
            (boardMatrix at: 2) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 3) = nil) ifTrue: [
            (boardMatrix at: 3) at: 3 put: $X.
            ^nil.
         ].
      ].

      "STEP 2: Check for block opportunities."

      "Check diagonals for blocks"
      d1MoveCount := 0.
      d2MoveCount := 0.
      "Diagonal 1: (1,1), (2,2), (3,3)"
      (((boardMatrix at: 1) at: 1) = $O) ifTrue: [ d1MoveCount := d1MoveCount + 1. ].
      (((boardMatrix at: 2) at: 2) = $O) ifTrue: [ d1MoveCount := d1MoveCount + 1. d2MoveCount := d2MoveCount + 1 ].
      (((boardMatrix at: 3) at: 3) = $O) ifTrue: [ d1MoveCount := d1MoveCount + 1. ].
   
      "Diagonal 2: (1,3), (2,2), (3,1)"
      (((boardMatrix at: 1) at: 3) = $O) ifTrue: [ d2MoveCount := d2MoveCount + 1. ].
      (((boardMatrix at: 3) at: 1) = $O) ifTrue: [ d2MoveCount := d2MoveCount + 1. ].
      "We already calculated (2,2)"
      
      "Find and mark the block in the first diagonal."
      (d1MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 1) = nil) ifTrue: [
            (boardMatrix at: 1) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 3) = nil) ifTrue: [
            (boardMatrix at: 3) at: 3 put: $X.
            ^nil.
         ].
      ].

      "Find and mark the blick in the second diagonal."
      (d2MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 3) = nil) ifTrue: [
            (boardMatrix at: 1) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 1) = nil) ifTrue: [
            (boardMatrix at: 3) at: 1 put: $X.
            ^nil.
         ].
      ].
      
      "Check each row, the computer is always O. Player always X."
      1 to: (boardMatrix size) do: [:x|
        moveCount := 0.
        (((boardMatrix at: x) at: 1) = $O) ifTrue: [ moveCount := moveCount + 1. ].
        (((boardMatrix at: x) at: 2) = $O) ifTrue: [ moveCount := moveCount + 1. ].
        (((boardMatrix at: x) at: 3) = $O) ifTrue: [ moveCount := moveCount + 1. ].
        "Block them!!"
        (moveCount = 2) ifTrue: [
           1 to: (boardMatrix size) do: [:id|
              "Blocked!"
              (((boardMatrix at: x) at: id) = nil) ifTrue: [ (boardMatrix at: x) at: id put: $X. ^nil. ].
           ].
        ].
      ].

      "Now let's check the column"
      c1MoveCount := 0.
      c2MoveCount := 0.
      c3MoveCount := 0. 

      1 to: (boardMatrix size) do: [:x|    
         (((boardMatrix at: x) at: 1) = $O) ifTrue: [ c1MoveCount := c1MoveCount + 1. ].
         (((boardMatrix at: x) at: 2) = $O) ifTrue: [ c2MoveCount := c2MoveCount + 1. ].
         (((boardMatrix at: x) at: 3) = $O) ifTrue: [ c3MoveCount := c3MoveCount + 1. ].
      ].
      "Logical step"
      "First column"
      (c1MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 1) = nil) ifTrue: [
            (boardMatrix at: 1) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 1) = nil) ifTrue: [
            (boardMatrix at: 2) at: 1 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 1) = nil) ifTrue: [
            (boardMatrix at: 3) at: 1 put: $X.
            ^nil.
         ].
      ].
      "Second column"
      (c2MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 2) = nil) ifTrue: [
            (boardMatrix at: 1) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 2) = nil) ifTrue: [
            (boardMatrix at: 2) at: 2 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 2) = nil) ifTrue: [
            (boardMatrix at: 3) at: 2 put: $X.
            ^nil.
         ].
      ].
      "Third column"
      (c3MoveCount = 2) ifTrue: [
         (((boardMatrix at: 1) at: 3) = nil) ifTrue: [
            (boardMatrix at: 1) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 2) at: 3) = nil) ifTrue: [
            (boardMatrix at: 2) at: 3 put: $X.
            ^nil.
         ].
         (((boardMatrix at: 3) at: 3) = nil) ifTrue: [
            (boardMatrix at: 3) at: 3 put: $X.
            ^nil.
         ].
      ].
      "No more tricks up the computer's sleeve. Just pick random."
      self runComputer.
   ]
   
   "Perform the computer logic."
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
            (boardMatrix at: rand1) at: rand2 put: $X.
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
            winner := 'Computer'.
            ^true.
         ].

         (ro = 3) ifTrue: [
            owins := owins + 1.
            winner := 'Player'.
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
         winner := 'Computer'.
         ^true.
      ].
      ((oc1 = 3) | (oc2 = 3) | (oc3 = 3)) ifTrue: [
         owins := owins + 1.
         winner := 'Player'.
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
      
      "Check for diagonal matching X"
      ((d1x = 3) | (d2x = 3)) ifTrue: [
         xwins := xwins + 1.
         winner := 'Computer'.
         ^true.
      ].
      
      "Check diagonal matching O"
      ((d1o = 3) | (d2o = 3)) ifTrue: [
         owins := owins + 1.
         winner := 'Player'.
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
         ties := ties + 1.
         ^true.
      ].
      
      ^false.
   ]
   
   "Get the winner's name."
   getWinner [
      ^winner.
   ]
].

"Ask for a challenge."
'The computer would like to challenge you, accept? (y/n): ' display.
challengeMode := ((stdin nextLine) = 'y').
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
      (challengeMode) ifTrue: [
         game runChallengeComputer.
      ] ifFalse: [
         game runComputer.
      ].
      ('Computer has made a move. Your turn!') displayNl.
      '' displayNl.
      computersTurn := false.
      game printScore.
      game printBoard.
   ] ifFalse: [
   'Enter a point in the form x,y: ' display.
      input := stdin nextLine.
      (game isValidCommand: input) ifTrue: [
         (input = terminator) ifTrue: [
         quit := true.
         'Thank you for playing Tic Tac Toe!' displayNl.
         ] ifFalse: [
            (game runCommand: input) ifTrue: [
               computersTurn := true.
               game printScore.
               game printBoard.
            ] ifFalse: [
               "Point is used"
               'The point you have selected has already been picked!' displayNl.
            ].
         ].
      ] ifFalse: [
         '' displayNl.
         'Invalid command entered!' displayNl.
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
      ] ifFalse: [
         quit := true.
         'Thank you for playing Tic Tac Toe!' displayNl.
      ].
   ].
].
