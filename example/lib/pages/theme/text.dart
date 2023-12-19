import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display = [
      {
        'header': 'H1 / displayLarge',
        'textStyle': Theme.of(context).textTheme.displayLarge,
      },
      {
        'header': 'H2 / displayMedium',
        'textStyle': Theme.of(context).textTheme.displayMedium,
      },
      {
        'header': 'H3 / displaySmall',
        'textStyle': Theme.of(context).textTheme.displaySmall,
      },
    ];
    final headline = [
      {
        'header': 'H3 / headlineLarge',
        'textStyle': Theme.of(context).textTheme.headlineLarge,
      },
      {
        'header': 'H4 / headlineMedium',
        'textStyle': Theme.of(context).textTheme.headlineMedium,
      },
      {
        'header': 'H5 / headlineSmall',
        'textStyle': Theme.of(context).textTheme.headlineSmall,
      },
    ];
    final body = [
      {
        'header': 'Body 1 / bodyLarge',
        'textStyle': Theme.of(context).textTheme.bodyLarge,
      },
      {
        'header': 'Body 2 / bodyMedium',
        'textStyle': Theme.of(context).textTheme.bodyMedium,
      },
      {
        'header': 'Body 3 / bodySmall',
        'textStyle': Theme.of(context).textTheme.bodySmall,
      },
    ];

    final title = [
      {
        'header': 'titleLarge',
        'textStyle': Theme.of(context).textTheme.titleLarge,
      },
      {
        'header': 'Subtitle 1 / titleMedium',
        'textStyle': Theme.of(context).textTheme.titleMedium,
      },
      {
        'header': 'Subtiitle 2 / titleSmall',
        'textStyle': Theme.of(context).textTheme.titleSmall,
      },
    ];
    final label = [
      {
        'header': 'labelLarge',
        'textStyle': Theme.of(context).textTheme.labelLarge,
      },
      {
        'header': 'labelMedium',
        'textStyle': Theme.of(context).textTheme.labelMedium,
      },
      {
        'header': 'labelSmall',
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
                    'Font: ${style.fontFamily}\nSize: ${style.fontSize?.toInt()}\nLine height: ${((style.height ?? 1) * style.fontSize!).toInt()}',
                    style: TextStyle(color: Zeta.of(context).colors.textSubtle),
                  ),
                  const _Spacer(),
                ],
              );
            })
            .toList()
            .divide(const _Spacer()),
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
