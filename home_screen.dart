import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'difficulty_selection_screen.dart'; // Adjust the import based on your file structure
import 'player_vs_bot_screen.dart'; // Adjust the import based on your file structure
import 'player_vs_player_screen.dart'; // Adjust the import based on your file structure

class HomeScreen extends StatelessWidget {
  static const Color highlight = Color(0xFFFAE3D9);
  static const Color textColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: GoogleFonts.ubuntu(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: highlight,
        shadowColor: textColor.withOpacity(0.5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight,
                shadowColor: highlight.withOpacity(0.6),
                elevation: 10,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: textColor, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DifficultySelectionScreen(
                      onDifficultySelected: (difficulty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerVsBotScreen(
                              difficulty: difficulty,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: textColor),
                  SizedBox(width: 10),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.smart_toy, color: textColor),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight,
                shadowColor: highlight.withOpacity(0.6),
                elevation: 10,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: textColor, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerVsPlayerScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: textColor),
                  SizedBox(width: 10),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.person, color: textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
