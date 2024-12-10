import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookbinding/views/components/AppBar.dart';
import 'package:bookbinding/views/components/SentenceScramble.dart';

class QuizPopup extends StatefulWidget {
  final String pageContent;
  final List<String> words;
  final String sourceLanguage;
  final String targetLanguage;
  final VoidCallback onQuizComplete;

  const QuizPopup({
    Key? key,
    required this.pageContent,
    required this.words,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onQuizComplete,
  }) : super(key: key);

  @override
  _QuizPopupState createState() => _QuizPopupState();
}

class _QuizPopupState extends State<QuizPopup> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  late List<Map<String, dynamic>> _questions = [];
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _questionsFuture = generateQuestions(
        widget.words, widget.sourceLanguage, widget.targetLanguage);
  }

  Future<String> fetchQuizFromChatGPT(
      List<String> words, String sourceLanguage, String targetLanguage) async {
    var apiKey = dotenv.env['OPENAI_API_KEY']!;
    var model = 'gpt-3.5-turbo';
    var example = """
{
  "words": [
    {
      "word": "ifrån",
      "sentence": "Hon flyttade ifrån Stockholm för att börja ett nytt jobb i Malmö.",
      "translation": "She moved away from Stockholm to start a new job in Malmö."
    },
  ]
}
""";
    var prompt = """
You are a language tutor teaching an $targetLanguage student $sourceLanguage. You are focused on helping learners understand vocabulary through context. When provided with a list of vocabulary words, your task is to create one unique, well-formed sentence for each word. These sentences should clearly demonstrate the meaning and usage of the word in context. 
Ensure that each sentence:

Is grammatically correct.
Reflects the common or natural usage of the word.
Avoids repetitive sentence structures across different words.
Matches the general difficulty level of an intermediate language learner, unless otherwise specified.
Do not use the vocabulary words in overly complex or obscure contexts; the goal is for the learner to easily grasp the meaning of the word through your sentence.
Is a simple sentence structure that is easy for a language learner to understand.
Doesn't exceed 10 words.

Ensure that the word and sentence are the language you are teaching, and the translation is in the language of the student.

Return the the word, sentence, and translation in json format
Example:
$example
""";
    var continuation = 'The list of words is "${words.join('", "')}".';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': prompt},
          {'role': 'user', 'content': continuation}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.body.codeUnits));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch quiz from ChatGPT');
    }
  }

  Future<List<Map<String, dynamic>>> generateQuestions(
      List<String> words, String sourceLanguage, String targetLanguage) async {
    var response =
        await fetchQuizFromChatGPT(words, sourceLanguage, targetLanguage);
    for (var entry in jsonDecode(response)['words']) {
      _questions.add({
        'question': '${entry["word"]}',
        'options': [
          '${entry["translation"]}',
          '${entry["sentence"]}',
          'Option C',
          'Option D',
        ],
        'correctAnswer': '${entry["translation"]}',
      });
    }
    return _questions;
  }

  void answerQuestion(String answer) {
    if (currentQuestionIndex < _questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      widget.onQuizComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available'));
          } else {
            return Scaffold(
                appBar: const MainAppBar(title: 'Quiz', homeButton: false),
                body: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _questionsFuture,
                    builder: (context, snapshot) {
                      var question = _questions[currentQuestionIndex];
                      return Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SentenceScramble(
                                originalSentence: question['options'][1],
                                translatedSentence: question['options'][0],
                                onQuestionFinish: answerQuestion),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      onPressed: widget.onQuizComplete,
                                      child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Continue Reading')),
                                    )))
                          ],
                        ),
                      );
                    }));
          }
        });
  }
}
