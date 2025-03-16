import 'package:flutter/material.dart';
import '../globals.dart';
import 'dart:async';
import 'dart:math';

import 'package:technik/widgets/header_widget.dart';

class SlotMachineWidget extends StatefulWidget {
  final Function(int) onWin;
  // initialCredits parameter is no longer used since we rely on global points.
  const SlotMachineWidget({
    Key? key,
    required this.onWin,
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
    
    // Set up curved animations for a realistic slot machine effect
    animations = animControllers.map((controller) => 
      CurvedAnimation(
        parent: controller,
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
    // Use global points instead of a local credits variable.
    if (points < 10 || isSpinning) return;

    print(points);
    
    setState(() {
      points -= 10; // Deduct spin cost from global points
      isSpinning = true;
    });
    
    // Determine the final symbols for each reel
    List<List<int>> newFinalIndices = List.generate(
      reelCount, 
      (_) => List.generate(3, (_) => Random().nextInt(symbols.length))
    );
    
    // Update the reel strips to ensure our final symbols will be visible
    for (int i = 0; i < reelCount; i++) {
      for (int j = 0; j < 3; j++) {
        reelStrips[i][j] = symbols[newFinalIndices[i][j]];
      }
    }
    
    // Reset animations and scroll positions
    for (int i = 0; i < reelCount; i++) {
      animControllers[i].reset();
      scrollControllers[i].jumpTo((symbolsPerReel - 3) * symbolHeight);
    }
    
    // Start animations with staggered delays
    for (int i = 0; i < reelCount; i++) {
      final controller = animControllers[i];
      final scrollController = scrollControllers[i];
      
      Future.delayed(Duration(milliseconds: i * 200), () {
        controller.forward().whenComplete(() {
          if (i == reelCount - 1) {
            finalSymbolIndices = newFinalIndices;
            _checkWin();
            setState(() {
              isSpinning = false;
            });
          }
        });
        
        // Update scroll position as the animation runs.
        controller.addListener(() {
          double maxScroll = (symbolsPerReel - 3) * symbolHeight;
          double scrollPosition = maxScroll * (1 - controller.value);
          scrollController.jumpTo(scrollPosition);
        });
      });
    }
  }
  
  void _checkWin() {
    // Get symbols at the payline (middle position)
    List<String> paylineSymbols = List.generate(
      reelCount, 
      (i) => symbols[finalSymbolIndices[i][1]]
    );
    
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
      points += amount; // Add win amount to global points
    });
    widget.onWin(amount);
  }
  
  void _showWinDialog(String message, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
          SizedBox(height: 30),
          // Slot machine body
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
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
          // Spin button
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
              isSpinning ? "SPINNING..." : "SPIN (10 POINTS)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
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
