import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimeProp {opacity, offset}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  final tween = TimelineTween<AnimeProp>(curve: Curves.easeOut)..addScene(begin: 0.milliseconds, duration: 1000.milliseconds)
      .animate(AnimeProp.offset, tween: 100.0.tweenTo(0.0))
    ..addScene(begin: 0.milliseconds, duration: 1500.milliseconds)
        .animate(AnimeProp.opacity, tween: 0.0.tweenTo(1.0));

  @override
  Widget build(BuildContext context) {


    return CustomAnimation(
      tween: tween,
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AnimeProp.opacity),
        child: Transform.translate(
            offset: Offset(animation.get(AnimeProp.offset), 0), child: child),
      ),
    );
  }
}