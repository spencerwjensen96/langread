import 'package:flutter/material.dart';

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
                    height: Curves.easeInOut.transform(value) * 700,
                    width: Curves.easeInOut.transform(value) * 400,
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
              Text('Page ${_currentPage.floor() + 1} of ${widget.pages.length}'),
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

class PageContent extends StatelessWidget {
  final String content;

  const PageContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}