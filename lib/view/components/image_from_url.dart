import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromUrl extends StatelessWidget {
  final String imageUrl;
  const ImageFromUrl({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isInvalidUrl = imageUrl.startsWith("http");
    final primaryColor = Theme.of(context).primaryColor;

    if (imageUrl == null || imageUrl == "" || !isInvalidUrl){
      return const Icon(Icons.broken_image);
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(child: CircularProgressIndicator(
          color: primaryColor,
        )),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
        fit: BoxFit.cover,
      );
    }
  }
}
