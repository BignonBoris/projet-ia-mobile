class NotificationModel {
  String? token;
  final String? title;
  final String? body;

  NotificationModel({this.token, this.title, this.body});

  NotificationModel.empty() : this.token = "", this.title = "", this.body = "";

  // Convertir un Map JSON → NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      token: json['token'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Add the toJson() method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "token": token ?? "",
      'title': title ?? "",
      'body': body ?? "",
    };

    return data;
  }
}
