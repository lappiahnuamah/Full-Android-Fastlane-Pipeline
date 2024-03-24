import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/screens/records/record_activities.dart';
import 'package:savyminds/screens/records/record_ranks.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(d.pSH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label: 'Records',
            fontWeight: FontWeight.w700,
            fontSize: getFontSize(24, size),
          ),
          SizedBox(height: d.pSH(16)),
          Expanded(
            child: Column(
              children: [
                //Rannks
                const Expanded(
                  child: RecordRanks(),
                ),
                SizedBox(height: d.pSH(24)),
                //Activities
                const Expanded(
                  child: RecordActivities(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
