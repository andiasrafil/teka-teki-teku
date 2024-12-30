// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:teka_tekit/teka_tekit.dart';

void main() {
  group('TekaTekit', () {
    patrolWidgetTest('Test widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisabledCell(),
          ),
        ),
      );
      expect(tester(DisabledCell), findsOneWidget);
    });

    patrolWidgetTest('Enabled Cell', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnabledCell(
              activeModel:
                  ActiveCellModel(0, 0, TextEditingController(), FocusNode()),
              isSelected: false,
              isFocused: false,
              text: 'A',
            ),
          ),
        ),
      );
      expect(tester(EnabledCell), findsOneWidget);
    });
  });
}
