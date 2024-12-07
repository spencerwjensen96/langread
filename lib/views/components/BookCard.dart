import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/providers/BookProvider.dart';
import 'package:langread/providers/SettingsProvider.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/reading_view.dart';
import 'package:provider/provider.dart';

class BookCard extends StatefulWidget {
  final LibraryBook book;
  final bool includeMenu;
  final Function(BuildContext, LibraryBook)? onTap;
  const BookCard({
    Key? key,
    required this.book,
    required this.includeMenu,
    this.onTap,
  }) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _menuController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _defaultOnTap(BuildContext context, LibraryBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingView(book: book),
      ),
    );
  }

  void _showMenu() {
    if (_menuController.isShowing) {
      _menuController.hide();
      _animationController.reverse();
    } else {
      _menuController.show();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
          onTap: () {
            widget.onTap != null
                ? widget.onTap!(context, widget.book)
                : _defaultOnTap(context, widget.book);
          },
          onLongPress: _showMenu,
          onLongPressEnd: (_) => _animationController.reverse(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: widget.book.coverUrl.startsWith('file://')
                      ? Image.file(
                          File(widget.book.coverUrl
                              .replaceFirst(RegExp(r'file://'), '')),
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.book.coverUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.book.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Provider.of<SettingsProvider>(context, listen: false)
                              .fontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.book.author,
                  style: TextStyle(
                      fontSize:
                          Provider.of<SettingsProvider>(context, listen: false)
                              .subfontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                widget.includeMenu
                    ? OverlayPortal(
                        controller: _menuController,
                        overlayChildBuilder: (BuildContext context) {
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () => _menuController.hide(),
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              CompositedTransformFollower(
                                link: _layerLink,
                                targetAnchor: Alignment.bottomCenter,
                                followerAnchor: Alignment.topCenter,
                                offset: Offset(0, 0),
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 240,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.book),
                                          title: Text('Read Book'),
                                          onTap: () {
                                            _menuController.hide();
                                            widget.onTap != null
                                                ? widget.onTap!(
                                                    context, widget.book)
                                                : _defaultOnTap(
                                                    context, widget.book);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('Delete from Library'),
                                          onTap: () {
                                            Provider.of<BookProvider>(context,
                                                    listen: false)
                                                .deleteBook(widget.book);
                                            _menuController.hide();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Book deleted')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          )),
    );
  }
}

class EmptyLibraryCard extends StatelessWidget {
  const EmptyLibraryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Your library is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add books to your library to get started',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
