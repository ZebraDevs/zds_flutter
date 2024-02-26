import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class StarRatingExample extends StatelessWidget {
  const StarRatingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [ZdsStarRating()],
      ),
    );
  }
}
