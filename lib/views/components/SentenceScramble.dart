import 'package:flutter/material.dart';

class SentenceScramble extends StatefulWidget {
  final String originalSentence;
  final String translatedSentence;
  final Function onQuestionFinish;

  const SentenceScramble({
    Key? key,
    required this.originalSentence,
    required this.translatedSentence,
    required this.onQuestionFinish,
  }) : super(key: key);

  @override
  _SentenceScrambleState createState() => _SentenceScrambleState();
}

class _SentenceScrambleState extends State<SentenceScramble> {
  late List<String> scrambledWords;
  late List<String> orderedWords;
  late List<String> userAnswer;

  @override
  void initState() {
    super.initState();
    print(widget.translatedSentence);
    print(widget.originalSentence);
  
    _initializeWords();
  }

  @override
  void didUpdateWidget(covariant SentenceScramble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translatedSentence != widget.translatedSentence) {
      _initializeWords();
    }
  }

  void _initializeWords() {
    orderedWords = widget.translatedSentence.split(' ');
    scrambledWords = List.from(orderedWords)..shuffle();
    userAnswer = [];
  }

  void _updateUserAnswer(String word) {
    setState(() {
      userAnswer.add(word);
    });
  }

  void _onSubmit() {
    bool isCorrect = listEquals(userAnswer, orderedWords);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
          content: Text(isCorrect
              ? 'Great job! You arranged the sentence correctly.'
              : 'The correct order is: ${orderedWords.join(' ')}'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onQuestionFinish("answer");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arrange the translation:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            widget.originalSentence,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 16),
          Text(
            'Your answer:',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: userAnswer
                .map((word) => Chip(
                      label: Text(word),
                      onDeleted: () {
                        setState(() {
                          userAnswer.remove(word);
                        });
                      },
                    ))
                .toList(),
          ),
          SizedBox(height: 8),
          Wrap(direction: Axis.horizontal, children: [
            for (final word in scrambledWords)
              Draggable<String>(
                  data: word,
                  child: Card(
                    key: UniqueKey(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(word),
                    ),
                  ),
                  feedback: Opacity(
                    opacity: 0.75,
                    child: Card(
                      key: UniqueKey(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(word),
                      ),
                    ),
                  ))
          ]),
          SizedBox(height: 8),
          DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        'Drop Here',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                ),
              );
            },
            onWillAcceptWithDetails: (data) => data != "Bad Input",
            onAcceptWithDetails: (data) => _updateUserAnswer(data.data),
            // onLeave: (data) {
            //   print("leaving $data");
            // },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onSubmit,
            // userAnswer.length == orderedWords.length ? _onSubmit : null,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
