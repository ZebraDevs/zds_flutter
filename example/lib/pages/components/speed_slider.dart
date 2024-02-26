import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class SpeedSliderDemo extends StatefulWidget {
  const SpeedSliderDemo({super.key});

  @override
  State<SpeedSliderDemo> createState() => _SpeedSliderDemoState();
}

class _SpeedSliderDemoState extends State<SpeedSliderDemo> {
  int currentIndex = 0;
  final sliderKey = GlobalKey<ZdsSpeedSliderState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZdsButton.filled(
            child: Text('Jump to letter'),
            onTap: () {
              sliderKey.currentState!.setIndex(23);
            },
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'The currently selected item',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ZdsSpeedSlider.defaultItems[currentIndex],
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ZdsSpeedSlider(
                  key: sliderKey,
                  height: 400,
                  onChange: (newVal) {
                    setState(() {
                      currentIndex = newVal;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
