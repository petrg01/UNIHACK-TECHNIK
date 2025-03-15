import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class PrizeDrawScreen extends StatefulWidget {
  @override
  _PrizeDrawScreenState createState() => _PrizeDrawScreenState();
}

class _PrizeDrawScreenState extends State<PrizeDrawScreen> with TickerProviderStateMixin {
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
  int credits = 100;
  
  // Constants for animation
  final double symbolHeight = 60.0;
  final int symbolsPerReel = 20; // Virtual strip length
  
  @override
  void initState() {
    super.initState();
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
        // Use a custom curve that starts fast and slows down at the end
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
    
    // Check for wins
    if (paylineSymbols.every((symbol) => symbol == paylineSymbols[0])) {
      // All symbols match - big win
      int winAmount = _getSymbolValue(paylineSymbols[0]) * 10;
      _awardWin(winAmount);
      _showWinDialog("JACKPOT! All symbols match!", winAmount);
    } else if (paylineSymbols.where((symbol) => symbol == '7️⃣').length >= 2) {
      // Two or more 7s - medium win
      _awardWin(50);
      _showWinDialog("Big Win! Two or more 7s!", 50);
    } else if (paylineSymbols.where((symbol) => symbol == '💎').length >= 2) {
      // Two or more diamonds - small win
      _awardWin(30);
      _showWinDialog("Nice! Two or more diamonds!", 30);
    } else {
      // Check for any pair
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
  }
  
  void _showWinDialog(String message, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber[800],
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
      color: Color(0xFF2c2c2e),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              "LUCKY SLOTS",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 20),
            
            // Credits display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Text(
                "CREDITS: $credits",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            
            // Slot machine body
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber[700]!, width: 3),
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
            
            // Spin button
            ElevatedButton(
              onPressed: isSpinning ? null : _spin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                disabledBackgroundColor: Colors.grey,
                elevation: 5,
              ),
              child: Text(
                isSpinning ? "SPINNING..." : "SPIN (10 CREDITS)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            SizedBox(height: 20),
            Text(
              "Match symbols to win prizes!",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
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
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
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
                          top: BorderSide(color: Colors.amber, width: 1),
                          bottom: BorderSide(color: Colors.amber, width: 1),
                        ),
                      ),
                    ),
                    Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
                  ],
                ),
              ),
            ),
            // Add a slight blur effect at the top and bottom to enhance the spinning effect
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