import 'package:flutter/material.dart';
import 'package:technik/globals.dart';
import 'dart:async';
import 'dart:math';

import 'package:technik/widgets/header_widget.dart';

class SlotMachineWidget extends StatefulWidget {
  final Function(int) onWin;
  final int initialCredits;

  const SlotMachineWidget({
    Key? key,
    required this.onWin,
    this.initialCredits = 100,
  }) : super(key: key);

  @override
  _SlotMachineWidgetState createState() => _SlotMachineWidgetState();
}

class _SlotMachineWidgetState extends State<SlotMachineWidget> with TickerProviderStateMixin {
  final List<String> symbols = ['🍒', '🍋', '🍊', '🍇', '🔔', '💎', '7️⃣'];
  final int reelCount = 3;
  
  // For smooth spinning animation
  List<List<String>> reelStrips = [];
  List<ScrollController> scrollControllers = [];
  List<AnimationController> animControllers = [];
  List<Animation<double>> animations = [];
  
  // Final landing positions for each reel
  List<List<int>> finalSymbolIndices = [];
  
  bool isSpinning = false;
  late int credits;
  
  // Constants for animation
  final double symbolHeight = 60.0;
  final int symbolsPerReel = 20; // Virtual strip length
  
  @override
  void initState() {
    super.initState();
    credits = widget.initialCredits;
    _initializeReels();
  }
  
  void _initializeReels() {
    // Create longer virtual strips for each reel with repeated symbols
    reelStrips = List.generate(reelCount, (_) {
      List<String> strip = [];
      for (int i = 0; i < symbolsPerReel; i++) {
        strip.add(symbols[Random().nextInt(symbols.length)]);
      }
      return strip;
    });
    
    // Initialize scroll controllers for each reel
    // Start at the bottom to create a top-to-bottom spin
    scrollControllers = List.generate(
      reelCount,
      (_) => ScrollController(initialScrollOffset: (symbolsPerReel - 3) * symbolHeight)
    );
    
    // Initialize animation controllers with staggered durations
    animControllers = List.generate(reelCount, (index) => 
      AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000 + (500 * index)), // Staggered durations
      )
    );
    
    // Set up curved animations for more realistic slot machine effect
    animations = animControllers.map((controller) => 
      CurvedAnimation(
        parent: controller,
        // Using easeInOutBack gives a nice smooth slowdown.
        curve: Curves.easeInOutBack,
      )
    ).toList();
    
    // Generate initial landing positions
    finalSymbolIndices = List.generate(
      reelCount, 
      (_) => List.generate(3, (_) => Random().nextInt(symbols.length))
    );
  }
  
  void _spin() {
    if (credits < 10 || isSpinning) return;
    
    setState(() {
      credits -= 10;
      isSpinning = true;
    });
    
    // Determine the final symbols for each reel
    List<List<int>> newFinalIndices = List.generate(
      reelCount, 
      (_) => List.generate(3, (_) => Random().nextInt(symbols.length))
    );
    
    // Update the reel strips to ensure our final symbols will be visible
    for (int i = 0; i < reelCount; i++) {
      // Place the winning symbols at the start of our virtual strip
      for (int j = 0; j < 3; j++) {
        reelStrips[i][j] = symbols[newFinalIndices[i][j]];
      }
    }
    
    // Reset animations and scroll positions
    for (int i = 0; i < reelCount; i++) {
      animControllers[i].reset();
      // Set initial scroll offset to show symbols at the bottom
      scrollControllers[i].jumpTo((symbolsPerReel - 3) * symbolHeight);
    }
    
    // Start the animations with staggered delays
    for (int i = 0; i < reelCount; i++) {
      final controller = animControllers[i];
      final scrollController = scrollControllers[i];
      
      Future.delayed(Duration(milliseconds: i * 200), () {
        controller.forward().whenComplete(() {
          // When the last reel stops, check for wins
          if (i == reelCount - 1) {
            finalSymbolIndices = newFinalIndices;
            _checkWin();
            setState(() {
              isSpinning = false;
            });
          }
        });
        
        // Listen to animation and update scroll position
        controller.addListener(() {
          // Calculate scroll position based on animation value
          // For top-to-bottom spinning, we start at max scroll and go to 0
          double maxScroll = (symbolsPerReel - 3) * symbolHeight;
          double scrollPosition = maxScroll * (1 - controller.value);
          scrollController.jumpTo(scrollPosition);
        });
      });
    }
  }
  
  void _checkWin() {
    // Get the symbols at the payline (middle position)
    List<String> paylineSymbols = List.generate(
      reelCount, 
      (i) => symbols[finalSymbolIndices[i][1]]
    );
    
    // Check for wins (keeping win logic intact)
    if (paylineSymbols.every((symbol) => symbol == paylineSymbols[0])) {
      int winAmount = _getSymbolValue(paylineSymbols[0]) * 10;
      _awardWin(winAmount);
      _showWinDialog("JACKPOT! All symbols match!", winAmount);
    } else if (paylineSymbols.where((symbol) => symbol == '7️⃣').length >= 2) {
      _awardWin(50);
      _showWinDialog("Big Win! Two or more 7s!", 50);
    } else if (paylineSymbols.where((symbol) => symbol == '💎').length >= 2) {
      _awardWin(30);
      _showWinDialog("Nice! Two or more diamonds!", 30);
    } else {
      bool hasPair = false;
      for (int i = 0; i < paylineSymbols.length - 1; i++) {
        for (int j = i + 1; j < paylineSymbols.length; j++) {
          if (paylineSymbols[i] == paylineSymbols[j]) {
            hasPair = true;
            break;
          }
        }
      }
      
      if (hasPair) {
        _awardWin(15);
        _showWinDialog("You got a pair!", 15);
      }
    }
  }
  
  int _getSymbolValue(String symbol) {
    switch (symbol) {
      case '7️⃣': return 7;
      case '💎': return 5;
      case '🔔': return 4;
      case '🍇': return 3;
      case '🍊': return 2;
      case '🍋': return 2;
      case '🍒': return 1;
      default: return 1;
    }
  }
  
  void _awardWin(int amount) {
    setState(() {
      credits += amount;
    });
    widget.onWin(amount);
  }
  
  void _showWinDialog(String message, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Changed dialog background to emerald green
          backgroundColor: Color(0xFF50c878),
          title: Text("You Won!", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              Text("$amount credits", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              child: Text("COLLECT", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  void dispose() {
    for (var controller in animControllers) {
      controller.dispose();
    }
    for (var controller in scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF2c2c2e),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          HeaderWidget(userName: userName),
          SizedBox(height: 30),
          
          // Slot machine body
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              // Changed border color from amber to emerald green
              border: Border.all(color: Color(0xFF50c878), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(reelCount, (reelIndex) {
                return _buildReel(reelIndex);
              }),
            ),
          ),
          SizedBox(height: 30),
          
          // Spin button - emerald green with white text
          ElevatedButton(
            onPressed: isSpinning ? null : _spin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF50c878),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              disabledBackgroundColor: Colors.grey,
              elevation: 5,
            ),
            child: Text(
              isSpinning ? "SPINNING..." : "SPIN (10 CREDITS)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          
          SizedBox(height: 20),
          // Removed "Match symbols to win prizes!" text.
        ],
      ),
    );
  }
  
  Widget _buildReel(int reelIndex) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: ClipRect(
        child: Stack(
          children: [
            // The scrolling reel
            ListView.builder(
              controller: scrollControllers[reelIndex],
              physics: NeverScrollableScrollPhysics(),
              itemCount: symbolsPerReel,
              itemExtent: symbolHeight,
              itemBuilder: (context, index) {
                return Container(
                  height: symbolHeight,
                  alignment: Alignment.center,
                  child: Text(
                    reelStrips[reelIndex][index],
                    style: TextStyle(fontSize: 30),
                  ),
                );
              },
            ),
            // Overlay to create the "window" effect with highlighted payline
            Positioned.fill(
              child: IgnorePointer(
                child: Column(
                  children: [
                    Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
                    Container(
                      height: symbolHeight,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(color: Color(0xFF50c878), width: 1),
                          bottom: BorderSide(color: Color(0xFF50c878), width: 1),
                        ),
                      ),
                    ),
                    Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
                  ],
                ),
              ),
            ),
            // Top blur effect
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
              ),
            ),
            // Bottom blur effect
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import '../widgets/slot_machine_widget.dart';
import "../globals.dart";

class PrizeDrawScreen extends StatefulWidget {
  @override
  _PrizeDrawScreenState createState() => _PrizeDrawScreenState();
}

class _PrizeDrawScreenState extends State<PrizeDrawScreen> {
  int totalWinnings = 0;
  
  void _handleWin(int amount) {
    setState(() {
      totalWinnings += amount;
    });
    // Additional code to handle wins if needed
  }

  void _handleGameStart() {
  if (points >= 100) {
    setState(() {
      points -= 100;
    });
    savePoints(); // Save updated points
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Not enough points to play"))
    );
  }
}

  // Helper function to determine the progress bar color based on progress.
  Color _getProgressColor(double progress) {
    if (progress < 0.33) {
      return Colors.red;
    } else if (progress < 0.66) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  // Helper function to build a badge item with a progress bar.
  Widget buildBadge(String name, String description, double progress) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder icon for the badge.
          Icon(
            Icons.emoji_events,
            size: 50,
            color: Colors.amber,
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          // Progress bar for the badge with rounded corners.
          Container(
            height: 8,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4), // Adjust corner radius as needed
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
    // Header built inline to display points instead of a username.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'lib/icons/logo.png',
            height: 57,
            width: 56,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Points",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "$points",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
                // Insert header displaying points.
              //_buildHeader(),
              //SizedBox(height: 10),

              // Slot Machine Widget at the top.
               SlotMachineWidget(
              onWin: _handleWin,
             // onGameStart: _handleGameStart, // New callback
              initialCredits: 100,
            ),
              SizedBox(height: 20),
              // "Badges" section title.
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Badges",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Horizontal scrollable widget for badges.
              Container(
                height: 160,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      buildBadge("Beginner", "First spin bonus", 0.2),
                      buildBadge("Lucky", "Hit a jackpot once", 0.5),
                      buildBadge("Veteran", "Played 100 spins", 0.8),
                      buildBadge("Champion", "Winnings > 1000", 1.0),
                      buildBadge("Master", "Mastered the slots", 0.9),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Additional content if needed.
            ],
          ),
        ),
      ),
    );
  }
}

*/