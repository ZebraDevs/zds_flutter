import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class ShakeExample extends StatefulWidget {
  const ShakeExample({Key? key}) : super(key: key);

  @override
  State<ShakeExample> createState() => _ShakeExampleState();
}

class _ShakeExampleState extends State<ShakeExample> {
  late final _shakeOnce = GlobalKey<ZdsShakeAnimationState>();
  late final _shakeTwice = GlobalKey<ZdsShakeAnimationState>();
  late final _shakeThrice = GlobalKey<ZdsShakeAnimationState>();

  bool isDanger = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ZdsList(
              children: [
                Column(
                  children: [
                    ZdsShakeAnimation(
                      key: _shakeOnce,
                      shakeCount: 1,
                      shakeOffset: 5,
                      onAnimationUpdate: (status) {
                        setState(() {
                          isDanger = status == AnimationStatus.reverse || status == AnimationStatus.forward;
                        });
                      },
                      shakeDuration: const Duration(milliseconds: 500),
                      child: ZdsButton.filled(
                        isDangerButton: isDanger,
                        child: const Text('Shake once'),
                        onTap: () {
                          _shakeOnce.currentState?.shake();
                        },
                      ),
                    ),
                    ZdsShakeAnimation(
                      key: _shakeTwice,
                      shakeCount: 2,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 300),
                      child: ZdsButton.outlined(
                        child: const Text('Shake Twice'),
                        onTap: () {
                          _shakeTwice.currentState?.shake();
                        },
                      ),
                    ),
                    ZdsShakeAnimation(
                      key: _shakeThrice,
                      shakeOffset: 20,
                      shakeDuration: const Duration(milliseconds: 250),
                      child: ZdsButton.filled(
                        child: const Text('Shake Thrice'),
                        onTap: () {
                          _shakeThrice.currentState?.shake();
                        },
                      ),
                    ),
                  ].divide(const SizedBox(height: 40)).toList(growable: false),
                )
              ],
            ),
          ),
          ZdsButton.filled(
            child: const Text('Shake All'),
            onTap: () {
              _shakeOnce.currentState?.shake();
              _shakeTwice.currentState?.shake();
              _shakeThrice.currentState?.shake();
            },
          ),
        ],
      ),
    );
  }
}
