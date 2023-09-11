import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zds_flutter/zds_flutter.dart';

class AnimationsDemo extends StatelessWidget {
  const AnimationsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List animations = [
      {
        'name': 'ZdsAnimations.checkCircle',
        'animation': ZdsAnimations.checkCircle,
      },
      {
        'name': 'ZdsAnimations.twoChecks',
        'animation': ZdsAnimations.twoChecks,
      },
      {
        'name': 'ZdsAnimations.thumbsUpApproved',
        'animation': ZdsAnimations.thumbsUpApproved,
      },
      {
        'name': 'ZdsAnimations.thumbsUp',
        'animation': ZdsAnimations.thumbsUp,
      },
      {
        'name': 'ZdsAnimations.checkRipple',
        'animation': ZdsAnimations.checkRipple,
      },
      {
        'name': 'ZdsAnimations.timeApprovedBox',
        'animation': ZdsAnimations.timeApprovedBox,
      },
      {
        'name': 'ZdsAnimations.approvalStamped',
        'animation': ZdsAnimations.approvalStamped,
      },
      {
        'name': 'ZdsAnimations.check',
        'animation': ZdsAnimations.check,
      },
      {
        'name': 'ZdsAnimations.checkGlimmer',
        'animation': ZdsAnimations.checkGlimmer,
      },
      {
        'name': 'ZdsAnimations.timeApproved',
        'animation': ZdsAnimations.timeApproved,
      },
      {
        'name': 'ZdsAnimations.timecardTapping',
        'animation': ZdsAnimations.timecardTapping,
      },
      {
        'name': 'ZdsAnimations.timeApprovedGlimmer',
        'animation': ZdsAnimations.timeApprovedGlimmer,
      },
    ]..sort((a, b) => a['name'].compareTo(b['name']));
    return Wrap(
      spacing: 80,
      runSpacing: 80,
      children: animations.map((e) => AnimationBox(name: e['name'], animation: e['animation'])).toList(),
    );
  }
}

class AnimationBox extends StatelessWidget {
  final String name;
  final String animation;

  const AnimationBox({Key? key, required this.name, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200 * MediaQuery.devicePixelRatioOf(context),
      height: 200 * MediaQuery.devicePixelRatioOf(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(animation, height: 84),
          const SizedBox(height: 8),
          Text(name),
        ],
      ),
    );
  }
}
