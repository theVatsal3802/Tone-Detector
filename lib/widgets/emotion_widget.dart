import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EmotionWidget extends StatelessWidget {
  final String text;
  final double percent;
  const EmotionWidget({
    super.key,
    required this.text,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            textScaleFactor: 1,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        LinearPercentIndicator(
          alignment: MainAxisAlignment.start,
          percent: percent,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          lineHeight: 20,
          barRadius: const Radius.circular(20),
          center: Text(
            "${(percent * 100).toStringAsFixed(2)} %",
            textScaleFactor: 1,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          progressColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
