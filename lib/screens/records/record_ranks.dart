import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/records/components/record_rank_header.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

enum RankHeaderEnum { categories, soloQuest, contest }

class RecordRanks extends StatefulWidget {
  const RecordRanks({super.key});

  @override
  State<RecordRanks> createState() => _RecordRanksState();
}

class _RecordRanksState extends State<RecordRanks> {
  List rankHeaders = ['Categories', 'Solo Quest', 'Contest'];

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
              (index) => index.isOdd
                  ? SizedBox(
                      width: d.pSW(10),
                    )
                  : Expanded(
                      child: RecordRankHeader(
                          title: rankHeaders[index % 3],
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

        ////
        Expanded(
          child: Column(
            children: [
              CategoryRankTableHeader(size: size),
              SizedBox(height: d.pSH(10)),

              //Categories
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                          10,
                          (index) => Padding(
                                padding: EdgeInsets.only(bottom: d.pSH(10.0)),
                                child: categoryRankList[index % 4],
                              )),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

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
          label: "Playd",
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
              SvgPicture.asset(
                'assets/icons/math.svg',
                height: d.pSH(15),
                colorFilter: const ColorFilter.mode(
                    AppColors.hintTextBlack, BlendMode.srcIn),
              ),
              SizedBox(width: d.pSW(10)),
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

List categoryRankList = const [
  CustomRankRow(
    rank: '58.98%',
    name: 'Mathematics',
    points: '1467',
    gamesPlayed: '20',
  ),
  CustomRankRow(
    rank: '78.76%',
    name: 'Languages',
    points: '3554',
    gamesPlayed: '23',
  ),
  CustomRankRow(
    rank: '44.67%',
    name: 'Music',
    points: '2234',
    gamesPlayed: '14',
  ),
  CustomRankRow(
    rank: '24.60%',
    name: 'Sports',
    points: '13227',
    gamesPlayed: '8',
  ),
];
