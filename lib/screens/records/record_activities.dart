import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class RecordActivities extends StatefulWidget {
  const RecordActivities({super.key});

  @override
  State<RecordActivities> createState() => _RecordActivitiesState();
}

class _RecordActivitiesState extends State<RecordActivities> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label: 'Activities',
          fontWeight: FontWeight.w500,
          fontSize: getFontSize(22, size),
        ),
        SizedBox(height: d.pSH(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //Day Icon
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/d_icon.svg',
                    height: d.pSH(22),
                  ),
                ),
                SizedBox(width: d.pSW(20)),

                //Month Icon
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/m_icon.svg',
                    height: d.pSH(22),
                  ),
                ),
              ],
            ),
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
