import 'package:flutter/material.dart';

/// active cell model
class ActiveCellModel {
  /// constructor
  ActiveCellModel(this.col, this.row, this.controller, this.focusNode);

  /// column
  int col;

  /// row
  int row;

  /// text controller
  TextEditingController controller;

  /// focus node
  FocusNode focusNode;

  /// generate active cell model
  static List<ActiveCellModel> generate(List<Map<String, int>> cells) {
    final activeCellModels = <ActiveCellModel>[];
    for (var i = 0; i < cells.length; i++) {
      activeCellModels.add(
        ActiveCellModel(
          cells[i]['col']!,
          cells[i]['row']!,
          TextEditingController(),
          FocusNode(),
        ),
      );
    }
    return activeCellModels;
  }
}
