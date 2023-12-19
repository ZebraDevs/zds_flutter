import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class ToastDemo extends StatefulWidget {
  const ToastDemo({Key? key}) : super(key: key);

  @override
  State<ToastDemo> createState() => _ToastDemoState();
}

class _ToastDemoState extends State<ToastDemo> {
  bool showPersistentToast = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            ZdsButton.muted(
              child: const Text('green/positive toast'),
              onTap: () => showToast(context, color: ZdsToastColors.success),
            ),
            ZdsButton(
              isDangerButton: true,
              child: const Text('red/negative toast'),
              onTap: () => showToast(context, color: ZdsToastColors.error),
            ),
            ZdsButton.muted(
              child: const Text('orange/warning toast'),
              onTap: () => showToast(context, color: ZdsToastColors.warning),
            ),
            ZdsButton.muted(
              child: const Text('purple/info toast'),
              onTap: () => showToast(context, color: ZdsToastColors.info),
            ),
            ZdsButton(
              child: const Text('primary toast'),
              onTap: () => showToast(context, color: ZdsToastColors.primary),
            ),
            ZdsButton.muted(
              child: const Text('longer toast'),
              onTap: () => showLongerToast(context),
            ),
            ZdsButton.muted(
              child: const Text('Dark toast'),
              onTap: () => showToast(context, color: ZdsToastColors.dark),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show persistent toast'),
                Switch(value: showPersistentToast, onChanged: (bool b) => setState(() => showPersistentToast = b)),
              ],
            ),
          ].divide(const SizedBox(height: 10)).toList(),
        ),
      ),
      bottomNavigationBar: showPersistentToast
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ZdsToast(
                  rounded: false,
                  title: Text('Persistent default toast'),
                ),
              ),
            )
          : null,
    );
  }

  void showToast(BuildContext context, {ZdsToastColors? color}) {
    ScaffoldMessenger.of(context).showZdsToast(
      ZdsToast(
        title: const Text('Project launched successfully'),
        leading: const Icon(ZdsIcons.check_circle),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            icon: const Icon(ZdsIcons.close),
          ),
        ],
        color: color,
      ),
    );
  }

  void showLongerToast(BuildContext context) {
    ScaffoldMessenger.of(context).showZdsToast(
      ZdsToast(
        title: const Text(
          'Project launched successfully very very very very very very very very very very very long message',
        ),
        leading: const Icon(ZdsIcons.check_circle),
        multiLine: true,
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

class PreferredSizeColumn extends StatelessWidget implements PreferredSizeWidget {
  final List<PreferredSizeWidget> children;

  const PreferredSizeColumn({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(children.map((child) => child.preferredSize.height).reduce((value, element) => value + element));
}
