import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId;
  String? receiverId;
  String? content;
  String? sentAt;

  Message(
      {this.senderId,
      this.receiverId,
      this.content,
      this.sentAt});

  Message.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    senderId = map['senderId'];
    receiverId = map['receiverId'];
    content = map['content'];
    sentAt = map['sentAt'];
  }

  Message.fromDocumentSnapshot(DocumentSnapshot? doc) {
    if (doc == null) {
      return;
    }

    var map = doc.data() as Map<String, dynamic>;

    Message.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "sentAt": sentAt,
    };
  }
}
