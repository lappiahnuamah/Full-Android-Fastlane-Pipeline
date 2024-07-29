import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/models/solo_quest/game_type_rank_model.dart';
import 'package:savyminds/providers/records_provider.dart';
import 'package:savyminds/screens/records/record_ranks.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class ContestRanks extends StatefulWidget {
  const ContestRanks({super.key});

  @override
  State<ContestRanks> createState() => _ContestRanksState();
}

class _ContestRanksState extends State<ContestRanks> {

  @override
  void initState() {
    super.initState();
    loadCategoryRanks();
  }

  loadCategoryRanks() async {
    final result = await ContestFunctions()
        .getGameTypeRank(context: context, gameType: "Multiplayer");
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
                ContestRankTableHeader(size: size),
                SizedBox(height: d.pSH(10)),
                Expanded(
                  child: Builder(builder: (context) {
                    if (value.multiQuestRankIsLoading && value.multiQuestRanks.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
        
                    if (!value.multiQuestRankIsLoading && value.multiQuestRanks.isEmpty) {
                      return Center(
                        child: Text('No data found'),
                      );
                    }
        
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(value.multiQuestRanks.length, (index) {
                            final rank = value.multiQuestRanks[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: d.pSH(10.0)),
                              child: ContestRankRow(
                                level: rank.level,
                                rank: rank.rank.toString(),
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

class ContestRankRow extends StatelessWidget {
  const ContestRankRow(
      {super.key, required this.rank, required this.name, required this.level});
  final String rank;
  final String name;
  final String level;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              //TODO: add icons

              // SvgPicture.asset(
              //   'assets/icons/learner.svg',
              //   height: d.pSH(15),
              //   colorFilter: const ColorFilter.mode(
              //       AppColors.hintTextBlack, BlendMode.srcIn),
              // ),
              // SizedBox(width: d.pSW(10)),
              Expanded(
                child: CustomText(
                  label: name,
                  fontSize: getFontSize(15, size),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomText(
            label: level,
            fontSize: getFontSize(15, size),
            textAlign: TextAlign.end,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomText(
            label: rank,
            fontSize: getFontSize(15, size),
            textAlign: TextAlign.end,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
