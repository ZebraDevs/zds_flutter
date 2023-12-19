import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

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
        'subtitle': 'Zeta.of(context).colors.primary | Theme.of(context).colorScheme.primary',
      },
      {
        'color': Theme.of(context).colorScheme.secondary,
        'name': 'Secondary',
        'subtitle': 'Zeta.of(context).colors.secondary | Theme.of(context).colorScheme.secondary',
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
    final List<Map<String, Object>> greys = [
      {
        'color': Zeta.of(context).colors.black,
        'name': 'Black',
        'subtitle': 'Zeta.of(context).colors.black',
      },
      {
        'color': Zeta.of(context).colors.white,
        'name': 'White',
        'subtitle': 'Zeta.of(context).colors.white',
      },
    ];
    final alertColors = [
      {
        'color': Zeta.of(context).colors.positive,
        'name': 'Positive',
        'subtitle': 'Zeta.of(context).colors.positive',
      },
      {
        'color': Zeta.of(context).colors.negative,
        'name': 'Negative',
        'subtitle': 'Zeta.of(context).colors.negative',
      },
      {
        'color': Zeta.of(context).colors.warning,
        'name': 'Warning',
        'subtitle': 'Zeta.of(context).colors.warning',
      },
      {
        'color': Zeta.of(context).colors.info,
        'name': 'Info',
        'subtitle': 'Zeta.of(context).colors.info',
      },
    ];

    final List<ColorSwatchExample> zeta =
        Zeta.of(context).colors.rainbow.map((e) => ColorSwatchExample(e, '')).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ColorRow(colors: theme, title: 'Theme colors'),
              _ColorRow(colors: primaryColors, title: 'Primary colors'),
              _ColorRow(colors: greys, title: 'Greys'),
              _ColorRow(colors: alertColors, title: 'Alert colors'),
              const _PrimarySwatches(),
              const _OtherSwatches(),
              const _Spacer(),
              Text('Zeta Colors', style: Theme.of(context).textTheme.displayLarge).paddingOnly(left: 16),
              const _Spacer(),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color.onColor),
          ),
          Text(
            color.toHexNoAlpha().toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color.onColor),
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
    final swatches = [
      {
        'key': 'Red',
        'value': Zeta.of(context).colors.red,
      },
      {
        'key': 'Orange',
        'value': Zeta.of(context).colors.orange,
      },
      {
        'key': 'Yellow',
        'value': Zeta.of(context).colors.yellow,
      },
      {
        'key': 'Green',
        'value': Zeta.of(context).colors.green,
      },
      {
        'key': 'Blue',
        'value': Zeta.of(context).colors.blue,
      },
      {
        'key': 'Teal',
        'value': Zeta.of(context).colors.teal,
      },
      {
        'key': 'Pink',
        'value': Zeta.of(context).colors.pink,
      },
    ];
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
              for (final swatch in swatches) ...[
                _Spacer(),
                _Swatch(
                  swatch: swatch['value'] as ZetaColorSwatch,
                  values: [
                    {'val': 10, 'display': '10'},
                    {'val': 20, 'display': '20'},
                    {'val': 30, 'display': '30'},
                    {'val': 40, 'display': '40'},
                    {'val': 50, 'display': '50'},
                    {'val': 60, 'display': '60'},
                    {'val': 70, 'display': '70'},
                    {'val': 80, 'display': '80'},
                    {'val': 90, 'display': '90'},
                    {'val': 100, 'display': '100'},
                  ],
                  headColor: swatch['value'] as ZetaColorSwatch,
                  headText: swatch['key'] as String,
                ),
              ],
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
                swatch: Zeta.of(context).colors.primary,
                values: List.generate(10, (i) => {'val': (i + 1) * 10, 'display': '${(i + 1) * 10}%'}),
                headColor: Theme.of(context).colorScheme.primary,
                headText: 'Primary',
              ),
              const _Spacer(),
              _Swatch(
                swatch: Zeta.of(context).colors.secondary,
                values: List.generate(10, (i) => {'val': (i + 1) * 10, 'display': '${(i + 1) * 10}%'}),
                headColor: Theme.of(context).colorScheme.secondary,
                headText: 'Secondary',
              ),
              const _Spacer(),
              _Swatch(
                swatch: Zeta.of(context).colors.warm,
                values: List.generate(10, (i) => {'val': (i + 1) * 10, 'display': '${(i + 1) * 10}%'}),
                headColor: Zeta.of(context).colors.warm,
                headText: 'Warm grey',
              ),
              const _Spacer(),
              _Swatch(
                swatch: Zeta.of(context).colors.cool,
                values: List.generate(10, (i) => {'val': (i + 1) * 10, 'display': '${(i + 1) * 10}%'}),
                headColor: Zeta.of(context).colors.cool,
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
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color.onColor),
          ),
          Text(
            color.toHexNoAlpha().toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color.onColor),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color.onColor),
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: headColor.onColor),
            ),
            const Expanded(child: SizedBox()),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: headColor.onColor),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color.onColor),
                ),
                Text(
                  color.toHexNoAlpha().toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color.onColor),
                ),
              ],
            ).paddingOnly(left: 20, right: 20),
          );
        }).toList()
      ],
    );
  }
}
