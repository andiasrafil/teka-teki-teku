import 'package:flutter/material.dart';
import 'package:naive_cross_word/naive_cross_word.dart';

class CrosswordWidget extends StatefulWidget {
  const CrosswordWidget({
    required this.crossWordModel,
    super.key,
  });
  final CrossWordModel crossWordModel;

  @override
  State<CrosswordWidget> createState() => _CrosswordWidgetState();
}

class ActiveCellModel {
  ActiveCellModel(this.col, this.row, this.controller, this.focusNode);
  int col;
  int row;
  TextEditingController controller;
  FocusNode focusNode;

  static List<ActiveCellModel> generate(List<Map<String, int>> cells) {
    final activeCellModels = <ActiveCellModel>[];
    for (var i = 0; i < cells.length; i++) {
      activeCellModels.add(ActiveCellModel(cells[i]['col']!, cells[i]['row']!, TextEditingController(), FocusNode()));
    }
    return activeCellModels;
  }
}

class _CrosswordWidgetState extends State<CrosswordWidget> {
  List<ActiveCellModel> activeCellModels = [];
  @override
  void initState() {
    activeCellModels = ActiveCellModel.generate(widget.crossWordModel.getRowAndColActiveCells());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, rowIndex) {
        return SizedBox(
          height: MediaQuery.of(context).size.width / 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, colIndex) {
              return widget.crossWordModel.isCellEnabled(rowIndex, colIndex)
                  ? EnabledCell(
                      activeModel: getActiveCellModel(colIndex, rowIndex),
                      isSelected: widget.crossWordModel.isCurrentCellSelected(colIndex, rowIndex),
                      isFocused: widget.crossWordModel.isInRangeOfSelectedRow(colIndex, rowIndex),
                      text: widget.crossWordModel.layout.table[rowIndex][colIndex],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _setNextFocus(colIndex, rowIndex);
                          _validateUserInput(colIndex, rowIndex);
                        } else {
                          _setPreviousFocus(colIndex, rowIndex);
                        }
                      },
                      onTap: () {
                        setState(() {
                          widget.crossWordModel.selectedCell = SelectedCell(
                            rowIndex,
                            colIndex,
                          );
                        });
                      },
                    )
                  : const DisabledCell();
            },
            itemCount: widget.crossWordModel.layout.rows,
          ),
        );
      },
      itemCount: widget.crossWordModel.layout.cols,
    );
  }

  void _setNextFocus(int col, int row) {
    if (activeCellModels.isNotEmpty) {
      final nextCell = widget.crossWordModel.getNextCell(col, row);
      if (nextCell != null) {
        final nextActiveModel = getActiveCellModel(nextCell.col, nextCell.row);
        FocusScope.of(context).requestFocus(nextActiveModel.focusNode);
        setState(() {
          widget.crossWordModel.selectedCell = nextCell;
        });
      }
    }
  }

  void _setPreviousFocus(int col, int row) {
    if (activeCellModels.isNotEmpty) {
      final previousCell = widget.crossWordModel.getPreviousCell(col, row);
      if (previousCell != null) {
        final previousActiveModel = getActiveCellModel(previousCell.col, previousCell.row);
        FocusScope.of(context).requestFocus(previousActiveModel.focusNode);
        setState(() {
          widget.crossWordModel.selectedCell = previousCell;
        });
      }
    }
  }

  void _validateUserInput(int col, int row) {
    final word = widget.crossWordModel.getWordOfSelectedCell(col, row);
    final activeModels = activeCellModels.where((element) {
      if (word.orientation == 'across') {
        return element.row == word.startRow && element.row == word.endRow && element.col >= word.startCol && element.col <= word.endCol;
      } else if (word.orientation == 'down') {
        return element.col == word.startCol && element.col == word.endCol && element.row >= word.startRow && element.row <= word.endRow;
      }
      return false;
    }).toList();
    final inputtedText = activeModels.map((element) => element.controller.text).join();
    if (word.answer.length == inputtedText.length) {
      if (word.answer.toUpperCase() == inputtedText.toUpperCase()) {
        if (_isGameCompleted()) {}
      } else {}
    }
  }

  bool _isGameCompleted() {
    var correctWord = 0;
    for (var i = 0; i < widget.crossWordModel.words.length; i++) {
      final word = widget.crossWordModel.words[i];
      final activeModels = activeCellModels.where((element) {
        if (word.orientation == 'across') {
          return element.row == word.startRow && element.row == word.endRow && element.col >= word.startCol && element.col <= word.endCol;
        } else if (word.orientation == 'down') {
          return element.col == word.startCol && element.col == word.endCol && element.row >= word.startRow && element.row <= word.endRow;
        }
        return false;
      }).toList();
      final inputtedText = activeModels.map((element) => element.controller.text).join();
      if (activeModels.length == word.answer.length && word.answer.toUpperCase() == inputtedText.toUpperCase()) {
        correctWord++;
      }
    }
    return correctWord == widget.crossWordModel.words.length;
  }

  ActiveCellModel getActiveCellModel(int col, int row) {
    return activeCellModels.firstWhere((element) => element.col == col && element.row == row);
  }
}

class DisabledCell extends StatelessWidget {
  const DisabledCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      height: MediaQuery.of(context).size.width / 10,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white),
      ),
    );
  }
}

class EnabledCell extends StatelessWidget {
  const EnabledCell({required this.activeModel, required this.isSelected, required this.isFocused, required this.text, this.onTap, this.onChanged, super.key});
  final bool isSelected;
  final bool isFocused;
  final String text;
  final ActiveCellModel activeModel;
  final ValueChanged<String>? onChanged;
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
