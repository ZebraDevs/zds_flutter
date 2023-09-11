import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class ColorExample {
  final String name;
  final Color color;

  ColorExample(this.color, this.name);
}

class ColorSwatchExample {
  final String name;
  final ZetaColorSwatch color;

  ColorSwatchExample(this.color, this.name);
}

class ColorsDemo extends StatelessWidget {
  const ColorsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColors = [
      {
        'color': Theme.of(context).colorScheme.primary,
        'name': 'Primary',
        'subtitle': 'Theme.of(context).colorScheme.primary',
      },
      {
        'color': Theme.of(context).colorScheme.secondary,
        'name': 'Secondary',
        'subtitle': 'Theme.of(context).colorScheme.secondary',
      },
      {
        'color': Theme.of(context).colorScheme.primaryContainer,
        'name': 'Tertiary',
        'subtitle': 'Theme.of(context).colorScheme.primaryContainer',
      },
      {
        'color': Theme.of(context).colorScheme.secondaryContainer,
        'name': 'Quaternary',
        'subtitle': 'Theme.of(context).colorScheme.secondaryContainer',
      },
    ];
    final List<Map<String, Object>> greys = [
      {
        'color': ZdsColors.black,
        'name': 'Black',
        'subtitle': 'ZdsColors.black',
      },
      {
        'color': ZdsColors.darkGrey,
        'name': 'Grey 1',
        'subtitle': 'ZdsColors.darkGrey',
      },
      {
        'color': ZdsColors.blueGrey,
        'name': 'Grey 2',
        'subtitle': 'ZdsColors.blueGrey',
      },
      {
        'color': ZdsColors.lightGrey,
        'name': 'Grey 3',
        'subtitle': 'ZdsColors.lightGrey',
      },
      {
        'color': ZdsColors.white,
        'name': 'White',
        'subtitle': 'ZdsColors.white',
      },
    ];
    final otherColors = [
      {
        'color': ZdsColors.red,
        'name': 'Red',
        'subtitle': 'ZdsColors.red',
      },
      {
        'color': ZdsColors.green,
        'name': 'Green',
        'subtitle': 'ZdsColors.green',
      },
      {
        'color': ZdsColors.yellow,
        'name': 'Yellow',
        'subtitle': 'ZdsColors.yellow',
      },
      {
        'color': ZdsColors.orange,
        'name': 'Orange',
        'subtitle': 'ZdsColors.orange',
      },
    ];
    final theme = [
      {
        'color': Theme.of(context).colorScheme.primary,
        'name': 'primary',
        'subtitle': 'Theme.of(context).colorScheme.primary',
      },
      {
        'color': Theme.of(context).colorScheme.onPrimary,
        'name': 'onPrimary',
        'subtitle': 'Theme.of(context).colorScheme.onPrimary',
      },
      {
        'color': Theme.of(context).colorScheme.primaryContainer,
        'name': 'primaryContainer',
        'subtitle': 'Theme.of(context).colorScheme.primaryContainer',
      },
      {
        'color': Theme.of(context).colorScheme.onPrimaryContainer,
        'name': 'onPrimaryContainer',
        'subtitle': 'Theme.of(context).colorScheme.onPrimaryContainer',
      },
      {
        'color': Theme.of(context).colorScheme.secondary,
        'name': 'secondary',
        'subtitle': 'Theme.of(context).colorScheme.secondary',
      },
      {
        'color': Theme.of(context).colorScheme.onSecondary,
        'name': 'onSecondary',
        'subtitle': 'Theme.of(context).colorScheme.onSecondary',
      },
      {
        'color': Theme.of(context).colorScheme.secondaryContainer,
        'name': 'secondaryContainer',
        'subtitle': 'Theme.of(context).colorScheme.secondaryContainer',
      },
      {
        'color': Theme.of(context).colorScheme.onSecondaryContainer,
        'name': 'onSecondaryContainer',
        'subtitle': 'Theme.of(context).colorScheme.onSecondaryContainer',
      },
      {
        'color': Theme.of(context).colorScheme.surface,
        'name': 'surface',
        'subtitle': 'Theme.of(context).colorScheme.surface',
      },
      {
        'color': Theme.of(context).colorScheme.onSurface,
        'name': 'onSurface',
        'subtitle': 'Theme.of(context).colorScheme.onSurface',
      },
      {
        'color': Theme.of(context).colorScheme.background,
        'name': 'background',
        'subtitle': 'Theme.of(context).colorScheme.background',
      },
      {
        'color': Theme.of(context).colorScheme.onBackground,
        'name': 'onBackground',
        'subtitle': 'Theme.of(context).colorScheme.onBackground',
      },
      {
        'color': Theme.of(context).colorScheme.error,
        'name': 'error',
        'subtitle': 'Theme.of(context).colorScheme.error',
      },
      {
        'color': Theme.of(context).colorScheme.onError,
        'name': 'onError',
        'subtitle': 'Theme.of(context).colorScheme.onError',
      },
    ];

    final List<ColorSwatchExample> zeta = ZetaColors.of(context).rainbow.map((e) => ColorSwatchExample(e, '')).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ZDS Colors', style: Theme.of(context).textTheme.displayLarge).paddingOnly(left: 16),
              _ColorRow(colors: primaryColors, title: 'Theme colors'),
              _ColorRow(colors: greys, title: 'Greys'),
              _ColorRow(colors: otherColors, title: 'Other colors'),
              const _PrimarySwatches(),
              const _OtherSwatches(),
              _ColorRow(colors: theme, title: 'All theme ColorScheme colors'),
              const _Spacer(),
              const _Spacer(),
              Text('Zeta Colors', style: Theme.of(context).textTheme.displayLarge).paddingOnly(left: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: zeta
                      .map(
                        (e) => Column(
                          children: List.generate(
                            10,
                            (index) => _ColorBoxZeta(
                              color: e.color[(index + 1) * 10]!,
                              text: ((index + 1) * 10).toString(),
                              compact: true,
                              screenWidth: constraints.maxWidth,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColorBoxZeta extends StatelessWidget {
  final Color color;
  final String text;
  final bool compact;
  final double screenWidth;

  const _ColorBoxZeta(
      {Key? key, required this.color, required this.text, required this.screenWidth, this.compact = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 100 : 150,
      width: (screenWidth * (compact ? 0.25 : 0.5)).clamp(1, 300),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: computeForeground(color)),
          ),
          Text(
            color.toHexNoAlpha().toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: computeForeground(color)),
          ),
        ],
      ).padding(16),
    );
  }
}

class _OtherSwatches extends StatelessWidget {
  const _OtherSwatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Spacer(),
        Row(
          children: [
            const _Spacer(),
            Text(
              'Other Swatches',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        const _Spacer(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Spacer(),
              _Swatch(
                swatch: ZdsColors.redSwatch,
                values: [
                  {'val': 'fair', 'display': 'fair'},
                  {'val': 'light', 'display': 'light'},
                  {'val': 'medium', 'display': 'medium'},
                  {'val': 'dark', 'display': 'dark'},
                ],
                headColor: ZdsColors.red,
                headText: 'Red',
              ),
              _Spacer(),
              _Swatch(
                swatch: ZdsColors.greenSwatch,
                values: [
                  {'val': 'light', 'display': 'light'},
                  {'val': 'medium', 'display': 'medium'},
                  {'val': 'dark', 'display': 'dark'},
                ],
                headColor: ZdsColors.green,
                headText: 'Green',
              ),
              _Spacer(),
            ],
          ),
        ),
        const _Spacer(),
        const _Spacer(),
      ],
    );
  }
}

class _PrimarySwatches extends StatelessWidget {
  const _PrimarySwatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const _Spacer(),
            Text(
              'Primary Swatches',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        const _Spacer(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Spacer(),
              _Swatch(
                swatch: ZdsColors.primarySwatch(context),
                values: List.generate(9, (i) => {'val': (i + 1) * 100, 'display': '${(i + 1) * 10}%'}),
                headColor: Theme.of(context).colorScheme.primary,
                headText: 'Primary',
              ),
              const _Spacer(),
              _Swatch(
                swatch: ZdsColors.secondarySwatch(context),
                values: List.generate(9, (i) => {'val': (i + 1) * 100, 'display': '${(i + 1) * 10}%'}),
                headColor: Theme.of(context).colorScheme.secondary,
                headText: 'Secondary',
              ),
              const _Spacer(),
              _Swatch(
                swatch: ZdsColors.greyWarmSwatch,
                values: [
                  const {'val': 50, 'display': 50},
                  ...List.generate(12, (i) => {'val': (i + 1) * 100, 'display': (i + 1) * 100})
                ],
                headColor: ZdsColors.darkGrey,
                headText: 'Warm grey',
              ),
              const _Spacer(),
              _Swatch(
                swatch: ZdsColors.greyCoolSwatch,
                values: [
                  const {'val': 50, 'display': 50},
                  ...List.generate(12, (i) => {'val': (i + 1) * 100, 'display': (i + 1) * 100})
                ],
                headColor: ZdsColors.blueGrey,
                headText: 'Cool grey',
              ),
              const _Spacer(),
            ],
          ),
        ),
        const _Spacer(),
        const _Spacer(),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  final List<Map<String, Object>> colors;
  final String title;
  const _ColorRow({Key? key, required this.colors, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Spacer(),
        Row(
          children: [
            const _Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        const _Spacer(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: (colors
                    .map((e) => _ColorBox(
                          color: e['color'] as Color,
                          text: e['name'] as String,
                          subtitle: e['subtitle'] as String,
                        ))
                    .toList())
                .divide(const _Spacer())
                .toList()
              ..insert(0, const _Spacer()),
          ),
        ),
        const _Spacer(),
        const _Spacer(),
      ],
    );
  }
}

class _Spacer extends StatelessWidget {
  const _Spacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20, width: 20);
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String text;
  final String subtitle;
  const _ColorBox({Key? key, required this.color, required this.text, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 330,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: computeForeground(color)),
          ),
          Text(
            color.toHexNoAlpha().toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: computeForeground(color)),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: computeForeground(color)),
          ),
        ],
      ).padding(16),
    );
  }
}

class _Swatch extends StatelessWidget {
  final ColorSwatch swatch;
  final Color headColor;
  final String headText;
  final List<Map> values;

  const _Swatch({Key? key, required this.swatch, required this.values, required this.headColor, required this.headText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 122,
          width: 260,
          color: headColor,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              headText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: computeForeground(headColor)),
            ),
            const Expanded(child: SizedBox()),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: computeForeground(headColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('100%'), Text(headColor.toHexNoAlpha().toUpperCase())],
              ),
            )
          ]),
        ),
        ...values.map((Map element) {
          final Color color = swatch[element['val']] ?? Colors.black;
          return Container(
            height: 34,
            width: 260,
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  element['display'].toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: computeForeground(color)),
                ),
                Text(
                  color.toHexNoAlpha().toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: computeForeground(color)),
                ),
              ],
            ).paddingOnly(left: 20, right: 20),
          );
        }).toList()
      ],
    );
  }
}
