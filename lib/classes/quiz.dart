class Question {
  final String text;
  final List<Answer> answers;
  Question({required this.text, required this.answers});
}

class Answer {
  final String text;
  final String category; // mots, gestes, cadeaux, temps, services
  Answer({required this.text, required this.category});
}

String getQuizResult(List<String> selectedCategories) {
  final counts = <String, int>{};

  for (var cat in selectedCategories) {
    counts[cat] = (counts[cat] ?? 0) + 1;
  }

  // Trouver la catégorie la plus choisie
  final sorted =
      counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final topCategory = sorted.first.key;

  switch (topCategory) {
    case "mots":
      return "💌 Ton langage de l’amour : Les mots doux.\nTu es sensible aux paroles affectueuses et aux déclarations sincères.";
    case "gestes":
      return "🤗 Ton langage de l’amour : Le contact physique.\nTu exprimes et ressens l’amour à travers le toucher.";
    case "cadeaux":
      return "🎁 Ton langage de l’amour : Les cadeaux.\nPour toi, chaque cadeau est une preuve concrète d’amour.";
    case "temps":
      return "🕰️ Ton langage de l’amour : Le temps de qualité.\nTu apprécies les moments partagés, sans distractions.";
    case "services":
      return "🛠️ Ton langage de l’amour : Les services rendus.\nTu te sens aimé(e) quand on agit concrètement pour toi.";
    default:
      return "💖 Tu es unique et ton amour s’exprime de plusieurs manières.";
  }
}
