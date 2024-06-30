import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ColorableSvg extends StatelessWidget {
  final String svgAsset;
  final bool isSelected;
  final Color selectedColor;

  const ColorableSvg({
    super.key,
    required this.svgAsset,
    this.isSelected = false,
    this.selectedColor = Colors.white, // Default selected color
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgAsset,
      // ignore: deprecated_member_use
      color: isSelected ? selectedColor : null, // Set color if selected
    );
  }
}