import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({Key? key}) : super(key: key);

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  bool _isLabelVisible = true;
  ScrollController scrollController = ScrollController();
  bool _isFabExtended = true;

  late bool isChecked;
  late bool isButtonSelected;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          scrollController.offset > 32) {
        setState(() {
          _isLabelVisible = false;
        });
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isLabelVisible = true;
        });
      }
    });
    isChecked = false;
    isButtonSelected = false;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final floatingActionButton = ZdsFloatingActionButton.extended(
      icon: const Icon(ZdsIcons.edit),
      extendedIconLabelSpacing: _isLabelVisible ? null : 0,
      extendedPadding: _isLabelVisible
          ? null
          : const EdgeInsetsDirectional.only(start: 10, end: 8),
      label: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: child);
        },
        duration: const Duration(milliseconds: 300),
        child: _isLabelVisible
            ? const Text('Show non-expanding FAB')
            : const SizedBox.shrink(),
      ),
      onPressed: () => setState(() => _isFabExtended = !_isFabExtended),
    );

    final slideableButtonKey = GlobalKey<ZdsSlidableButtonState>();
    return Scaffold(
      floatingActionButton: _isFabExtended
          ? floatingActionButton
          : ZdsFloatingActionButton(
              icon: const Icon(ZdsIcons.edit),
              onPressed: () => setState(() => _isFabExtended = !_isFabExtended),
            ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            for (final hasOnTap in [true, false]) ...[
              Text('${hasOnTap ? 'with' : 'without'} onTap',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 10),
              ZdsButton.filled(
                onTap: hasOnTap ? () {} : null,
                child: const Text('Filled'),
              ),
              const SizedBox(height: 10),
              ZdsButton.filled(
                isDangerButton: true,
                onTap: hasOnTap ? () {} : null,
                child: const Text('Filled danger'),
              ),
              const SizedBox(height: 10),
              ZdsButton.outlined(
                onTap: hasOnTap ? () {} : null,
                child: const Text('Outlined'),
              ),
              const SizedBox(height: 10),
              ZdsButton.outlined(
                isDangerButton: true,
                onTap: hasOnTap ? () {} : null,
                child: const Text('Outlined danger'),
              ),
              const SizedBox(height: 10),
              ZdsButton.text(
                onTap: hasOnTap ? () {} : null,
                child: const Text('Text'),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: ZdsButton.text(
                  onTap: hasOnTap ? () {} : null,
                  isOnDarkBackground: true,
                  child: const Text('Text onDarkBackground'),
                ),
              ),
              const SizedBox(height: 10),
              ZdsButton.muted(
                onTap: hasOnTap ? () {} : null,
                child: const Text('Muted'),
              ),
              const SizedBox(height: 10),
              CircleIconButton(
                icon: ZetaIcons.end_call_round,
                label: "Reject",
                type: CircleButtonType.negative,
                onTap: () {
                  print("Tap");
                },
              ),
              const SizedBox(height: 10),
              CircleIconButton(
                icon: ZetaIcons.phone_round,
                label: "Accept",
                type: CircleButtonType.positive,
                onTap: () {
                  print("Tap");
                },
              ),
              const SizedBox(height: 10),
              CircleIconButton(
                icon: ZetaIcons.microphone_round,
                label: "Mute",
                type: CircleButtonType.base,
                activeIcon: ZetaIcons.microphone_off_round,
                activeLabel: "Un-Mute",
                onTap: () {
                  print("Tap");
                },
              ),
              const SizedBox(height: 10),
              CircleIconButton(
                icon: ZetaIcons.alert_round,
                label: "Security",
                type: CircleButtonType.alert,
                onTap: () {
                  print("Tap");
                },
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        ...Zeta.of(context)
                            .colors
                            .rainbow
                            .map(
                              (e) => ZdsButton.filled(
                                onTap: () {},
                                customColor: e,
                                child: const Text('Button'),
                              ),
                            )
                            .divide(const SizedBox(width: 16))
                            .toList(),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                )
              ],
            ).paddingInsets(const EdgeInsets.symmetric(vertical: 24)),
            Align(
              alignment: Alignment.centerRight,
              child: ZdsPopupMenu(
                builder: (_, open) => IconButton(
                  splashRadius: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: open,
                  color: Zeta.of(context).colors.iconSubtle,
                  icon: const Icon(ZdsIcons.more_vert),
                ),
                items: const [
                  ZdsPopupMenuItem(
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text('More'),
                    ),
                  ),
                ],
              ),
            ),
            Text('Checkable', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 10),
            ZdsCheckableButton(
              isChecked: isChecked,
              icon: ZdsIcons.add,
              onChanged: () => setState(() => isChecked = !isChecked),
            ),
            const SizedBox(height: 10),
            ZdsCheckableButton(
              isChecked: !isChecked,
              label: 'Mon',
              onChanged: () => setState(() => isChecked = !isChecked),
            ),
            const SizedBox(height: 10),
            const ZdsCheckableButton(
              icon: ZdsIcons.add,
            ),
            const SizedBox(height: 10),
            const ZdsCheckableButton(
              isChecked: true,
              label: 'Mon',
            ),
            const SizedBox(height: 50),
            Text('Selection pills',
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZdsSelectionPill(
                      selected: isButtonSelected,
                      label: 'All',
                      onTap: () =>
                          setState(() => isButtonSelected = !isButtonSelected),
                      leadingIcon: const Icon(ZdsIcons.person_info),
                      onClose: () {},
                    ),
                    ZdsSelectionPill(
                      selected: !isButtonSelected,
                      label: 'Approved',
                      leadingIcon: const Icon(ZdsIcons.person_info),
                      onTap: () =>
                          setState(() => isButtonSelected = !isButtonSelected),
                      onClose: () {},
                    ),
                    ZdsSelectionPill(
                      selected: true,
                      label: 'Pending',
                    ),
                    const ZdsSelectionPill(
                      label: 'Declined',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
            Text('Slidable', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text('Disabled', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            SizedBox(
              width: 336,
              child: Column(
                children: [
                  ZdsSlidableButton(
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    buttonText: 'Clock In',
                    buttonSliderColor: Theme.of(context).primaryColorLight,
                    buttonIcon: ZdsIcons.clock_start,
                  ),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    buttonColor: Zeta.of(context).colors.iconDefault,
                    buttonText: 'Clock Out',
                    buttonSliderColor: Zeta.of(context).colors.warm.surface,
                    buttonIcon: ZdsIcons.clock_stop,
                  ),
                  const SizedBox(height: 36),
                  Text('Active, with animation, stays completed',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ZdsButton.filled(
                    child: const Text('Reset toggle'),
                    onTap: () {
                      slideableButtonKey.currentState?.reset();
                    },
                  ),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    key: slideableButtonKey,
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    stayCompleted: true,
                    buttonSliderColor: Theme.of(context).primaryColorLight,
                    buttonText: 'Meal Start',
                    buttonIcon: ZdsIcons.meal,
                    onSlideComplete: () async {
                      debugPrint('Done!');
                      return true;
                    },
                  ),
                  const SizedBox(height: 36),
                  Text('Active, basic without animation',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    buttonColor: Zeta.of(context).colors.iconDefault,
                    buttonText: 'Clock Out',
                    buttonIcon: ZdsIcons.clock_stop,
                    buttonSliderColor: Zeta.of(context).colors.warm.surface,
                    onSlideComplete: () async {
                      debugPrint('Done!');
                      return true;
                    },
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Active, changes colors, loading indicator',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    buttonColor: Zeta.of(context).colors.iconDefault,
                    buttonColorEnd: Theme.of(context).colorScheme.secondary,
                    buttonText: 'Clock Out',
                    buttonTextEnd: DateTime.now().format('KK:mm a'),
                    buttonIcon: ZdsIcons.clock_stop,
                    buttonIconEnd: ZdsIcons.check_circle,
                    buttonSliderColor: Zeta.of(context).colors.warm.surface,
                    buttonSliderColorEnd: Theme.of(context).primaryColorLight,
                    onSlideComplete: () async {
                      debugPrint('Done!');
                      await Future.delayed(const Duration(seconds: 1));
                      return true;
                    },
                  ),
                  const SizedBox(height: 36),
                  Text('Disabled, no message',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    buttonColor: Zeta.of(context).colors.iconDefault,
                    buttonText: 'Clock Out',
                    buttonIcon: ZdsIcons.clock_stop,
                    buttonSliderColor: Zeta.of(context).colors.warm.surface,
                  ),
                  const SizedBox(height: 36),
                  Text('Disabled with message',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ZdsSlidableButton(
                    buttonColor: Zeta.of(context).colors.iconDefault,
                    buttonText: 'Clock Out',
                    buttonIcon: ZdsIcons.clock_stop,
                    buttonSliderColor: Zeta.of(context).colors.warm.surface,
                    disabledMessage:
                        'Disabled message that is quite long and goes over two lines',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }

  void showToast(BuildContext context, Color color, String title,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showZdsToast(
      ZdsToast(
        multiLine: true,
        title: Text(title),
        leading: const Icon(ZdsIcons.check_circle),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            icon: const Icon(ZdsIcons.close),
          ),
        ],
      ),
    );
  }
}
