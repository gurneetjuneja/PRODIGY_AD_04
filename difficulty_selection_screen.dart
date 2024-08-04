import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final void Function(String) onDifficultySelected;

  DifficultySelectionScreen({required this.onDifficultySelected});

  static const Color highlight = Color(0xFFFAE3D9);
  static const Color textColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Difficulty',
          style: GoogleFonts.ubuntu(
            color: textColor,
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: highlight,
        shadowColor: textColor.withOpacity(0.5),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildDifficultyButton(context, 'Easy'),
            SizedBox(height: 16.0),
            _buildDifficultyButton(context, 'Medium'),
            SizedBox(height: 16.0),
            _buildDifficultyButton(context, 'Hard'),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty) {
    return SizedBox(
      width: 200, // Set a fixed width for all buttons
      child: ElevatedButton(
        onPressed: () {
          onDifficultySelected(difficulty);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(highlight), // Button background color
          foregroundColor: MaterialStateProperty.all(textColor), // Button text color
          shadowColor: MaterialStateProperty.all(highlight.withOpacity(0.6)), // Button shadow color
          elevation: MaterialStateProperty.all(10), // Shadow elevation
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ), // Button padding
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Button border radius
              side: BorderSide(color: textColor, width: 2), // Border color and width
            ),
          ),
        ),
        child: Text(
          difficulty,
          style: GoogleFonts.ubuntu(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Bold text
            color: textColor, // Button text color
          ),
        ),
      ),
    );
  }
}
