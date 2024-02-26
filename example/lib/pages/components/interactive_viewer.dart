import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class InteractiveViewerExample extends StatelessWidget {
  const InteractiveViewerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Viewer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              return Center(
                child: ZdsInteractiveViewer(
                  minScale: 0.1,
                  maxScale: 4.0,
                  child: SizedBox(
                    height: box.maxHeight,
                    width: box.maxWidth,
                    child: ZdsImages.sadZebra,
                  ),
                ),
              );
            }),
          ),
          Text(
            'Double tap to zoom in and out, pinch to zoom, and drag to move the image.',
          ).padding(16)
        ],
      ),
    );
  }
}
