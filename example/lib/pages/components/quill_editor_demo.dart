import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zds_flutter/zds_flutter.dart';

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
<h1>H1 heading</h1><h2>H2 Heading</h2><h3>H3 Heading</h3><p>Normal <br/><strong>Because</strong></p>
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
              showDialog(
                context: context,
                builder: (context) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                    child: Dialog(
                      child: ZdsCard(
                        child: Text(ZdsQuillDelta(document: controller.document).toHtml()),
                      ),
                    ),
                  );
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
            initialDelta: ZdsQuillDelta(document: controller.document),
            charLimit: 20000,
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
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                padding: const EdgeInsets.all(16),
                controller: controller,
                readOnly: true,
              ),
              focusNode: FocusNode(canRequestFocus: false),
            ),
          ),
        ],
      ),
    );
  }
}
