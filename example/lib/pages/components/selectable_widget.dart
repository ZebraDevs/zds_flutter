import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

/// Contains a demonstration of the ZdsSelectableWidget class.
/// This demo showcases how to use the ZdsSelectableWidget with both HTML and plain text content within a Flutter application.
class SelectableWidgetDemo extends StatelessWidget {
  const SelectableWidgetDemo({super.key});
  @override
  Widget build(BuildContext context) {
    String htmlContent =
        '''<p style="margin-left:0px;"><br><span style="color:#202122;font-family:'Arial',sans-serif;font-size:10.5pt;"><strong>Birds</strong> are a group of </span><p target="_blank" rel="noopener noreferrer\" href="https://en.wikipedia.org/wiki/Warm-blooded"><span style="color:#3366CC;font-family:'Arial',sans-serif;font-size:10.5pt;">warm-blooded</span></a>
This paragraph contains a lot of lines in the source code, but the browser ignores it.
This paragraph contains a lot of spaces in the source code, but the browser ignores it.
The number of lines in a paragraph depends on the size of the browser window. If you resize the browser window, the number of lines in this paragraph will change.</p>
''';
    String plainTextContent =
        'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.';
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          ZdsListGroup(
            padding: EdgeInsets.all(10.0),
            headerLabel: Text('For Html Content'),
            items: [
              ZdsSelectableWidget(
                copyable: true,
                textToCopy: htmlContent,
                isHtmlData: true,
                child: ZdsHtmlContainer(
                  htmlContent,
                  showReadMore: false,
                  onLinkTap: (_, __, ___) {
                    print('Link tapped');
                  },
                ),
              )
            ],
          ),
          ZdsListGroup(
            padding: EdgeInsets.all(10.0),
            headerLabel: Text('For Plain Text Content'),
            items: [
              ZdsSelectableWidget(
                copyable: true,
                textToCopy: plainTextContent,
                isHtmlData: true,
                child: Text('$plainTextContent'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
