import "package:projet_ia/classes/quiz.dart";

final List<Question> quizQuestions = [
  Question(
    text: "Quand ton/ta partenaire pense à toi, tu préfères qu'il/elle...",
    answers: [
      Answer(text: "T’envoie un message romantique ❤️", category: "mots"),
      Answer(text: "Te prenne dans ses bras 🤗", category: "gestes"),
      Answer(text: "T’offre un petit cadeau 🎁", category: "cadeaux"),
      Answer(text: "Passe du temps rien qu’avec toi 🕰️", category: "temps"),
      Answer(text: "T’aide à faire quelque chose 🛠️", category: "services"),
    ],
  ),
  Question(
    text: "Le geste qui te touche le plus est...",
    answers: [
      Answer(text: "Un 'je t’aime' sincère 💌", category: "mots"),
      Answer(text: "Une caresse ou un baiser 😘", category: "gestes"),
      Answer(text: "Une surprise inattendue 🎉", category: "cadeaux"),
      Answer(text: "Un moment juste à deux 🌅", category: "temps"),
      Answer(text: "Un coup de main sans demander 🙌", category: "services"),
    ],
  ),
  Question(
    text: "En période difficile, ce qui te réconforte le plus est...",
    answers: [
      Answer(text: "Un mot d’encouragement 📝", category: "mots"),
      Answer(text: "Un câlin rassurant 🫂", category: "gestes"),
      Answer(
        text: "Un petit présent pour te faire sourire 🎀",
        category: "cadeaux",
      ),
      Answer(text: "Une sortie ensemble 🎡", category: "temps"),
      Answer(
        text: "Quelqu’un qui règle un souci pour toi 🔧",
        category: "services",
      ),
    ],
  ),
  Question(
    text: "Tu te sens aimé(e) quand ton partenaire...",
    answers: [
      Answer(text: "Exprime ses sentiments 😍", category: "mots"),
      Answer(text: "Te touche tendrement ✋", category: "gestes"),
      Answer(text: "T’offre quelque chose de spécial 💎", category: "cadeaux"),
      Answer(text: "Passe du temps de qualité avec toi 🎯", category: "temps"),
      Answer(text: "T'aide sans que tu demandes 🤝", category: "services"),
    ],
  ),
  Question(
    text: "Pour ton anniversaire, tu préfères...",
    answers: [
      Answer(text: "Une lettre d’amour ❤️", category: "mots"),
      Answer(text: "Un massage relaxant 💆", category: "gestes"),
      Answer(text: "Un bijou ou un objet spécial 💍", category: "cadeaux"),
      Answer(text: "Un week-end en amoureux 🏖️", category: "temps"),
      Answer(text: "Que tout soit organisé pour toi 🎯", category: "services"),
    ],
  ),
];
