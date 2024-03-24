import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/screens/records/components/record_rank_header.dart';
import 'package:savyminds/screens/solo_quest/solo_quest.dart';
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
        )
      ],
    );
  }
}
