import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

///Example for htmlEditor
class QuillEditorDemo extends StatefulWidget {
  const QuillEditorDemo({super.key});

  @override
  State<QuillEditorDemo> createState() => _QuillEditorDemoState();
}

class _QuillEditorDemoState extends State<QuillEditorDemo> {
  final controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    ZdsQuillDelta.fromHtml('''
<h3>Google Doodles</h3><p><br/><img style="max-width: 100%;object-fit: contain" src="https://www.google.com/logos/doodles/2024/celebrating-chilaquiles-6753651837110223-2xa.gif"/><br><br/></p><p style="text-align:justify">Doodles celebrate a wide range of events, from national holidays like Independence Day and Christmas to special occasions like the anniversary of the first moon landing or the birth of significant figures in history such as Albert Einstein and Frida Kahlo.</p>
    ''').then((value) {
      controller.document = value.document;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quill Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.html),
            onPressed: () {
              final html = ZdsQuillDelta(document: controller.document).toHtml();
              showDialog(
                context: context,
                builder: (context) {
                  return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                      child: Dialog(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(html),
                          ],
                        ),
                      )));
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          ZdsQuillEditorPage.edit(
            context,
            title: 'Edit Notes',
            embedBuilders: getEmbedBuilders(),
            initialDelta: ZdsQuillDelta(document: controller.document),
            charLimit: 20000,
            embedButtons: FlutterQuillEmbeds.toolbarButtons(
              videoButtonOptions: null,
              imageButtonOptions: QuillToolbarImageButtonOptions(
                imageButtonConfigurations: QuillToolbarImageConfigurations(
                  onImageInsertCallback: (image, controller) async {
                    // Upload to cloud
                    controller.insertImageBlock(imageSource: image);
                  },
                ),
              ),
            ),
          ).then((value) {
            if (value != null) {
              controller.document = value.document;
            }
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ZdsQuillEditor(
              controller: controller,
              readOnly: true,
              padding: const EdgeInsets.all(16),
              embedBuilders: getEmbedBuilders(),
              focusNode: FocusNode(canRequestFocus: false),
            ),
          ),
        ],
      ),
    );
  }
}

/// default embed builders
List<EmbedBuilder> getEmbedBuilders() {
  if (isWeb()) {
    return FlutterQuillEmbeds.editorWebBuilders();
  } else {
    return FlutterQuillEmbeds.editorBuilders();
  }
}
