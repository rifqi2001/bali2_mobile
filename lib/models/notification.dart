class NotificationModel {
  final int id;
  final String title;
  final String message;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
    );
  }
}
