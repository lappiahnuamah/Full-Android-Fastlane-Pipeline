import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/widgets/page_template.dart';

class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: 'Start Game',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          children: [
            SizedBox(
                height: d.pSH(150.5),
                width: d.pSW(160.2),
                child: Hero(
                  tag: "Category ${widget.category.id}",
                  child: CategoryCard(
                    category: widget.category,
                    hidePlay: true,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
