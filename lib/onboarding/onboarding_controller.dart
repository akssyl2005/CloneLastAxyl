import 'package:flutter/material.dart';

class OnBoardingController {
  late final PageController pageController;

  OnBoardingController() {
    pageController = PageController(initialPage: 0);
  }

  void nextPage() {
    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void dispose() {
    pageController.dispose();
  }
}