import 'package:flutter/material.dart';

// creates a stack of white background container with product image in front.

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.imageFit,
    this.backgroundHeight,
    this.backgroundWidth,
    this.border,
    this.margin,
    required this.imageUrl,
  });

  // nullable values allow for modularity of the image.
  // different places in the app require different image dimensions.
  final double? imageHeight;
  final double? imageWidth;
  final BoxFit? imageFit;
  final double? backgroundHeight;
  final double? backgroundWidth;
  final BorderRadiusGeometry? border;
  final EdgeInsetsGeometry? margin;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          // in case the background should be different dimensions than
          // the image on top of it.
          height: backgroundHeight ?? imageHeight,
          width: backgroundWidth ?? imageWidth,
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: border,
          ),
        ),
        Container(
          margin: margin,
          child: ClipRRect(
            borderRadius: border ?? BorderRadius.zero,
            child: Image.network(
              imageUrl,
              height: imageHeight,
              width: imageWidth,
              fit: imageFit,
            ),
          ),
        ),
      ],
    );
  }
}
