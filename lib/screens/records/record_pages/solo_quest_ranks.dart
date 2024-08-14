import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/providers/records_provider.dart';
import 'package:savyminds/screens/records/record_ranks.dart';
import 'package:savyminds/widgets/custom_text.dart';

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
    return Consumer<RecordsProvider>(builder: (context, value, child) {
      return Column(children: [
        Expanded(
          child: Column(
            children: [
              SoloQuestRankTableHeader(size: size),
              SizedBox(height: d.pSH(10)),
              Expanded(
                child: Builder(builder: (context) {
                  if (value.soloQuestRankIsLoading &&
                      value.soloQuestRanks.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!value.soloQuestRankIsLoading &&
                      value.soloQuestRanks.isEmpty) {
                    return Center(
                      child: CustomText(label: 'No data found'),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(value.soloQuestRanks.length, (index) {
                          final rank = value.soloQuestRanks[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: d.pSH(10.0)),
                            child: SoloQuestRankRow(
                              rank: rank.rank.toString(),
                              level: rank.level.toString(),
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
    });
  }
}

class SoloQuestRankTableHeader extends StatelessWidget {
  const SoloQuestRankTableHeader({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 5,
        child: SizedBox(height: d.pSH(15)),
      ),
      Expanded(
        flex: 2,
        child: CustomText(
          label: "Level",
          fontSize: 16,
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        flex: 2,
        child: CustomText(
          label: "Rank",
          fontSize: 16,
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
    ]);
  }
}

//
