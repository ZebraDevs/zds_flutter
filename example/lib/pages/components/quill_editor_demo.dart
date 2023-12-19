import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Quill Editor')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          ZdsQuillEditorPage.edit(
            context,
            title: 'Edit Notes',
            initialDelta: ZdsQuillDelta(document: controller.document),
            charLimit: 200,
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
              padding: const EdgeInsets.all(16),
              controller: controller,
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}
