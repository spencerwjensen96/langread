import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:langread/providers/BookProvider.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/DictionaryEntry.dart';
import 'package:langread/views/components/QuizPopup.dart';
import 'package:provider/provider.dart';
import '../../providers/SettingsProvider.dart';
import 'package:flutter_html/flutter_html.dart';

class SmoothPageView extends StatefulWidget {
  final List<String> pages;
  final List<(String, Html)> images;
  final LibraryBook book;
  const SmoothPageView(
      {Key? key, required this.pages, required this.images, required this.book})
      : super(key: key);

  @override
  _SmoothPageViewState createState() => _SmoothPageViewState();
}

class _SmoothPageViewState extends State<SmoothPageView> {
  late PageController _pageController;
  double _currentPage = 0;
  bool _hasInteracted = false;
  final List<String> _interactedWords = <String>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePageController();
  }

  Future<void> _initializePageController() async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final initialIndex = (await bookProvider.getBookmark(widget.book.id)) - 1;

    setState(() {
      _pageController = PageController(initialPage: initialIndex);
      _currentPage = initialIndex.toDouble();
      _isLoading = false;
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onInteraction(String word) {
    setState(() {
      _hasInteracted = true;
    });
    _interactedWords.add(word);
  }

  void _setBookmark({required int pageNumber}) {
    Provider.of<BookProvider>(context, listen: false)
        .setBookmark(widget.book, pageNumber + 1);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: MainAppBar(title: widget.book.title, homeButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
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
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.pages.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                }
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        Curves.easeInOut.transform(value),
                    width: MediaQuery.of(context).size.width *
                        Curves.easeInOut.transform(value),
                    child: child,
                  ),
                );
              },
              child: PageContent(
                content: widget.pages[index],
                images: widget.images,
                onInteraction: _onInteraction,
              ),
            );
          },
          onPageChanged: (value) {
            if (value < _currentPage) {
              setState(() {
                _hasInteracted = false;
                _interactedWords.clear();
              });
            }
            _setBookmark(pageNumber: value);
            if (_hasInteracted) {
              showDialog(
                context: context,
                builder: (context) {
                  return QuizPopup(
                    pageContent: "hello",
                    sourceLanguage: "en",
                    targetLanguage: "sv",
                    words: _interactedWords,
                    onQuizComplete: () {
                      setState(() {
                        _hasInteracted = false;
                        _interactedWords.clear();
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/vocabulary');
                },
                child: Text('Vocab'),
              ),
              Text(
                  'Page ${_currentPage.floor() + 1} of ${widget.pages.length}'),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _navigateToPreviousPage();
                      }),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        _navigateToNextPage();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageContent extends StatefulWidget {
  final String content;
  final List<(String, Html)> images;
  final Function onInteraction;

  const PageContent(
      {super.key,
      required this.content,
      required this.images,
      required this.onInteraction});

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  late List<bool> _wordTapped;

  _PageContentState();

  @override
  void initState() {
    super.initState();
    _wordTapped = List.filled(widget.content.split(' ').length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final words = widget.content.replaceAll(r'\n', '\n').split(' ');
        return Padding(
          padding: const EdgeInsets.all(48.0),
          child: SingleChildScrollView(
            child: Text.rich(
              TextSpan(
                children: words.asMap().entries.map((entry) {
                  final index = entry.key;
                  final word = entry.value.replaceAll(RegExp(r'^\s+'), '');
                  if (word.startsWith(RegExp("#img[0-9]+"))) {
                    var image = widget.images
                        .firstWhere(
                          (img) => img.$1 == word.trim(),
                          orElse: () => ('', Html(data: '')),
                        )
                        .$2;
                    return WidgetSpan(child: image);
                                    }
                  return TextSpan(
                    text: '$word ',
                    style: TextStyle(
                      fontSize: settings.fontSize,
                      height: settings.lineHeight,
                      color: _wordTapped[index]
                          ? Colors.blue
                          : (settings.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (!_wordTapped[index]) {
                          // Fetch the meaning from a dictionary.
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: ((context) {
                                return DraggableScrollableSheet(
                                    expand: false,
                                    snap: true,
                                    builder: (_, controller) {
                                      return SingleChildScrollView(
                                          controller: controller,
                                          child: DictionaryEntryWidget(
                                              word: word,
                                              context: widget.content));
                                    });
                              }));
                        }
                        setState(() {
                          _wordTapped[index] = !_wordTapped[index];
                        });
                        widget.onInteraction(word);
                      },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
