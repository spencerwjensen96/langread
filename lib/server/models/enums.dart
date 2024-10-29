// ignore_for_file: constant_identifier_names

enum Language {
  English('en', 'english'),
  Spanish('es', 'español'),
  French('fr', 'français'),
  German('de', 'deutsch'),
  Chinese('zh', '中文'),
  Japanese('ja', '日本語'),
  Korean('ko', '한국어'),
  Russian('ru', 'русский'),
  Portuguese('pt', 'português'),
  Italian('it', 'italiano'),
  Swedish('sv', 'svenska');

  const Language(this.code, this.displayName);
  final String code;
  final String displayName;
}

enum BookGenre {
  Fiction('fiction'),
  NonFiction('non fiction'),
  Mystery('mystery'),
  Fantasy('fantasy'),
  ScienceFiction('science fiction'),
  Biography('biography'),
  Romance('romance'),
  Thriller('thriller'),
  Historical('historical'),
  SelfHelp('self help');

  const BookGenre(this.displayName);
  final String displayName;
}