import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class PopulateRowItem extends StatelessWidget {
  final String label;
  final String? value;

  const PopulateRowItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(color: colorBlack, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(value ?? '',
                style: const TextStyle(
                    color: colorBlack)),
          ),
        ],
      ),
    );
  }
}
