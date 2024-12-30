import 'package:flutter/material.dart';

import 'package:teka_tekit/src/components/cells/cells.dart';

/// [isSelected] and [isFocused] is used to change the color of the cell
/// [text] is used to display the text of the cell
/// [onChanged] is used to change the text of the cell
/// [onTap] is used to tap the cell
/// [activeModel] is used to get the text controller and focus node of the cell
class EnabledCell extends StatelessWidget {
  /// constructor
  const EnabledCell({
    required this.activeModel,
    required this.isSelected,
    required this.isFocused,
    required this.text,
    this.onTap,
    this.onChanged,
    super.key,
  });

  /// [isSelected] used to determine if the cell is selected
  final bool isSelected;

  /// [isFocused] used to know if the cell is in the same word of selected cell
  final bool isFocused;

  /// [text] used to display the text of the cell
  final String text;

  /// [activeModel] used to get the text controller and focus node of the cell
  final ActiveCellModel activeModel;

  /// [onChanged] used to change the text of the cell
  final ValueChanged<String>? onChanged;

  /// [onTap] used to tap the cell
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      height: MediaQuery.of(context).size.height / 10,
      decoration: BoxDecoration(
        color: isFocused ? Colors.yellow.withOpacity(isSelected ? 1.0 : 0.5) : Colors.white,
        border: Border.all(color: isSelected ? Colors.green : Colors.white),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
        controller: activeModel.controller,
        focusNode: activeModel.focusNode,
        maxLength: 1,
        showCursor: true,
        autofocus: true,
        decoration: const InputDecoration(
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counterText: '',
        ),
        onChanged: (value) {
          onChanged?.call(value);
        },
        onTap: onTap,
      ),
    );
  }
}
