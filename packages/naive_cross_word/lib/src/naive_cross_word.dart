import 'package:naive_cross_word/src/model/crossword_model.dart';

/// {@template naive_cross_word}
/// naive crossword
/// {@endtemplate}
class NaiveCrossWord {
  /// {@macro naive_cross_word}
  NaiveCrossWord();
}

/// dummy crossword
final CrossWordModel dummyCrossWordModel = CrossWordModel(
  id: '1',
  title: 'negara',
  layout: CrossWordLayout(
    rows: 10,
    cols: 10,
    table: [
      ['-', 'I', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', 'N', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', 'D', '-', '-', '-', '-', '-', 'I', '-', '-'],
      ['-', 'O', 'M', 'A', 'N', '-', '-', 'R', '-', '-'],
      ['-', 'N', '-', 'R', '-', '-', '-', 'A', '-', '-'],
      ['-', 'E', '-', 'A', 'F', 'R', 'I', 'K', 'A', '-'],
      ['-', 'S', '-', 'B', '-', '-', '-', '-', '-', '-'],
      ['-', 'I', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', 'A', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-', '-'],
    ],
  ),
  words: [
    WordModel(
      id: 'INDONESIA',
      title: 'INDONESIA',
      answer: 'INDONESIA',
      position: 1,
      startRow: 0,
      startCol: 1,
      endRow: 8,
      endCol: 1,
      orientation: 'down',
    ),
    WordModel(
      id: 'OMAN',
      title: 'OMAN',
      answer: 'OMAN',
      position: 2,
      startRow: 3,
      startCol: 1,
      endRow: 3,
      endCol: 4,
      orientation: 'across',
    ),
    WordModel(
      id: 'ARAB',
      title: 'ARAB',
      answer: 'ARAB',
      position: 3,
      startRow: 3,
      startCol: 3,
      endRow: 6,
      endCol: 3,
      orientation: 'down',
    ),
    WordModel(
      id: 'AFRIKA',
      title: 'AFRIKA',
      answer: 'AFRIKA',
      position: 4,
      startRow: 5,
      startCol: 3,
      endRow: 5,
      endCol: 8,
      orientation: 'across',
    ),
    WordModel(
      id: 'IRAK',
      title: 'IRAK',
      answer: 'IRAK',
      position: 5,
      startRow: 2,
      startCol: 7,
      endRow: 5,
      endCol: 7,
      orientation: 'down',
    ),
  ],
);
