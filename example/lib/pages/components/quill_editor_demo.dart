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

  var _htmlPreview = true;

  get htmlPreview => _htmlPreview;

  set htmlPreview(value) {
    if (htmlPreview == value) return;
    setState(() {
      _htmlPreview = value;
    });
  }

  var _loading = true;

  get loading => _loading;

  set loading(value) {
    if (loading == value) return;
    setState(() {
      _loading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    ZdsQuillDelta.fromHtml(editorData).then((value) {
      controller.document = value.document;
    }).whenComplete(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Zeta.of(context).colors.surfacePrimary,
            appBar: AppBar(
              title: const Text('Quill Editor'),
              actions: [
                Row(
                  children: [
                    Text('HTML'),
                    Switch(
                      value: htmlPreview,
                      onChanged: (value) {
                        setState(() {
                          htmlPreview = !htmlPreview;
                        });
                      },
                    ),
                  ],
                )
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
                    setState(() {
                      controller.document = value.document;
                    });
                  }
                });
              },
            ),
            body: Stack(
              children: [
                ZdsQuillEditor(
                  controller: controller,
                  readOnly: true,
                  padding: const EdgeInsets.all(16),
                  embedBuilders: getEmbedBuilders(),
                  focusNode: FocusNode(canRequestFocus: false),
                ),
                if (loading) const LinearProgressIndicator(),
              ],
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: Scaffold(
            backgroundColor: Zeta.of(context).colors.surfacePrimary,
            body: Builder(builder: (context) {
              final html = ZdsQuillDelta(document: controller.document).toHtml();
              return SingleChildScrollView(
                padding: EdgeInsets.all(14),
                physics: ClampingScrollPhysics(),
                child: htmlPreview ? ZdsHtmlContainer(html, expanded: true, showReadMore: false) : Text(html),
              );
            }),
          ),
        )
      ],
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

const editorData = """
<p><img style="max-width: 100%;object-fit: contain"
        src="https://www.google.com/logos/doodles/2024/double-cicada-brood-2024-6753651837110499-2xa.gif" /> </p>
<ul>
    <li>Apple</li>
    <li>Banana</li>
    <li>Cherry</li>
</ul>
<br />
<ol>
    <li>Plan the trip<ol>
            <li>Book flights</li>
        </ol>
    </li>
    <li>Reserve hotel<ol>
            <li>Something</li>
        </ol>
    </li>
    <li>Check review<ol>
            <li>Read recent comments</li>
        </ol>
    </li>
    <li>Compare prices<ol>
            <li>Use comparison websites</li>
        </ol>
    </li>
    <li>Pack luggage<ol>
            <li>Clothes</li>
        </ol>
    </li>
</ol>
<br />
<ul>
    <li>Toiletries<ul>
            <li>Shampoo</li>
            <li>Toothbrush</li>
        </ul>
    </li>
    <li>Gadgets<ul>
            <li>Phone</li>
            <li>Charger</li>
        </ul>
    </li>
</ul>
<br />
<pre>Code snippet example:
Line 1: Initialize the project
Line 2: Write some code
Line 3: Test the code</pre>
<br />
<blockquote style="border-left: 4px solid #ccc;padding-left: 16px">“The only limit to our realization of tomorrow is our
    doubts of today.”<br />– Franklin D. Roosevelt</blockquote>
<br />
<h1>Main Title</h1>
<br />
<h2>Subtitle</h2>
<br />
<h3>Section Title</h3>
<p><br /><strong>Bold text example</strong><br /><br /><em>Italic text example</em><br /><u>Underlined text example</u><br /><br /><s>Strikethrough text
        example</s><br /><br />Small text example<br /><br /><code>Inline code example</code><br /><br /><span
        style="color:#e53935">Red colored text</span><br /><br /><span style="background-color:#fdd835">Yellow
        background text</span><br /><br />Indented paragraph example. Lorem ipsum dolor sit amet, consectetur adipiscing
    elit. Vivamus lacinia odio vitae vestibulum vestibulum.<br /><br />Another indented paragraph. Cras placerat
    ultricies orci nec vestibulum.<br /><br />Left aligned text example<br /></p>
<p style="text-align:right">Right aligned text example</p>
<br />
<p style="text-align:center">Center aligned text example</p>
<br />
<p style="direction:rtl; text-align:inherit">Right to left text example</p>
<p><br /> <s>Multi-line strikethrough example:</s><br /><s>Line 1</s><br /><s>Line 2</s><br /><s>Line 3</s></p>
""";
