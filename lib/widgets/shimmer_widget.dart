import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircularShape;

  const ShimmerWidget.rectangular({
    required this.width,
    required this.height,
    required this.isCircularShape,
  });

  const ShimmerWidget.circular({
    required this.width,
    required this.height,
    required this.isCircularShape,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: isCircularShape
              ? CircleBorder()
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
