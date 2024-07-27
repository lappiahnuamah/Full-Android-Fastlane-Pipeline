import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/records/components/record_rank_header.dart';
import 'package:savyminds/screens/records/record_pages/category_ranks.dart';
import 'package:savyminds/screens/records/record_pages/contest_ranks.dart';
import 'package:savyminds/screens/records/record_pages/solo_quest_ranks.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

enum RankHeaderEnum { categories, soloQuest, contest }

class RecordRanks extends StatefulWidget {
  const RecordRanks({super.key});

  @override
  State<RecordRanks> createState() => _RecordRanksState();
}

class _RecordRanksState extends State<RecordRanks> {
  List<String> rankHeaders = ['Categories', '', 'Solo Quest', '', 'Contest'];

  int _selectedRankIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label: 'Ranks',
          fontWeight: FontWeight.w500,
          fontSize: getFontSize(22, size),
        ),
        SizedBox(height: d.pSH(12)),

        //Categories,Contest,Solo quest
        Row(
          children: [
            ...List.generate(
              5,
              (index) => rankHeaders[index].isEmpty
                  ? SizedBox(
                      width: d.pSW(10),
                    )
                  : Expanded(
                      child: RecordRankHeader(
                          title: rankHeaders[index],
                          onTapped: () {
                            setState(() {
                              _selectedRankIndex = index;
                            });
                          },
                          isSelected: _selectedRankIndex == index),
                    ),
            )
          ],
        ),
        SizedBox(height: d.pSH(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Graph Icon
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/graph_icon.svg',
                height: d.pSH(22),
              ),
            ),
            //Info Icon
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/info_icon.svg',
                height: d.pSH(22),
              ),
            )
          ],
        ),
        SizedBox(height: d.pSH(15)),

        //// //Categories

        Expanded(
            child: (_selectedRankIndex == 0)
                ? CategoryRanks()
                : (_selectedRankIndex == 4)
                    ? ContestRanks()
                    : SoloQuestRanks())
      ],
    );
  }
}

//Headers
class CategoryRankTableHeader extends StatelessWidget {
  const CategoryRankTableHeader({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 3,
        child: SizedBox(height: d.pSH(15)),
      ),
      Expanded(
        child: CustomText(
          label: "Plyd",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        child: CustomText(
          label: "Points",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        child: CustomText(
          label: "Rank",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
    ]);
  }
}

class ContestRankTableHeader extends StatelessWidget {
  const ContestRankTableHeader({
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
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        flex: 2,
        child: CustomText(
          label: "Rank",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
    ]);
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
          label: "Sessions",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        flex: 2,
        child: CustomText(
          label: "Rank",
          fontSize: getFontSize(16, size),
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w600,
        ),
      ),
    ]);
  }
}

//
//Rows
class CustomRankRow extends StatelessWidget {
  const CustomRankRow(
      {super.key,
      required this.rank,
      required this.name,
      required this.points,
      required this.gamesPlayed});
  final String rank;
  final String name;
  final String points;
  final String gamesPlayed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              //TODO:add rank

              // SvgPicture.asset(
              //   'assets/icons/math.svg',
              //   height: d.pSH(15),
              //   colorFilter: const ColorFilter.mode(
              //       AppColors.hintTextBlack, BlendMode.srcIn),
              // ),
              // SizedBox(width: d.pSW(10)),
              Expanded(
                child: CustomText(
                  label: name,
                  fontSize: getFontSize(16, size),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomText(
            label: gamesPlayed,
            fontSize: getFontSize(16, size),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: CustomText(
            label: points,
            fontSize: getFontSize(16, size),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: CustomText(
            label: rank,
            fontSize: getFontSize(16, size),
            textAlign: TextAlign.end,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class SoloQuestRankRow extends StatelessWidget {
  const SoloQuestRankRow(
      {super.key,
      required this.rank,
      required this.name,
      required this.sessions});
  final String rank;
  final String name;
  final String sessions;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/learner.svg',
                height: d.pSH(15),
                colorFilter: const ColorFilter.mode(
                    AppColors.hintTextBlack, BlendMode.srcIn),
              ),
              SizedBox(width: d.pSW(10)),
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
            label: sessions,
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
