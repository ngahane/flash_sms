class MessageData {
  String senderName, senderNumber, message, time, status, avatar, type, timestamp, thread_id;

//  final String avatar;
  MessageData(this.senderName, this.senderNumber, this.message, this.time,
      {this.status = "", this.avatar = ""});

  MessageData.fromMap(value)
      : assert(value != null, "the map must not be null") {
    this.senderName = value["name"];
    this.senderNumber = value["phone"];
    this.message = value["msg"];
    this.thread_id = value["thread_id"];
    final d = DateTime.now();
    this.timestamp = value["timestamp"] ?? d.millisecondsSinceEpoch.toString();
    this.time = value["time"] ?? "${d.day}/${d.month} ${d.hour}:${d.minute}";
//    this._id = value["_id"];
    this.type = value["type"] ?? "1";
  }
}
