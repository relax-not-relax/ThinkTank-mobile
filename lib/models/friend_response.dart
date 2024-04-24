import 'package:thinktank_mobile/models/friendship.dart';

class FriendResponse {
  final List<Friendship> friends;
  final int totalNumberOfRecords;

  const FriendResponse({
    required this.friends,
    required this.totalNumberOfRecords,
  });
}
