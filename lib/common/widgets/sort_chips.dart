import 'package:flutter/material.dart';

class SortChips extends StatelessWidget {
  const SortChips({
    super.key,
    required this.labels,
    required this.active,
    required this.onSelected,
  });

  final List<String> labels;
  final int active;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          ChoiceChip(
            label: Text(labels[i]),
            selected: i == active,
            onSelected: (_) => onSelected(i),
          ),
      ],
    );
  }
}
