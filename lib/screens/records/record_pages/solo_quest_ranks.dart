import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/models/solo_quest/game_type_rank_model.dart';
import 'package:savyminds/screens/records/record_ranks.dart';

class SoloQuestRanks extends StatefulWidget {
  const SoloQuestRanks({super.key});

  @override
  State<SoloQuestRanks> createState() => _SoloQuestRanksState();
}

class _SoloQuestRanksState extends State<SoloQuestRanks> {
  List<GameTypeRankModel> categoryRanks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryRanks();
  }

  loadCategoryRanks() async {
    final result = await ContestFunctions()
        .getGameTypeRank(context: context, gameType: "Single Player");
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
                            name: rank.gameTypeName,
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
