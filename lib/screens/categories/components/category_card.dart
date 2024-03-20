import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002) // Adjust the perspective by changing this value
        ..rotateX(0.3)
        ..rotateY(0.05),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(d.pSH(25)),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.lightBlue.withOpacity(0.5),
              child: const Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
