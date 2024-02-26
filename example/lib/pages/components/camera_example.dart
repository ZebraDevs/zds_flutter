import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:zds_flutter/zds_flutter.dart';

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  XFile? _image;
  XFile? _video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image != null) XImage.file(_image!),
            if (_video != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ZdsVideoPlayer(videoFile: _video),
              ),
          ],
        ),
      ),
      bottomNavigationBar: ZdsBottomBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ZdsButton.filled(
              onTap: () async {
                final image = await ZdsCamera.takePhoto(context);
                if (image != null) {
                  setState(() {
                    _image = image;
                  });
                }
              },
              child: const Text('Take a picture'),
            ),
            ZdsButton.filled(
              onTap: () async {
                final video = await ZdsCamera.recordVideo(context);
                if (video != null) {
                  setState(() {
                    _video = video;
                  });
                }
              },
              child: const Text('Take a video'),
            ),
          ],
        ),
      ),
    );
  }
}
