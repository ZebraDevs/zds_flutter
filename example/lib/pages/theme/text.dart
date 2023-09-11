import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({Key? key}) : super(key: key);

//?TODO: Integrate and use Zeta text themes
  @override
  Widget build(BuildContext context) {
    final display = [
      {
        'header': 'Display Large',
        'textStyle': Theme.of(context).textTheme.displayLarge,
      },
      {
        'header': 'Display Medium',
        'textStyle': Theme.of(context).textTheme.displayMedium,
      },
      {
        'header': 'Display Small',
        'textStyle': Theme.of(context).textTheme.displaySmall,
      },
    ];
    final headline = [
      {
        'header': 'Headline Large',
        'textStyle': Theme.of(context).textTheme.headlineLarge,
      },
      {
        'header': 'Headline Medium',
        'textStyle': Theme.of(context).textTheme.headlineMedium,
      },
      {
        'header': 'Headline Small',
        'textStyle': Theme.of(context).textTheme.headlineSmall,
      },
    ];
    final body = [
      {
        'header': 'Body Large',
        'textStyle': Theme.of(context).textTheme.bodyLarge,
      },
      {
        'header': 'Body Medium',
        'textStyle': Theme.of(context).textTheme.bodyMedium,
      },
      {
        'header': 'Body Small',
        'textStyle': Theme.of(context).textTheme.bodySmall,
      },
    ];

    final title = [
      {
        'header': 'Title Large',
        'textStyle': Theme.of(context).textTheme.titleLarge,
      },
      {
        'header': 'Title Medium',
        'textStyle': Theme.of(context).textTheme.titleMedium,
      },
      {
        'header': 'Title Small',
        'textStyle': Theme.of(context).textTheme.titleSmall,
      },
    ];
    final label = [
      {
        'header': 'Label Large',
        'textStyle': Theme.of(context).textTheme.labelLarge,
      },
      {
        'header': 'Label Medium',
        'textStyle': Theme.of(context).textTheme.labelMedium,
      },
      {
        'header': 'Label Small',
        'textStyle': Theme.of(context).textTheme.labelSmall,
      },
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FontGroup(fonts: display),
            _FontGroup(fonts: headline),
            _FontGroup(fonts: body),
            _FontGroup(fonts: title),
            _FontGroup(fonts: label),
          ],
        ),
      ),
    );
  }
}

class _FontGroup extends StatelessWidget {
  final List fonts;

  const _FontGroup({Key? key, required this.fonts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fonts
            .map((e) {
              final TextStyle style = e['textStyle'] as TextStyle;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['header'].toString(), style: style),
                  Text(
                    'Font: ${style.fontFamily?.split('/').last}\nSize: ${style.fontSize?.toInt()}\nLine height: ${(style.height ?? 1 * style.fontSize!).toInt()}',
                    style: TextStyle(color: ZetaColors.of(context).cool.shade70),
                  ),
                  const _Spacer(),
                ],
              );
            })
            .toList()
            .divide(const _Spacer()),
        const _Spacer(),
        const Divider(),
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
