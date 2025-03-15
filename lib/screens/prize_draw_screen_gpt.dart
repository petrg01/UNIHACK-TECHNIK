// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';

// class PrizeDrawScreen extends StatefulWidget {
//   @override
//   _PrizeDrawScreenState createState() => _PrizeDrawScreenState();
// }

// class _PrizeDrawScreenState extends State<PrizeDrawScreen> {
//   final List<String> symbols = ["🍒", "🍋", "🍊", "🍇", "⭐", "💎"]; // Slot symbols
//   final Random random = Random();
//   bool isSpinning = false;

//   // PageControllers for each reel
//   final List<PageController> controllers =
//       List.generate(3, (_) => PageController(initialPage: 50));

//   void spinSlots() {
//     if (isSpinning) return; // Prevent multiple presses
//     setState(() {
//       isSpinning = true;
//     });

//     int totalSpins = 30; // Number of spin cycles
//     int baseDuration = 100; // Speed of animation

//     for (int i = 0; i < controllers.length; i++) {
//       Future.delayed(Duration(milliseconds: i * 600), () { // Staggered stop times
//         int finalPosition = random.nextInt(symbols.length) + 50; // Stop at a random symbol

//         Timer.periodic(Duration(milliseconds: baseDuration), (timer) {
//           if (totalSpins > 0) {
//             controllers[i].animateToPage(
//               controllers[i].page!.toInt() + 1,
//               duration: Duration(milliseconds: baseDuration),
//               curve: Curves.easeInOut,
//             );
//           } else {
//             timer.cancel();
//             controllers[i].animateToPage(
//               finalPosition,
//               duration: Duration(milliseconds: 1000), // Slow stop
//               curve: Curves.easeOutCubic,
//             );

//             if (i == controllers.length - 1) {
//               setState(() {
//                 isSpinning = false; // Enable button after all reels stop
//               });
//             }
//           }
//           totalSpins--;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF2c2c2e),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Prize Draw",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),

//             // Slot Machine UI
//             Container(
//               width: 250,
//               height: 180, // Increased height for visibility of neighboring slots
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(3, (index) {
//                   return SizedBox(
//                     width: 60, // Individual reel width
//                     height: 150, // Reel height
//                     child: PageView.builder(
//                       controller: controllers[index],
//                       scrollDirection: Axis.vertical,
//                       physics: NeverScrollableScrollPhysics(), // Disable manual scrolling
//                       itemBuilder: (context, i) {
//                         return Center(
//                           child: Text(
//                             symbols[i % symbols.length], // Loop through symbols
//                             style: TextStyle(fontSize: 50, color: Colors.white),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Spin Button
//             ElevatedButton(
//               onPressed: isSpinning ? null : spinSlots,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//               child: Text(
//                 isSpinning ? "Spinning..." : "Spin",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
