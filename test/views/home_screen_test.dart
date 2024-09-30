// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:langread/views/library_view.dart';
import 'package:langread/views/reading_view.dart';
import 'package:langread/views/settings_view.dart';
import 'package:nock/nock.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:langread/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(nock.init);

  setUp(() {
    nock.cleanAll();
  });

  testWidgets('Titles are properly rendered', (WidgetTester tester) async {

    await mockNetworkImages(() async => tester.pumpWidget(MyApp()));

    expect(find.byType(LibraryView), findsOne);
    expect(find.byType(ReadingView), findsNothing);
    expect(find.byType(SettingsView), findsNothing);

    await tester.tap(find.byIcon(Icons.book));
    await tester.pump();

    expect(find.byType(LibraryView), findsNothing);
    expect(find.byType(ReadingView), findsOne);
    expect(find.byType(SettingsView), findsNothing);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    expect(find.byType(LibraryView), findsNothing);
    expect(find.byType(ReadingView), findsNothing);
    expect(find.byType(SettingsView), findsOne);

  });
}
