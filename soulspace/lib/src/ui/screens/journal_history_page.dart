// src/ui/screens/journal_history_page.dart
import 'package:flutter/material.dart';

class JournalHistoryPage extends StatelessWidget {
  const JournalHistoryPage({super.key});

  final List<Map<String, dynamic>> mockEntries = const [
    {
      "title": "Today was best day",
      "preview": "I felt it building up all day, a lump in my throat finally turned into happy tears...",
      "date": "24/08/25",
      "color": Color(0xFFFFE4E1),
    },
    {
      "title": "Worst day of my life",
      "preview": "Today, I am feeling sad because of my exam results. I tried so hard but...",
      "date": "16/08/24",
      "color": Color(0xFFFFF3E0),
    },
    {
      "title": "Today was best day",
      "preview": "I made a cake for my friends and seeing their smiles made my heart so full...",
      "date": "22/06/24",
      "color": Color(0xFFE8F5E9),
    },
    {
      "title": "Stressed",
      "preview": "Feeling really overwhelmed with work and exams. I just want to breathe again...",
      "date": "10/05/24",
      "color": Color(0xFFFCE4EC),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Color(0xFFFFCFCF), shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Your story, your space",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Let your thoughts flow...",
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
              ),
            ),

            const SizedBox(height: 30),

            // Boy Illustration
            Center(
              child: Image.asset(
                "assets/images/history.png",
                width: 200,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 5),

            // "What happened today?" Card — FIXED: WIDER, CENTERED, NO OVERFLOW!
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Reduced padding
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(color: Color(0xFFFF9A9E), shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 24),
                    const Flexible(
                      child: Text(
                        "What happened today?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Past Entries List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: mockEntries.length,
                itemBuilder: (context, index) {
                  final entry = mockEntries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: entry["color"],
                        borderRadius: BorderRadius.circular(40),
                        
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry["title"],
                                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry["preview"],
                                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "created on ${entry["date"]}",
                                  style: TextStyle(fontSize: 13.5, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 22),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}