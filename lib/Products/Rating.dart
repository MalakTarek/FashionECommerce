import 'package:fashion_ecommerce/Products/product.dart';
import 'package:flutter/material.dart';

abstract class Rating extends StatelessWidget {
  final Product product;

  Rating(this.product);

  Widget buildStar(BuildContext context, int index) {
    IconData icon;
    Color color;
    if (index >= product.overallRating) {
      icon = Icons.star_border;
      color = Colors.grey; // Color for empty stars
    } else if (index > product.overallRating - 1 && index < product.overallRating) {
      icon = Icons.star_half;
      color = Colors.amber; // Color for half-filled stars
    } else {
      icon = Icons.star;
      color = Colors.amber; // Color for filled stars
    }
    return Icon(
      icon,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) => buildStar(context, index)),
    );
  }
}