import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:langread/views/components/SmoothPageView.dart';
import '../providers/SettingsProvider.dart';


class ReadingView extends StatelessWidget {
final book;

ReadingView({super.key, this.book});

final Map<int, List<String>> samplePages = {
  0: [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
    "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  ],
  1: [
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
    "Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
    "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.",
    "Sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  ],
  2: [
    "Now I’m going to tell you about my brother. My brother, Jonathan Lionheart, is the person I want to tell you about. I think it’s almost like a saga, and just a little like a ghost story, and yet every word is true, though Jonathan and I are probably the only people who know that.",
    "Jonathan’s name wasn’t Lionheart from the start. His last name was Lion, just like Mother’s and mine. Jonathan Lion was his name. My name is Karl Lion and Mother’s is Sigrid Lion. Father was Axel Lion, but he went to sea and we never heard from him since."
  ],
  3: [
    "Nu ska jag berätta om min bror. Min bror, Jonatan Lejonhjärta, honom vill jag berätta om. Det är nästan som en saga tycker jag, och lite, lite som en spökhistoria också, och ändå är alltihop sant. Fast det vet nog ingen mer än jag och Jonatan.",
    "Jonatan hette inte Lejonhjärta från början. Han hette Lejon i efternamn precis som mama och jag. Jonatan Lejon hette han. Jag heter Karl Lejon och mamma Sigrid Lejon. Pappa hette Axel Lejon, fast han stack ifrån oss när jag bara var två år, och gick till sjöss, och sen har vi inte hört av honom.",
    "Men vad jag nu skulle tala om, det var hur det gick till att min bror Jonatan blev Jonatan Lejonhjärta. Och allt det underliga som hände sen.",
    "Jonatan visste att jag snart skulle dö. Jag tror att alla visste det utom mig. De visste det i skolan med, för jag låg ju bara hemma och hostade och var sjuk jämt, sista halvåret har jag inte kunnat gå i skolan alls. Alla tanderna som mamma syr klänningar åt visste det också, och det var en av dom som pratade med mamma on det så att jag råkade höra det, fast det inte var meningen. De trodde att jag sov. Men jag låg bara och blundade. Och det fortsatte jag med, för jag ville inte visa att jag hade hört det där hemska -- att jag snart skulle dö.",
  ]
};

@override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
        builder: (context, settings, child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, style: TextStyle(fontSize: settings.superfontSize)),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            }
          )
        ],
      ),
      body: SmoothPageView(pages: samplePages[book.id]!),
    );
        });
  }
}