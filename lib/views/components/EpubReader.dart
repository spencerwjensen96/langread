import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/src/widgets/image.dart' as FlutterImage;
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/SmoothPageView.dart';

class EpubReader extends StatefulWidget {
  const EpubReader({super.key});

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  late EpubController _epubReaderController;
  late PageController _pageController;
  Map<String, bool> _selectedWords = {};

  @override
  void initState() {
    super.initState();
    _loadEpub();
  }

  Future<void> _loadEpub() async {
    setState(() {
      _epubReaderController = EpubController(
        document:
            // EpubDocument.openAsset('assets/New-Findings-on-Shirdi-Sai-Baba.epub'),
            EpubDocument.openFile(File(
                '/Users/spencer.jensen/Desktop/Random/Resilio Folders/Book Library/Fiction/Harry Potter Series - JK Rowling/US Edition/01 Harry Potter and the Sorcerer\'s Stone - J.K. Rowling.epub')),
        // epubCfi:
        //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
        // epubCfi:
        //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
      );
      _pageController = PageController(initialPage: 0);
    });
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPreviousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _extractTextFromElement(dom.Element element) {
    return element.text ?? '';
  }

  List<String> _getParagraphsFromBook(paragraphs) {
    List<String> p = [];
    for (var paragraph in paragraphs) {
      p.add(_extractTextFromElement(paragraph.element));
    }
    return p;
  }

  Widget _buildEBook(context, builders, document, chapters, paragraphs, index,
      paragraphIndex, chapterIndex, onExternalLinkPressed) {
    if (paragraphs.isEmpty) {
      return Container();
    }
    print(_getParagraphsFromBook(paragraphs));

    final defaultBuilder = builders as EpubViewBuilders<DefaultBuilderOptions>;
    final options = defaultBuilder.options;

    return Column(
      children: <Widget>[
        if (chapterIndex >= 0 && paragraphIndex == 0)
          // if (_shouldBuildChapterDivider(paragraphs, paragraphIndex))
          builders.chapterDividerBuilder(chapters[chapterIndex]),
        Html(
          data: paragraphs[index].element.outerHtml,
          onLinkTap: (href, _, __) => onExternalLinkPressed(href!),
          style: {
            'html': Style(
              padding: HtmlPaddings.only(
                top: (options.paragraphPadding as EdgeInsets?)?.top,
                right: (options.paragraphPadding as EdgeInsets?)?.right,
                bottom: (options.paragraphPadding as EdgeInsets?)?.bottom,
                left: (options.paragraphPadding as EdgeInsets?)?.left,
              ),
            ).merge(Style.fromTextStyle(options.textStyle)),
          },
          extensions: [
            TagExtension(
              tagsToExtend: {"img"},
              builder: (imageContext) {
                final url =
                    imageContext.attributes['src']!.replaceAll('../', '');
                final content = Uint8List.fromList(
                    document.Content!.Images![url]!.Content!);
                return FlutterImage.Image(
                  image: MemoryImage(content),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_epubReaderController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            _navigateToPreviousPage();
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            _navigateToNextPage();
          }
        },
        child: EpubView(
          controller: _epubReaderController,
          builders: EpubViewBuilders<DefaultBuilderOptions>(
            chapterBuilder: (context,
                    builders,
                    document,
                    chapters,
                    paragraphs,
                    index,
                    paragraphIndex,
                    chapterIndex,
                    onExternalLinkPressed) =>
                index == 0
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context)
                                    .size
                                    .height - 
                                kToolbarHeight - 
                                kBottomNavigationBarHeight),
                        child: SmoothPageView(
                            pages: _getParagraphsFromBook(paragraphs),
                            book: LibraryBook(
                                id: 'id',
                                title: 'HP',
                                author: 'JKR',
                                description: 'description',
                                coverUrl: 'coverUrl',
                                dateAdded: DateTime.now(),
                                genre: 'fantasy',
                                language: 'english')))
                    : Container(),
            options: const DefaultBuilderOptions(),
            //       PageView.builder(
            //     controller: _pageController,
            //     itemCount: paragraphs.length,
            //     itemBuilder: (context, index) {
            //       final paragraphText =
            //           _extractTextFromElement(paragraphs[index].element);
            //       return AnimatedBuilder(
            //           animation: _pageController,
            //           builder: (context, child) {
            //             double value = 1.0;
            //             if (_pageController.position.haveDimensions) {
            //               value = _pageController.page! - index;
            //               value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
            //             }
            //             return Center(
            //               child: SizedBox(
            //                 height: MediaQuery.of(context).size.height *
            //                     Curves.easeInOut.transform(value),
            //                 width: MediaQuery.of(context).size.width *
            //                     Curves.easeInOut.transform(value),
            //                 child: child,
            //               ),
            //             );
            //           },
            //           child: LayoutBuilder(
            //       builder: (BuildContext context, BoxConstraints constraints) {
            //         return SingleChildScrollView(
            //           child: ConstrainedBox(
            //             constraints: BoxConstraints(
            //               minHeight: constraints.maxHeight,
            //             ),
            //             child: IntrinsicHeight(
            //               child: SelectableWordsParagraph(
            //                 text: paragraphText,
            //                 selectedWords: _selectedWords,
            //                 onWordTap: (word) {
            //                   setState(() {
            //                     _selectedWords[word] = !(_selectedWords[word] ?? false);
            //                   });
            //                 },
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   );
            // },
            // ),options: const DefaultBuilderOptions(),
          ),
        ),
      ),
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
