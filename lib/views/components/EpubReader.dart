import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/src/widgets/image.dart' as FlutterImage;
import 'package:langread/providers/SettingsProvider.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/SmoothPageView.dart';
import 'package:provider/provider.dart';

class EpubReader extends StatefulWidget {
  final LibraryBook book;
  final File bookFile;
  const EpubReader({super.key, required this.book, required this.bookFile});

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  late EpubController _epubReaderController;
  late PageController _pageController;
  late Future<bool> loaded;

  @override
  void initState() {
    super.initState();
    _loadEpub();
  }

  Future<void> _loadEpub() async {
    setState(() {
      _epubReaderController = EpubController(
        document:
            EpubDocument.openFile(widget.bookFile),
      );
      _pageController = PageController();
      loaded = Future.value(true);
    });
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _extractTextFromElement(dom.Element element) {
    return element.text ?? '';
  }

  List<String> _getParagraphsFromBook(paragraphs, {int minWordsPerPage = 30}) {
    List<String> finalParagraphs = [];
    String page = '';
    int wordCount = 0;

    for (var paragraph in paragraphs) {
      String newParagraph = _extractTextFromElement(paragraph.element);
      if (newParagraph.isEmpty) {
        finalParagraphs.add(newParagraph);
        continue;
      }
      int newParagraphWordCount = newParagraph.split(" ").length;

      if (wordCount + newParagraphWordCount >= minWordsPerPage) {
      finalParagraphs.add(page.trim());
      page = '';
      wordCount = 0;
      }

      page = """$page
      
      ${newParagraph.replaceAll(RegExp('\n'), ' ')}""".trim();
      wordCount += newParagraphWordCount;
    }
    if (page.isNotEmpty) {
      finalParagraphs.add(page.trim());
    }
    return finalParagraphs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return EpubView(
            controller: _epubReaderController,
            builders: EpubViewBuilders<DefaultBuilderOptions>(
              chapterBuilder: (context, builders, document, chapters, paragraphs, index, paragraphIndex, chapterIndex, onExternalLinkPressed) =>
                  index == 0
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  kBottomNavigationBarHeight),
                          child: SmoothPageView(
                              pages: _getParagraphsFromBook(paragraphs),
                              book: widget.book))
                      : Container(),
              options: DefaultBuilderOptions(
                textStyle: TextStyle(
                  height: Provider.of<SettingsProvider>(context).lineHeight,
                  fontSize: Provider.of<SettingsProvider>(context).fontSize,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class SelectableWordsParagraph extends StatelessWidget {
  final String text;
  final Map<String, bool> selectedWords;
  final Function(String) onWordTap;

  SelectableWordsParagraph({
    required this.text,
    required this.selectedWords,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Wrap(
      children: words.map((word) {
        return GestureDetector(
          onTap: () => onWordTap(word),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            color: selectedWords[word] == true
                ? Colors.yellow
                : Colors.transparent,
            child: Text(word),
          ),
        );
      }).toList(),
    );
  }
}
