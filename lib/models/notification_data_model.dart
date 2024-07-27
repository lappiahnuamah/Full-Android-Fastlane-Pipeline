class NotificationDataModel {
  dynamic type;
  dynamic initiatorId;
  dynamic receiverId;
  dynamic model;
  dynamic comment;
  dynamic data;
  dynamic isNotificationOff;
  dynamic isFollower;

  NotificationDataModel(
      {this.type,
      this.initiatorId,
      this.receiverId,
      this.model,
      this.comment,
      this.data,
      this.isNotificationOff,
      this.isFollower});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    initiatorId = json['initiatorId'];
    receiverId = json['receiverId'];
    model = json['model'];
    data = json['data'];
    comment = json['comment'];
    isNotificationOff = json['is_notification_off'];
    isFollower = json['is_follower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['initiatorId'] = initiatorId;
    data['receiverId'] = receiverId;
    if (model != null) {
      data['model'] = model!.toJson();
    }
    data['is_notification_off'] = isNotificationOff;
    data['is_follower'] = isFollower;
    return data;
  }
}
