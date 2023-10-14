class Request {
  String senderName;
  String senderUid;
  String ownerName;
  String ownerUid;
  String itemId;
  String itemName;
  String status = "Pending";
  String requestId;
  Request({
    required this.ownerName,
    required this.ownerUid,
    required this.itemId,
    required this.itemName,
    required this.requestId,
    required this.senderName,
    required this.senderUid,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerName': ownerName,
      'ownerUid': ownerUid,
      'itemId': itemId,
      'itemName': itemName,
      'requestId': requestId,
      'senderName': senderName,
      'senderUid': senderUid,
      'status': status,
    };
  }
}
