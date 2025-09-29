import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      image: 'assets/onboarding1.png',
      title: 'Welcome to QuickTick',
      description: 'Organize your tasks efficiently and boost your productivity.',
    ),
    OnboardingItem(
      image: 'assets/onboarding2.png',
      title: 'Manage Your Tasks',
      description: 'Add, complete, and track your daily tasks with ease.',
    ),
    OnboardingItem(
      image: 'assets/onboarding3.png',
      title: 'Get Things Done',
      description: 'Stay organized and never miss an important task again.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage < _onboardingItems.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    todoProvider.completeOnboarding();
                  },
                  child: const Text('Skip'),
                ),
              ),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingWidget(
                    item: _onboardingItems[index],
                    isLastPage: index == _onboardingItems.length - 1,
                    onGetStartedPressed: () {
                      todoProvider.completeOnboarding();
                    },
                  );
                },
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingItems.length,
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}