import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class YourLoadingWidget extends StatelessWidget {
  final Widget child;
  const YourLoadingWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context ) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 380.h,
          initialPage: 1,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enableInfiniteScroll: true,
        ),
        items: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          );
        }),
      ),
    );
  }
}

