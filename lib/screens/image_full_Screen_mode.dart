import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // void shareImage(String imageUrl, String photographer) {
    //   Share.share(
    //     'Check out this photo by $photographer: $imageUrl',
    //     subject: 'Photo Sharing',
    //   );
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              // shareImage(imageUrl, imageUrl);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300, shape: BoxShape.circle),
              child: const Icon(Icons.download),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              fit: BoxFit.scaleDown,
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
