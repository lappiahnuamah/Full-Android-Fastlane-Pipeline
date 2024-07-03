import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/category_rank_model.dart';
import 'package:savyminds/screens/records/record_ranks.dart';

class ContestRanks extends StatefulWidget {
  const ContestRanks({super.key});

  @override
  State<ContestRanks> createState() => _ContestRanksState();
}

class _ContestRanksState extends State<ContestRanks> {
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
            ContestRankTableHeader(size: size),
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
