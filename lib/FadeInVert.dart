import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimationProp {opacity, offset}

class FadeInVert extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInVert(this.delay, this.child);

  final tween = TimelineTween<AnimationProp>(curve: Curves.easeOut)
    ..addScene(begin: 0.milliseconds, duration: 1500.milliseconds)
        .animate(AnimationProp.opacity, tween: 0.0.tweenTo(1.0))
    ..addScene(begin: 0.milliseconds, duration: 1000.milliseconds)
        .animate(AnimationProp.offset, tween: 30.0.tweenTo(0.0));

  @override
  Widget build(BuildContext context) {
    return CustomAnimation(
      tween: tween,
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AnimationProp.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AnimationProp.offset)), child: child),
      ),
    );
  }
}