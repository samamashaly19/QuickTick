import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingWidget extends StatelessWidget {
  final OnboardingItem item;
  final bool isLastPage;
  final VoidCallback onGetStartedPressed;

  const OnboardingWidget({
    Key? key,
    required this.item,
    required this.isLastPage,
    required this.onGetStartedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.checklist,
              size: 80,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (isLastPage)
            ElevatedButton(
              onPressed: onGetStartedPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}