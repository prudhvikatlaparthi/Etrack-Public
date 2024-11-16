

class OLocation {
  int? id;
  String message;
  String timestamp;
  String synced;

  OLocation({this.id, required this.message, required this.timestamp, required this.synced});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp,
      'synced': synced,
    };
  }

  factory OLocation.fromMap(Map<String, dynamic> map) {
    return OLocation(
      id: map['id'],
      message: map['message'],
      timestamp: map['timestamp'],
      synced: map['synced'],
    );
  }
}