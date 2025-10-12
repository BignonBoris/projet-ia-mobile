String formatMessage(msg) {
  String prefixe = "";
  if (msg['role'] == "user") prefixe = "Vous";
  if (msg['role'] == "assistant") prefixe = "IA";
  return "**$prefixe :** " + msg['content'];
}
