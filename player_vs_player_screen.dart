import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerVsPlayerScreen extends StatefulWidget {
  @override
  _PlayerVsPlayerScreenState createState() => _PlayerVsPlayerScreenState();
}

class _PlayerVsPlayerScreenState extends State<PlayerVsPlayerScreen> {
  static const Color highlight = Color(0xFFFAE3D9);
  static const Color textColor = Color(0xFF555555);
  static const Color gridBackground = Color(0xFFF5F5F5); // Light gray background for grid

  List<String> board = List.filled(9, '');
  bool isPlayerXTurn = true;
  String winner = '';
  String player1Name = 'Player 1'; // Placeholder for Player X
  String player2Name = 'Player 2'; // Placeholder for Player O

  // Track scores
  int player1Wins = 0; // Player X
  int player2Wins = 0; // Player O
  int draws = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNameInputDialog();
    });
  }

  Future<void> _showNameInputDialog() async {
    TextEditingController player1Controller = TextEditingController();
    TextEditingController player2Controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: highlight,
          title: Text(
            'Enter Player Names',
            style: GoogleFonts.ubuntu(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: player1Controller,
                decoration: InputDecoration(
                  hintText: 'Player X Name',
                  hintStyle: GoogleFonts.ubuntu(color: textColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                style: GoogleFonts.ubuntu(color: textColor),
                onChanged: (value) {
                  setState(() {
                    player1Name = value.trim().isEmpty ? 'Player 1' : value.trim();
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: player2Controller,
                decoration: InputDecoration(
                  hintText: 'Player O Name',
                  hintStyle: GoogleFonts.ubuntu(color: textColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                style: GoogleFonts.ubuntu(color: textColor),
                onChanged: (value) {
                  setState(() {
                    player2Name = value.trim().isEmpty ? 'Player 2' : value.trim();
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: GoogleFonts.ubuntu(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = isPlayerXTurn ? 'X' : 'O'; // Toggle between X and O
        checkWinner(); // Check winner after the move

        if (winner != '') {
          _showResultDialog();
        } else {
          isPlayerXTurn = !isPlayerXTurn; // Toggle turn
        }
      });
    }
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
      winner = '$player1Name Wins!';
      player1Wins++;
    } else if (_isWinningMove('O')) {
      winner = '$player2Name Wins!';
      player2Wins++;
    } else if (board.every((cell) => cell != '')) {
      winner = 'Draw';
      draws++;
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
          // Removed the scoreboard content
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
      isPlayerXTurn = true;
      winner = '';
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
          'Player vs Player',
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
                          player2Name,
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          '$player2Wins',
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
                          player1Name,
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          '$player1Wins',
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
                          'Draws',
                          style: GoogleFonts.ubuntu(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        Text(
                          '$draws',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
