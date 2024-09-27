import 'package:flutter/material.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:langread/views/components/VocabularyList.dart';
import 'package:provider/provider.dart';

class VocabListView extends StatelessWidget {
  const VocabListView({super.key});

  @override
  Widget build(BuildContext context) {
    return VocabularyList();
  }
}
