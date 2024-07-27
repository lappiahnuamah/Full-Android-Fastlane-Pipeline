import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/category_rank_model.dart';
import 'package:savyminds/screens/records/record_ranks.dart';

class CategoryRanks extends StatefulWidget {
  const CategoryRanks({super.key});

  @override
  State<CategoryRanks> createState() => _CategoryRanksState();
}

class _CategoryRanksState extends State<CategoryRanks> {
  List<CategoryRankModel> categoryRanks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryRanks();
  }

  loadCategoryRanks() async {
    final result = await CategoryFunctions().getCategoryRanks(context: context);

    if (!mounted) return;
    setState(() {
      categoryRanks = result;
      isLoading = false;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
        child: Column(
          children: [
            CategoryRankTableHeader(size: size),
            SizedBox(height: d.pSH(10)),
            Expanded(
              child: Builder(builder: (context) {
                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (categoryRanks.isEmpty) {
                  return Center(
                    child: Text('No data found'),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(categoryRanks.length, (index) {
                        final rank = categoryRanks[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: d.pSH(10.0)),
                          child: CustomRankRow(
                            gamesPlayed: rank.numberOfPlays.toString(),
                            rank: rank.rank.toString(),
                            points: rank.totalPoints.toString(),
                            name: rank.categoryName,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    ]);
  }
}
