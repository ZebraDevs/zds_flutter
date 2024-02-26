import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({Key? key}) : super(key: key);

  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final ZdsFilePickerController controller = ZdsFilePickerController();

  static const pickerConfig = FilePickerConfig(
    maxFilesAllowed: 5,
    maxFileSize: 2500000,
    maxVideoTimeInSeconds: 10,
    options: [
      FilePickerOptions.FILE,
      FilePickerOptions.GIF,
      FilePickerOptions.LINK,
      FilePickerOptions.CAMERA,
      FilePickerOptions.GALLERY,
      FilePickerOptions.VIDEO,
    ],
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZdsList(
      padding: const EdgeInsets.all(14),
      children: [
        ZdsFilePicker(
          useCard: false,
          config: pickerConfig,
          controller: controller,
          visualDensity: VisualDensity.compact,
          optionDisplay: ZdsOptionDisplay.plain,
          displayStyle: ZdsFilePickerDisplayStyle.horizontal,
          postProcessors: [
            ZdsImageCropPostProcessor(() => context),
            const ZdsFileCompressPostProcessor(),
            const ZdsFileRenamePostProcessor(),
          ],
          onChange: (files) {
            debugPrint('files: $files');
          },
        ),
        ZdsFilePicker(
          useCard: false,
          config: pickerConfig,
          controller: controller,
          postProcessors: [
            ZdsFileEditPostProcessor(() => context),
            const ZdsFileCompressPostProcessor(),
            const ZdsFileRenamePostProcessor(),
          ],
          visualDensity: VisualDensity.compact,
          onChange: (files) {
            debugPrint('files: $files');
          },
        ),
        ZdsFilePicker(
          config: pickerConfig,
          controller: controller,
          optionDisplay: ZdsOptionDisplay.plain,
          displayStyle: ZdsFilePickerDisplayStyle.horizontal,
          onChange: (files) {
            debugPrint('files: $files');
          },
        ),
        ZdsFilePicker(
          config: pickerConfig,
          controller: controller,
          onChange: (files) {
            debugPrint('files: $files');
          },
        ),
      ].divide(const SizedBox(height: 20)).toList(),
    );
  }
}
