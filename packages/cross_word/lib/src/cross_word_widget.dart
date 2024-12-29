// import 'package:cross_word/cross_word.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CrosswordWidget extends StatefulWidget {
//   final List<Map<String, dynamic>> words;
//   final CrosswordStyle style;
//   final Function(Function) onRevealCurrentCellLetter;
//   final VoidCallback? onCrosswordCompleted;

//   CrosswordWidget({
//     required this.words,
//     this.style = const CrosswordStyle(),
//     required this.onRevealCurrentCellLetter,
//     this.onCrosswordCompleted,
//   });

//   @override
//   _CrosswordWidgetState createState() => _CrosswordWidgetState();
// }

// class _CrosswordWidgetState extends State<CrosswordWidget> {
//   List<List<String>> _table = [];
//   List<Map<String, dynamic>> _words = [];
//   int _selectedRow = -1;
//   int _selectedCol = -1;
//   bool _isHorizontal = true;
//   String _highlightedWordDescription = "";
//   Set<String> _revealedCells = {}; // New state variable

//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _inputController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _inputController.addListener(_handleInput);
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         RawKeyboard.instance.addListener(_handleKeyEvent);
//       } else {
//         RawKeyboard.instance.removeListener(_handleKeyEvent);
//       }
//     });
//     _generateLayout();
//     // Pass the reveal method to the parent
//     widget.onRevealCurrentCellLetter(revealCurrentCellLetter);
//   }

//   @override
//   void dispose() {
//     _inputController.removeListener(_handleInput);
//     _inputController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _generateLayout() {
//     CrosswordGenerator generator = CrosswordGenerator();
//     Map<String, dynamic> layout = generator.generateLayout(ensureDynamic(widget.words), false);

//     setState(() {
//       _table = List<List<String>>.from(layout['table'].map((row) => List<String>.from(row.map((cell) => cell == '-' ? '-' : ''))));
//       _words = layout['result'];
//       _selectedRow = -1;
//       _selectedCol = -1;
//       _isHorizontal = true;
//       _highlightedWordDescription = "";
//     });
//   }

//   List<Map<String, dynamic>> ensureDynamic(List<Map<String, dynamic>> input) {
//     return input.map((word) => Map<String, dynamic>.from(word)).toList();
//   }

//   void _onCellTap(int row, int col) {
//     setState(() {
//       bool hasVertical = false;
//       int rowStart = row;
//       while (rowStart > 0 && _table[rowStart - 1][col] != '-') {
//         rowStart--;
//       }
//       int rowEnd = row;
//       while (rowEnd < _table.length - 1 && _table[rowEnd + 1][col] != '-') {
//         rowEnd++;
//       }
//       if (rowEnd > rowStart) {
//         hasVertical = true;
//       }

//       bool hasHorizontal = false;
//       int colStart = col;
//       while (colStart > 0 && _table[row][colStart - 1] != '-') {
//         colStart--;
//       }
//       int colEnd = col;
//       while (colEnd < _table[0].length - 1 && _table[row][colEnd + 1] != '-') {
//         colEnd++;
//       }
//       if (colEnd > colStart) {
//         hasHorizontal = true;
//       }

//       if (_selectedRow == row && _selectedCol == col) {
//         if (hasHorizontal && hasVertical) {
//           _isHorizontal = !_isHorizontal;
//         }
//       } else {
//         _selectedRow = row;
//         _selectedCol = col;
//         _isHorizontal = hasHorizontal || !hasVertical;
//       }

//       _highlightedWordDescription = _getWordDescription(row, col, _isHorizontal);

//       // Ensure focus is set to the input field
//       FocusScope.of(context).requestFocus(_focusNode);
//       SystemChannels.textInput.invokeMethod('TextInput.show');

//       // Clear the input controller
//       _inputController.clear();
//     });
//   }

//   void revealCurrentCellLetter() {
//     if (_selectedRow != -1 && _selectedCol != -1) {
//       setState(() {
//         for (var word in _words) {
//           if (word['orientation'] == 'across') {
//             int startY = word['starty'] - 1;
//             int startX = word['startx'] - 1;
//             if (startY == _selectedRow && startX <= _selectedCol && startX + word['answer'].length > _selectedCol) {
//               _table[_selectedRow][_selectedCol] = word['answer'][_selectedCol - startX].toUpperCase();
//               _revealedCells.add('$_selectedRow,$_selectedCol'); // Mark as revealed
//               break;
//             }
//           } else if (word['orientation'] == 'down') {
//             int startY = word['starty'] - 1;
//             int startX = word['startx'] - 1;
//             if (startX == _selectedCol && startY <= _selectedRow && startY + word['answer'].length > _selectedRow) {
//               _table[_selectedRow][_selectedCol] = word['answer'][_selectedRow - startY].toUpperCase();
//               _revealedCells.add('$_selectedRow,$_selectedCol'); // Mark as revealed
//               break;
//             }
//           }
//         }

//         // Move to the next unsolved letter or word
//         _moveToNextUnsolvedLetterOrWord();

//         // Validate the word after revealing the letter
//         _validateWord();
//       });
//     }
//   }

//   void _moveToNextUnsolvedLetterOrWord() {
//     Map<String, int> boundaries = _getCurrentWordBoundaries();

//     if (_isHorizontal) {
//       for (int col = _selectedCol + 1; col <= boundaries['endCol']!; col++) {
//         if (!_isCellCompleted(_selectedRow, col) && _table[_selectedRow][col] != '-') {
//           _selectedCol = col;
//           return;
//         }
//       }
//     } else {
//       for (int row = _selectedRow + 1; row <= boundaries['endRow']!; row++) {
//         if (!_isCellCompleted(row, _selectedCol) && _table[row][_selectedCol] != '-') {
//           _selectedRow = row;
//           return;
//         }
//       }
//     }

//     // If no unsolved letter found in the current word, move to the next word
//     _moveToNextWord();
//   }

//   String _getWordDescription(int row, int col, bool isHorizontal) {
//     for (var word in _words) {
//       if (word['orientation'] == 'across' && isHorizontal) {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startY == row && startX <= col && startX + word['answer'].length > col) {
//           return word['description'];
//         }
//       } else if (word['orientation'] == 'down' && !isHorizontal) {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startX == col && startY <= row && startY + word['answer'].length > row) {
//           return word['description'];
//         }
//       }
//     }
//     return "";
//   }

//   List<List<bool>> _getHighlightedCells() {
//     List<List<bool>> highlightedCells = List.generate(_table.length, (_) => List.filled(_table[0].length, false));

//     if (_selectedRow != -1 && _selectedCol != -1) {
//       if (_isHorizontal) {
//         int colStart = _selectedCol;
//         while (colStart > 0 && _table[_selectedRow][colStart - 1] != '-') {
//           colStart--;
//         }
//         int colEnd = _selectedCol;
//         while (colEnd < _table[0].length - 1 && _table[_selectedRow][colEnd + 1] != '-') {
//           colEnd++;
//         }
//         for (int col = colStart; col <= colEnd; col++) {
//           highlightedCells[_selectedRow][col] = true;
//         }
//       } else {
//         int rowStart = _selectedRow;
//         while (rowStart > 0 && _table[rowStart - 1][_selectedCol] != '-') {
//           rowStart--;
//         }
//         int rowEnd = _selectedRow;
//         while (rowEnd < _table.length - 1 && _table[rowEnd + 1][_selectedCol] != '-') {
//           rowEnd++;
//         }
//         for (int row = rowStart; row <= rowEnd; row++) {
//           highlightedCells[row][_selectedCol] = true;
//         }
//       }
//     }

//     return highlightedCells;
//   }

//   Widget _buildGrid() {
//     if (_table.isEmpty) {
//       return Container();
//     }

//     List<List<bool>> highlightedCells = _getHighlightedCells();

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Center(
//           child: Column(
//             children: _table.asMap().entries.map((entry) {
//               int rowIndex = entry.key;
//               List<String> row = entry.value;
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: row.asMap().entries.map((cellEntry) {
//                   int colIndex = cellEntry.key;
//                   String cell = cellEntry.value;
//                   bool isCompletedCell = _isCellCompleted(rowIndex, colIndex);
//                   bool isSelected = rowIndex == _selectedRow && colIndex == _selectedCol;
//                   bool isHighlighted = highlightedCells[rowIndex][colIndex];

//                   if (cell == '-') {
//                     return Container(
//                       width: 30,
//                       height: 30,
//                       margin: EdgeInsets.all(1),
//                       color: Colors.black,
//                     );
//                   } else {
//                     return GestureDetector(
//                       onTap: () {
//                         _onCellTap(rowIndex, colIndex);
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             width: 30,
//                             height: 30,
//                             alignment: Alignment.center,
//                             margin: EdgeInsets.all(1),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black),
//                               color: isCompletedCell
//                                   ? widget.style.wordCompleteColor
//                                   : isSelected
//                                       ? widget.style.currentCellColor
//                                       : isHighlighted
//                                           ? widget.style.wordHighlightColor
//                                           : Colors.white,
//                             ),
//                             child: Text(
//                               cell.toUpperCase(),
//                               style: widget.style.cellTextStyle,
//                             ),
//                           ),
//                           isFirstLetter(rowIndex, colIndex)
//                               ? Positioned(top: 2, left: 2, child: Text(questionNumber(rowIndex, colIndex), style: TextStyle(fontSize: 4, color: Colors.black)))
//                               : Container(),
//                         ],
//                       ),
//                     );
//                   }
//                 }).toList(),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   bool isFirstLetter(int row, int col) {
//     for (var word in _words) {
//       if (word['orientation'] == 'across') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startY == row && startX == col && startX + word['answer'].length > col) {
//           return true;
//         }
//       } else if (word['orientation'] == 'down') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startX == col && startY == row && startY + word['answer'].length > row) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }

//   void _validateWord() {
//     for (var word in _words) {
//       bool isCorrect = true;
//       if (word['orientation'] == 'across') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         for (int k = 0; k < word['answer'].length; k++) {
//           if (_table[startY][startX + k].toLowerCase() != word['answer'][k]) {
//             isCorrect = false;
//             break;
//           }
//         }
//         if (isCorrect) {
//           for (int k = 0; k < word['answer'].length; k++) {
//             _table[startY][startX + k] = word['answer'][k].toUpperCase();
//           }
//           word['completed'] = true;
//         }
//       } else if (word['orientation'] == 'down') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         for (int k = 0; k < word['answer'].length; k++) {
//           if (_table[startY + k][startX].toLowerCase() != word['answer'][k]) {
//             isCorrect = false;
//             break;
//           }
//         }
//         if (isCorrect) {
//           for (int k = 0; k < word['answer'].length; k++) {
//             _table[startY + k][startX] = word['answer'][k].toUpperCase();
//           }
//           word['completed'] = true;
//         }
//       }
//     }
//     if (_areAllWordsCompleted()) {
//       if (widget.onCrosswordCompleted != null) {
//         widget.onCrosswordCompleted!(); // Call the completion callback
//       } else {
//         _showCongratsDialog();
//       }
//     }
//   }

//   bool _isCellCompleted(int row, int col) {
//     if (_revealedCells.contains('$row,$col')) {
//       return true; // Cell is revealed, thus completed
//     }

//     for (var word in _words) {
//       if (word.containsKey('completed') && word['completed']) {
//         if (word['orientation'] == 'across') {
//           int startY = word['starty'] - 1;
//           int startX = word['startx'] - 1;
//           num endX = startX + word['answer'].length - 1;
//           if (startY == row && startX <= col && endX >= col) {
//             return true;
//           }
//         } else if (word['orientation'] == 'down') {
//           int startY = word['starty'] - 1;
//           int startX = word['startx'] - 1;
//           num endY = startY + word['answer'].length - 1;
//           if (startX == col && startY <= row && endY >= row) {
//             return true;
//           }
//         }
//       }
//     }
//     return false;
//   }

//   String questionNumber(int row, int col) {
//     for (var word in _words) {
//       if (word['starty'] - 1 == row && word['startx'] - 1 == col) {
//         return word['number'].toString();
//       }
//     }
//     return '';
//   }

//   String questionNumberLine(int row, int col) {
//     for (var word in _words) {
//       if (word['orientation'] == 'across') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startY == row && startX <= col && startX + word['answer'].length > col) {
//           return word['number'].toString();
//         }
//       } else if (word['orientation'] == 'down') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startX == col && startY <= row && startY + word['answer'].length > row) {
//           return word['number'].toString();
//         }
//       }
//     }
//     return '';
//   }

//   String getAlignment(int row, int col) {
//     for (var word in _words) {
//       if (word['orientation'] == 'across') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startY == row && startX <= col && startX + word['answer'].length > col) {
//           return 'mendatar';
//         }
//       } else if (word['orientation'] == 'down') {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (startX == col && startY <= row && startY + word['answer'].length > row) {
//           return 'menurun';
//         }
//       }
//     }
//     return '';
//   }

//   int _currentWordIndex = -1;
//   void _moveToPreviousWord() {
//     if (_words.isEmpty) return;

//     if (_currentWordIndex == -1) {
//       _currentWordIndex = _words.indexWhere((word) => !word.containsKey('completed') || !word['completed']);
//     } else {
//       _currentWordIndex--;
//     }

//     if (_currentWordIndex < 0) {
//       _currentWordIndex = _words.length - 1;
//     }

//     setState(() {
//       var word = _words[_currentWordIndex];
//       _isHorizontal = word['orientation'] == 'across';
//       _selectedRow = word['starty'] - 1;
//       _selectedCol = word['startx'] - 1;
//       _highlightedWordDescription = word['description'];
//       while (_isCellCompleted(_selectedRow, _selectedCol)) {
//         if (_isHorizontal) {
//           if (_selectedCol + 1 < _table[0].length) {
//             _selectedCol++;
//           } else {
//             break;
//           }
//         } else {
//           if (_selectedRow + 1 < _table.length) {
//             _selectedRow++;
//           } else {
//             break;
//           }
//         }
//       }
//     });
//   }

//   void _moveToNextWord() {
//     if (_words.isEmpty) return;

//     if (_currentWordIndex == -1) {
//       _currentWordIndex = _words.indexWhere((word) => !word.containsKey('completed') || !word['completed']);
//     } else {
//       _currentWordIndex++;
//     }

//     if (_currentWordIndex >= _words.length) {
//       _currentWordIndex = 0;
//     }

//     setState(() {
//       var word = _words[_currentWordIndex];
//       _isHorizontal = word['orientation'] == 'across';
//       _selectedRow = word['starty'] - 1;
//       _selectedCol = word['startx'] - 1;
//       _highlightedWordDescription = word['description'];
//       while (_isCellCompleted(_selectedRow, _selectedCol)) {
//         if (_isHorizontal) {
//           if (_selectedCol + 1 < _table[0].length) {
//             _selectedCol++;
//           } else {
//             break;
//           }
//         } else {
//           if (_selectedRow + 1 < _table.length) {
//             _selectedRow++;
//           } else {
//             break;
//           }
//         }
//       }
//     });
//   }

//   void _handleInput() {
//     if (_selectedRow != -1 && _selectedCol != -1 && _inputController.text.isNotEmpty) {
//       setState(() {
//         String inputLetter = _inputController.text[0].toLowerCase();
//         if (!_isCellCompleted(_selectedRow, _selectedCol) && _table[_selectedRow][_selectedCol].toLowerCase() != inputLetter) {
//           _table[_selectedRow][_selectedCol] = inputLetter;
//         }
//         _inputController.clear();

//         Map<String, int> boundaries = _getCurrentWordBoundaries();

//         if (_isHorizontal) {
//           for (int col = _selectedCol + 1; col <= boundaries['endCol']!; col++) {
//             if (!_isCellCompleted(_selectedRow, col) && _table[_selectedRow][col] != '-') {
//               _selectedCol = col;
//               break;
//             }
//           }
//         } else {
//           for (int row = _selectedRow + 1; row <= boundaries['endRow']!; row++) {
//             if (!_isCellCompleted(row, _selectedCol) && _table[row][_selectedCol] != '-') {
//               _selectedRow = row;
//               break;
//             }
//           }
//         }

//         if (_isWordComplete()) {
//           _validateWord();
//           _moveToNextWord();
//         }
//       });
//     }
//   }

//   int _getWordLength(int row, int col, bool isHorizontal) {
//     for (var word in _words) {
//       if (word['orientation'] == (isHorizontal ? 'across' : 'down')) {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (isHorizontal) {
//           if (startY == row && startX <= col && startX + word['answer'].length > col) {
//             return word['answer'].length;
//           }
//         } else {
//           if (startX == col && startY <= row && startY + word['answer'].length > row) {
//             return word['answer'].length;
//           }
//         }
//       }
//     }
//     return 0;
//   }

//   String? _getQuestionNumberForCell(int row, int col) {
//     for (var word in _words) {
//       if (word['starty'] - 1 == row && word['startx'] - 1 == col) {
//         return word['number'].toString();
//       }
//     }
//     return null;
//   }

//   bool _isWordComplete() {
//     for (var word in _words) {
//       if (word['orientation'] == (_isHorizontal ? 'across' : 'down')) {
//         int startY = word['starty'] - 1;
//         int startX = word['startx'] - 1;
//         if (_isHorizontal) {
//           if (startY == _selectedRow && startX <= _selectedCol && startX + word['answer'].length > _selectedCol) {
//             for (int k = 0; k < word['answer'].length; k++) {
//               if (_table[startY][startX + k].toLowerCase() != word['answer'][k]) {
//                 return false;
//               }
//             }
//             return true;
//           }
//         } else {
//           if (startX == _selectedCol && startY <= _selectedRow && startY + word['answer'].length > _selectedRow) {
//             for (int k = 0; k < word['answer'].length; k++) {
//               if (_table[startY + k][startX].toLowerCase() != word['answer'][k]) {
//                 return false;
//               }
//             }
//             return true;
//           }
//         }
//       }
//     }
//     return false;
//   }

//   Map<String, int> _getCurrentWordBoundaries() {
//     int startRow = _selectedRow;
//     int endRow = _selectedRow;
//     int startCol = _selectedCol;
//     int endCol = _selectedCol;

//     if (_isHorizontal) {
//       while (startCol > 0 && _table[_selectedRow][startCol - 1] != '-') {
//         startCol--;
//       }
//       while (endCol < _table[0].length - 1 && _table[_selectedRow][endCol + 1] != '-') {
//         endCol++;
//       }
//     } else {
//       while (startRow > 0 && _table[startRow - 1][_selectedCol] != '-') {
//         startRow--;
//       }
//       while (endRow < _table.length - 1 && _table[endRow + 1][_selectedCol] != '-') {
//         endRow++;
//       }
//     }

//     return {
//       'startRow': startRow,
//       'endRow': endRow,
//       'startCol': startCol,
//       'endCol': endCol,
//     };
//   }

//   void _handleKeyEvent(RawKeyEvent event) {
//     if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
//       setState(() {
//         if (_selectedRow != -1 && _selectedCol != -1 && !_isCellCompleted(_selectedRow, _selectedCol)) {
//           _table[_selectedRow][_selectedCol] = '';

//           Map<String, int> boundaries = _getCurrentWordBoundaries();

//           if (_isHorizontal) {
//             for (int col = _selectedCol - 1; col >= boundaries['startCol']!; col--) {
//               if (!_isCellCompleted(_selectedRow, col) && _table[_selectedRow][col] != '-') {
//                 _selectedCol = col;
//                 return;
//               }
//             }
//           } else {
//             for (int row = _selectedRow - 1; row >= boundaries['startRow']!; row--) {
//               if (!_isCellCompleted(row, _selectedCol) && _table[row][_selectedCol] != '-') {
//                 _selectedRow = row;
//                 return;
//               }
//             }
//           }
//         }
//       });
//     }
//   }

//   bool _areAllWordsCompleted() {
//     for (var word in _words) {
//       if (!word.containsKey('completed') || !word['completed']) {
//         return false;
//       }
//     }
//     return true;
//   }

//   void _showCongratsDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Congratulations!'),
//           content: Text('You have completed the crossword puzzle.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_focusNode.hasFocus) {
//           _focusNode.unfocus();
//           return false;
//         }
//         return true;
//       },
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: MediaQuery.of(context).size.height,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       constraints: BoxConstraints(),
//                       child: _buildGrid(),
//                     ),
//                     Offstage(
//                       child: TextField(
//                         focusNode: _focusNode,
//                         controller: _inputController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                         ),
//                         autofocus: true,
//                         showCursor: false,
//                         maxLength: 1,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (_highlightedWordDescription.isNotEmpty)
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: Colors.black.withOpacity(0.8),
//                 padding: EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _moveToPreviousWord,
//                       child: Text('<'),
//                       style: widget.style.descriptionButtonStyle,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             '${questionNumberLine(_selectedRow, _selectedCol)} ${getAlignment(_selectedRow, _selectedCol)}',
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             _highlightedWordDescription,
//                             style: TextStyle(color: Colors.white),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: _moveToNextWord,
//                       child: Text('>'),
//                       style: widget.style.descriptionButtonStyle,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
