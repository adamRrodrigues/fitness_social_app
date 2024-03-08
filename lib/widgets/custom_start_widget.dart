import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class CustomStarWidget extends StatefulWidget {
  const CustomStarWidget({
    super.key,
    this.starValue = 0,
  });

  final double starValue;
  @override
  State<CustomStarWidget> createState() => _CustomStarWidgetState();
}

class _CustomStarWidgetState extends State<CustomStarWidget> {
  @override
  Widget build(BuildContext context) {
    return RatingStars(
      starCount: 5,
      maxValue: 5,
      value: widget.starValue,
      maxValueVisibility: false,
      valueLabelVisibility: false,
      starColor: Theme.of(context).colorScheme.secondary,
      starSize: 15,
    );
  }
}
