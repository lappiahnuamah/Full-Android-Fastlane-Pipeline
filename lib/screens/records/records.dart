import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/screens/records/record_ranks.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: d.pSW(25), vertical: d.pSH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label: 'Records',
            fontWeight: FontWeight.w700,
            fontSize: 24,
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
                // const Expanded(
                //   child: RecordActivities(),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
