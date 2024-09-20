import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/settings.dart';

class SmoothPageView extends StatefulWidget {
  final List<String> pages;

  const SmoothPageView({Key? key, required this.pages}) : super(key: key);

  @override
  _SmoothPageViewState createState() => _SmoothPageViewState();
}

class _SmoothPageViewState extends State<SmoothPageView> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
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

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            _pageController.previousPage(
              duration: duration,
              curve: Curves.easeInOut,
            );
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            _pageController.nextPage(
              duration: duration,
              curve: Curves.easeInOut,
            );
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
              child: PageContent(content: widget.pages[index]),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Page ${_currentPage.floor() + 1} of ${widget.pages.length}'),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: duration,
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: duration,
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
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

  const PageContent({Key? key, required this.content}) : super(key: key);

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  late List<bool> _wordTapped;

  @override
  void initState() {
    super.initState();
    _wordTapped = List.filled(widget.content.split(' ').length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        final words = widget.content.split(' ');
        return Container(
          decoration: BoxDecoration(
            color: settings.themeMode == ThemeMode.dark
                ? Colors.black
                : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  children: words.asMap().entries.map((entry) {
                    final index = entry.key;
                    final word = entry.value;
                    return TextSpan(
                      text: '$word ',
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        height: 2.0,
                        color: _wordTapped[index]
                            ? Colors.blue
                            : (settings.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _wordTapped[index] = !_wordTapped[index];
                          });
                        },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}