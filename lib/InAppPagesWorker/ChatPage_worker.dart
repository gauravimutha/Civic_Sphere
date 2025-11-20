import 'package:civicsphere/InAppPagesCustomer/IndividualChat.dart';
import 'package:civicsphere/InAppPagesWorker/IndividualChat_worker.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';

class Chatpageworker extends StatefulWidget {
  const Chatpageworker({super.key});

  @override
  State<Chatpageworker> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpageworker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navbarcolorbg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: Image.asset('assets/teamwork-1.png', scale: 0.8),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkviolet,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Static add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.midviolet,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Messages',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkviolet),
            ),
            SizedBox(height: 20),
            chatdesc(),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> chatData = [
    {
      "chatId": "C001",
      "name": "John Doe",
      "job": "Electrician",
      "lastChat": "Hey, how are you?",
      "time": "2025-03-28T14:32:00Z"
    },
    {
      "chatId": "C002",
      "name": "Jane Smith",
      "job": "Plumber",
      "lastChat": "Let's catch up tomorrow!",
      "time": "2025-03-28T13:15:00Z"
    },
    {
      "chatId": "C003",
      "name": "Mike Ross",
      "job": "Carpenter",
      "lastChat": "Sent you the documents.",
      "time": "2025-03-28T11:47:00Z"
    },
    {
      "chatId": "C004",
      "name": "Sarah Connor",
      "job": "Painter",
      "lastChat": "See you at the meeting.",
      "time": "2025-03-28T10:05:00Z"
    },
    {
      "chatId": "C005",
      "name": "Alex Morgan",
      "job": "Mason",
      "lastChat": "Good night!",
      "time": "2025-03-27T23:58:00Z"
    }
  ];

  Widget chatdesc() {
    Map<String, String> roleIcons = {
      "Electrician": "⚡",
      "Plumber": "🛠️",
      "Carpenter": "🪚",
      "Painter": "🎨",
      "Mason": "🧱",
    };
    return Column(
      children: chatData.map((chat) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => IndividualChatworker(
                            chatid: chat['chatId'],
                            name: chat['name'],
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.nonselected,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.midviolet,
                    child: Text(
                      roleIcons[chat["job"]] ?? "👷",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat["name"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(chat["lastChat"],
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  Spacer(),
                  Text(
                    chat["time"].substring(11, 16),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
