import 'package:e_track/screens/common/populate_row_item.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

Widget swipesView({required String inTime, required String outTime}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Swipes: ",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: colorPrimaryDark),
      ),
      const SizedBox(
        height: 10,
      ),
      PopulateRowItem(label: "First IN Time:", value: inTime),
      const SizedBox(
        height: 10,
      ),
      PopulateRowItem(label: "Last OUT Time:", value: outTime)
    ],
  );
}
