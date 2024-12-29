/// CrossWordModel
class CrossWordModel {
  /// CrossWordModel
  CrossWordModel({
    required this.id,
    required this.title,
    required this.layout,
    required this.words,
  });

  /// The unique identifier of the crossword.
  final String id;

  /// The title of the crossword.
  final String title;

  /// The list of words in the crossword.
  final List<WordModel> words;

  /// The layout of the crossword.
  CrossWordLayout layout;

  // Selected Word in this crossword
  SelectedCell? selectedCell;

  String getAnswerOfSelectedCell(int col, int row) {
    return words.firstWhere((word) {
      if (word.orientation == 'across') {
        return word.startRow == row && col >= word.startCol && col <= word.endCol;
      } else if (word.orientation == 'down') {
        return word.startCol == col && row >= word.startRow && row <= word.endRow;
      } else {
        return false;
      }
    }).answer;
  }

  /// Get the word of the selected cell
  WordModel getWordOfSelectedCell(int col, int row) {
    return words.firstWhere((word) {
      if (word.orientation == 'across') {
        return word.startRow == row && col >= word.startCol && col <= word.endCol;
      } else if (word.orientation == 'down') {
        return word.startCol == col && row >= word.startRow && row <= word.endRow;
      } else {
        return false;
      }
    });
  }

  /// Check if the cell is selected
  bool isCurrentCellSelected(int col, int row) {
    if (selectedCell == null) {
      return false;
    }
    return selectedCell?.row == row && selectedCell?.col == col;
  }

  /// return true if the cell is enabled
  bool isCellEnabled(int row, int col) {
    return layout.table[row][col] != '-';
  }

  // return the number of active cells (not "-")
  int getNumberOfActiveCells() {
    var count = 0;
    for (var i = 0; i < layout.table.length; i++) {
      for (var j = 0; j < layout.table[i].length; j++) {
        if (layout.table[i][j] != '-') {
          count++;
        }
      }
    }
    return count;
  }

  List<Map<String, int>> getRowAndColActiveCells() {
    final activeCells = <Map<String, int>>[];
    for (var i = 0; i < layout.table.length; i++) {
      for (var j = 0; j < layout.table[i].length; j++) {
        if (layout.table[i][j] != '-') {
          activeCells.add({'row': i, 'col': j});
        }
      }
    }
    return activeCells;
  }

  /// Check if the cell is in the range of the selected cell
  bool isInRangeOfSelectedRow(int col, int row) {
    if (selectedCell == null) {
      return false;
    }

    final selectedWord = getWordOfSelectedCell(selectedCell?.col ?? 0, selectedCell?.row ?? 0);
    if (selectedWord.orientation == 'across') {
      return selectedWord.startRow == row && col >= selectedWord.startCol && col <= selectedWord.endCol;
    } else if (selectedWord.orientation == 'down') {
      return selectedWord.startCol == col && row >= selectedWord.startRow && row <= selectedWord.endRow;
    } else {
      return false;
    }
  }

  SelectedCell? getNextCell(int col, int row) {
    if (isInRangeOfSelectedRow(col, row)) {
      final word = getWordOfSelectedCell(col, row);
      if (word.orientation == 'across') {
        if (col < word.endCol) {
          return SelectedCell(word.startRow, col + 1);
        }
      } else if (word.orientation == 'down') {
        if (row < word.endRow) {
          return SelectedCell(row + 1, word.startCol);
        }
      }
    }
    return null;
  }

  SelectedCell? getPreviousCell(int col, int row) {
    if (isInRangeOfSelectedRow(col, row)) {
      final word = getWordOfSelectedCell(col, row);
      if (word.orientation == 'across') {
        if (col > word.startCol) {
          return SelectedCell(word.startRow, col - 1);
        }
      } else if (word.orientation == 'down') {
        if (row > word.startRow) {
          return SelectedCell(row - 1, word.startCol);
        }
      }
    }
    return null;
  }
}

/// WordModel
class WordModel {
  /// WordModel
  WordModel({
    required this.id,
    required this.title,
    required this.answer,
    required this.position,
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.orientation,
  });

  /// The unique identifier of the word.
  final String id;

  /// The title of the word.
  final String title;

  /// The answer of the word.
  final String answer;

  /// The position of the word.
  final int position;

  /// The starting row of the word.
  final int startRow;

  /// The starting column of the word.
  final int startCol;

  /// The end row of the word.
  final int endRow;

  /// The end column of the word.
  final int endCol;

  /// The orientation of the word.
  final String orientation;
}

/// CrossWordLayout
class CrossWordLayout {
  /// CrossWordLayout
  CrossWordLayout({
    required this.rows,
    required this.cols,
    required this.table,
  });

  /// The number of rows in the crossword.
  int rows;

  /// The number of columns in the crossword.
  int cols;

  /// The table of the crossword.
  List<List<String>> table;
}

class SelectedCell {
  SelectedCell(this.row, this.col);
  final int row;
  final int col;
}
