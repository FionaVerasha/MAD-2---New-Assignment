import 'package:flutter/material.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEBF5E), // Vibrant orange background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5EADD), // Light greenish-grey card
              borderRadius: BorderRadius.circular(40),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                children: [
                  // Paw icons in top right
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Opacity(
                      opacity: 0.4,
                      child: Column(
                        children: [
                          const Icon(Icons.pets, color: Colors.white, size: 35),
                          const SizedBox(height: 25),
                          Transform.rotate(
                            angle: 0.5,
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Image at the bottom filling width
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1541364983171-a8ba01e456c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                      height: MediaQuery.of(context).size.height * 0.55,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.pets, size: 50),
                        );
                      },
                    ),
                  ),
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          "Whisker\nCart",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF231F20),
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Pet care at your fingertips!\nQuality products delivered to you.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B6B6B),
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // "Let's GO!" Button at the bottom
                  Positioned(
                    bottom: 30,
                    left: 40,
                    right: 40,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Let's GO!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
