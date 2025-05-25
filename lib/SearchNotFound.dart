import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Search(),
        ]),
      ),
    );
  }
}

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 440,
          height: 956,
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  // Search bar background
                  Positioned(
                    left: 60,
                    top: 117,
                    child: Container(
                      width: 319,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 19,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  // Search icon
                  Positioned(
                    left: 80,
                    top: 135,
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  // Search text
                  Positioned(
                    left: 121,
                    top: 136,
                    child: Text(
                      'Healthy Food',
                      style: TextStyle(
                        color: const Color(0xFF3C2F2F),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                 
                  
                  // "Item not found" text
                  Positioned(
                    left: 101,
                    top: 445,
                    child: Text(
                      'Item not found',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  
                  // Subtitle text
                  Positioned(
                    left: 114,
                    top: 509,
                    child: Text(
                      'Try searching the item with\n a different keyword',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF5E5F60),
                        fontSize: 16,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  
                  // Illustration image
                  Positioned(
                    left: 137,
                    top: 266,
                    child: SizedBox(
                      width: 156,
                      height: 157,
                      child: Image.network(
                        "https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      ),
                    ),
                  ),
                  
                  // Back button
                  Positioned(
                    left: 15,
                    top: 53,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFEDEDED),
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  // Status bar
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 440,
                      height: 44,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 32,
                            top: 0,
                            child: SizedBox(
                              width: 375,
                              height: 44,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: SizedBox(width: 375, height: 44),
                                  ),
                                  Positioned(
                                    left: 336,
                                    top: 17.33,
                                    child: Opacity(
                                      opacity: 0.35,
                                      child: Container(
                                        width: 22,
                                        height: 11.33,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 1,
                                              color: Color(0xFF0F0F0F),
                                            ),
                                            borderRadius: BorderRadius.circular(2.67),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 338,
                                    top: 19.33,
                                    child: Container(
                                      width: 18,
                                      height: 7.33,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F0F0F),
                                        borderRadius: BorderRadius.circular(1.33),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 21,
                                    top: 12,
                                    child: SizedBox(
                                      width: 54,
                                      height: 20,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: -1,
                                            top: 2,
                                            child: SizedBox(
                                              width: 54,
                                              child: Text(
                                                '9:41',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Color(0xFF0F0F0F),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.43,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}