import 'package:technik/widgets/friends_list.dart';

// Sample friends data provider
class FriendsData {
  static List<Friend> getSampleFriends() {
    return [
      Friend(
        name: "Alex Smith",
        status: "Premium member",
      ),
      Friend(
        name: "Emma Johnson",
        status: "Financial advisor",
      ),
      Friend(
        name: "Michael Brown",
        status: "New user",
      ),
      Friend(
        name: "Sophia Williams",
        status: "Premium member",
      ),
      Friend(
        name: "James Davis",
        status: "Investment specialist",
      ),
    ];
  }
} 