import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/models/solo_quest/game_type_rank_model.dart';
import 'package:savyminds/providers/records_provider.dart';
import 'package:savyminds/screens/records/record_ranks.dart';

class SoloQuestRanks extends StatefulWidget {
  const SoloQuestRanks({super.key});

  @override
  State<SoloQuestRanks> createState() => _SoloQuestRanksState();
}

class _SoloQuestRanksState extends State<SoloQuestRanks> {

  @override
  void initState() {
    super.initState();
    loadCategoryRanks();
  }

  loadCategoryRanks() async {
    final result = await ContestFunctions()
        .getGameTypeRank(context: context, gameType: "Single Player");
    if (!mounted) return;

   
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<RecordsProvider>(
      builder: (context,value,child) {
        return Column(children: [
          Expanded(
            child: Column(
              children: [
                CategoryRankTableHeader(size: size),
                SizedBox(height: d.pSH(10)),
                Expanded(
                  child: Builder(builder: (context) {
                    if (value.soloQuestRankIsLoading && value.soloQuestRanks.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
        
                    if (!value.soloQuestRankIsLoading && value.soloQuestRanks.isEmpty) {
                      return Center(
                        child: Text('No data found'),
                      );
                    }
        
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(value.soloQuestRanks.length, (index) {
                            final rank = value.soloQuestRanks[index];
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
    );
  }
}
