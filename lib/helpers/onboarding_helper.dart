import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding.dart';

class OnboardingHelper{
  void onboarded(var context) async {
    final prefs = await SharedPreferences.getInstance();
    bool ran = prefs.getBool('onboarded');
    String version = prefs.getString('onboardedVersion');
    prefs.setBool("onboarded", true);
    prefs.setString('onboardedVersion', '1.0.1');
    try {
      if (!ran || version != '1.0.1') {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Onboarding()));
      }
    } catch (e) {
      print('Onboarding has not run.');
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Onboarding()));
    }
  }
}