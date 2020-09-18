import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

const bodyStyle = TextStyle(fontSize: 19.0);
const pageDecoration = const PageDecoration(
  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
  bodyTextStyle: bodyStyle,
  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.white,
  imagePadding: EdgeInsets.zero,
);

class Onboarding extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TasksScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Align(
        child: Image.asset('assets/$assetName', height: 400,  width: 400),
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Check It Off!",
          body: "View your list of things to do.",
          image: _buildImage('onboarding/onboarding1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Add A Task",
          body: "Give the task a name and priority.",
          image: _buildImage('onboarding/onboarding2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Edit Existing Tasks",
          body:
              "Need to change a task's name?  No problem simply click the edit button on the main page and alter the name and/or priority.",
          image: _buildImage('onboarding/onboarding3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Change The Task Order",
          body:
              "You can order by the order entered, alphabetic, reverse alphabetic, and by priority grouping.",
          image: _buildImage('onboarding/onboarding4.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
