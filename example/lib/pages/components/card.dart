import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';

class CardDemo extends StatelessWidget {
  const CardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ZdsCard(
                  onTap: () {},
                  onTapHint: 'perform action',
                  semanticLabel: 'semantic label',
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const SizedBox(
                    height: 200,
                    width: 300,
                    child: Text('color and ontap'),
                  ),
                ),
                const SizedBox(height: 10),
                ZdsCard(
                  variant: ZdsCardVariant.outlined,
                  onTap: () {},
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xff0CACF0),
                      Color(0xff007ABA),
                    ],
                  ),
                  child: const SizedBox(
                    height: 200,
                    width: 300,
                    child: Text('Outline, gradient and ontap'),
                  ),
                ),
                const SizedBox(height: 16),
                ZdsCard(
                  onTap: () {},
                  child: const SizedBox(
                    height: 200,
                    width: 300,
                    child: Text('default color and ontap'),
                  ),
                ),
                const SizedBox(height: 16),
                ZdsCard(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const SizedBox(
                    height: 200,
                    width: 300,
                    child: Text('color and no ontap'),
                  ),
                ),
                const SizedBox(height: 16),
                ZdsCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ZdsCardHeader(
                        leading: IconTheme.merge(
                          data: IconThemeData(size: 20, color: Theme.of(context).colorScheme.primary),
                          child: const Icon(ZdsIcons.walk)
                              .frame(width: 30, height: 30, alignment: Alignment.center)
                              .backgroundColor(Theme.of(context).colorScheme.primary.withLight(0.1))
                              .circle(30),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Transform.rotate(
                            angle: math.pi / 2,
                            child: Icon(ZdsIcons.more_vert, color: Zeta.of(context).colors.iconSubtle),
                          ),
                        ),
                        child: const Text('With Header'),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
                const SafeArea(
                  top: false,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
