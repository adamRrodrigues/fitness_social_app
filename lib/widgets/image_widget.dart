import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      cache: true,
      // handleLoadingProgress: true,
      filterQuality: FilterQuality.none,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            // _controller.reset();
            return const SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()));

          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              fit: BoxFit.cover,
            );
          case LoadState.failed:
            // _controller.reset();
            return GestureDetector(
              child: const Text(
                "load image failed, click to reload",
                textAlign: TextAlign.center,
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
        }
      },
    );
  }
}
