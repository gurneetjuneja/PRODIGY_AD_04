import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerVsBotScreen extends StatefulWidget {
  final String difficulty; // 'Easy', 'Medium', 'Hard'

  PlayerVsBotScreen({required this.difficulty});

  @override
  _PlayerVsBotScreenState createState() => _PlayerVsBotScreenState();
}

class _PlayerVsBotScreenState extends State<PlayerVsBotScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayerXTurn = true;
  String winner = '';
  String playerName = '';

  // Track scores
  int playerWins = 0;
  int botWins = 0;
  int draws = 0;

  static const Color highlight = Color(0xFFFAE3D9);
  static const Color textColor = Color(0xFF555555);
  static const Color gridBackground = Color(0xFFF5F5F5); // Light gray background for grid

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNameInputDialog();
    });
  }

  void _showNameInputDialog() {
    if (playerName.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: highlight,
            title: Text(
              'Enter Your Name',
              style: GoogleFonts.ubuntu(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  playerName = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Your Name',
                hintStyle: GoogleFonts.ubuntu(color: textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
              ),
              style: GoogleFonts.ubuntu(color: textColor),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (playerName.isNotEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your name')),
                    );
                  }
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.ubuntu(color: textColor),
                ),
              ),
            ],
          );
        },
      ).then((_) {
        // Set default name if none is provided
        if (playerName.isEmpty) {
          setState(() {
            playerName = 'Player';
          });
        }
      });
    }
  }

  void _handleMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = 'X'; // Player X move

        checkWinner(); // Check winner after the player's move

        if (winner == '' && !isGameOver()) {
          // Introduce a delay before the bot makes its move
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              int botMove = _getBotMove();
              board[botMove] = 'O'; // Bot (Player O) move
              checkWinner(); // Check winner after the bot's move

              if (winner != '') {
                _showResultDialog();
              }
            });
          });
        } else if (winner != '') {
          _showResultDialog();
        }
      });
    }
  }

  int _getBotMove() {
    if (widget.difficulty == 'Hard') {
      return _getHardBotMove();
    } else if (widget.difficulty == 'Medium') {
      return _getMediumBotMove();
    } else {
      return _getEasyBotMove();
    }
  }

  int _getEasyBotMove() {
    List<int> emptySpots = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') emptySpots.add(i);
    }
    return emptySpots[Random().nextInt(emptySpots.length)];
  }

  int _getMediumBotMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O'; // Try winning
        if (_isWinningMove('O')) {
          board[i] = '';
          return i;
        }
        board[i] = 'X'; // Try blocking
        if (_isWinningMove('X')) {
          board[i] = '';
          return i;
        }
        board[i] = ''; // Reset
      }
    }

    List<int> preferredMoves = [0, 2, 4, 6, 8];
    List<int> availablePreferredMoves = preferredMoves.where((index) => board[index] == '').toList();

    if (availablePreferredMoves.isNotEmpty) {
      return availablePreferredMoves[Random().nextInt(availablePreferredMoves.length)];
    }

    return _getEasyBotMove();
  }

  int _getHardBotMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }

    for (int move in availableMoves) {
      board[move] = 'O'; // Try winning
      if (_isWinningMove('O')) {
        board[move] = ''; // Reset
        return move;
      }
      board[move] = '';
    }

    for (int move in availableMoves) {
      board[move] = 'X'; // Try blocking
      if (_isWinningMove('X')) {
        board[move] = ''; // Reset
        return move;
      }
      board[move] = '';
    }

    if (board[4] == '') return 4; // Center
    List<int> corners = [0, 2, 6, 8];
    List<int> availableCorners = corners.where((index) => board[index] == '').toList();
    if (availableCorners.isNotEmpty) return availableCorners[Random().nextInt(availableCorners.length)];

    List<int> sides = [1, 3, 5, 7];
    List<int> availableSides = sides.where((index) => board[index] == '').toList();
    if (availableSides.isNotEmpty) return availableSides[Random().nextInt(availableSides.length)];

    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  bool _isWinningMove(String player) {
    List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winningConditions) {
      if (board[condition[0]] == player &&
          board[condition[1]] == player &&
          board[condition[2]] == player) {
        return true;
      }
    }

    return false;
  }

  bool isGameOver() {
    return board.contains('') == false || winner != '';
  }

  void checkWinner() {
    if (_isWinningMove('X')) {
      winner = 'You Win!';
      playerWins++; // Update player wins
    } else if (_isWinningMove('O')) {
      winner = 'You Lose!';
      botWins++; // Update bot wins
    } else if (board.every((cell) => cell != '')) {
      winner = 'Draw';
      draws++; // Update draws
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: highlight,
          title: Text(
            winner,
            style: GoogleFonts.ubuntu(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: Text(
                'Play Again',
                style: GoogleFonts.ubuntu(color: textColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Return to home screen
              },
              child: Text(
                'Home',
                style: GoogleFonts.ubuntu(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      winner = '';
      isPlayerXTurn = true; // Ensure the turn order resets
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: highlight,
      appBar: AppBar(
        backgroundColor: highlight,
        shadowColor: Colors.transparent,
        title: Text(
          'Player vs Bot',
          style: GoogleFonts.ubuntu(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Game grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: gridBackground,
                  border: Border.all(color: textColor),
                ),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: highlight,
                            border: Border.all(color: textColor),
                          ),
                          child: Center(
                            child: Text(
                              board[index],
                              style: GoogleFonts.ubuntu(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 36.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // SCOREBOARD Section
            Column(
              children: [
                Text(
                  'SCOREBOARD',
                  style: GoogleFonts.ubuntu(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                // Scores display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Bot',
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          '$botWins',
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          playerName,
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          '$playerWins',
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Draw count
                Text(
                  'Draws: $draws',
                  style: GoogleFonts.ubuntu(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
