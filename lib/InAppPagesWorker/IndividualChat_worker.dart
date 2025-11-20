import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndividualChatworker extends StatefulWidget {
  final String name;
  final String chatid;
  const IndividualChatworker(
      {super.key, required this.chatid, required this.name});

  @override
  State<IndividualChatworker> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChatworker> {
  final String myUid = 'my_uid_123'; // sample uid
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {
      "sender": "my_uid_123",
      "text": "Hey, are you coming today?",
      "time": "2025-03-28T14:32:00Z"
    },
    {
      "sender": "worker_1",
      "text": "Yes, I'll be there by 5 PM.",
      "time": "2025-03-28T14:35:00Z"
    },
    {
      "sender": "my_uid_123",
      "text": "Okay, bring the materials too.",
      "time": "2025-03-27T10:00:00Z"
    },
    {
      "sender": "worker_1",
      "text": "Sure, noted!",
      "time": "2025-03-27T10:10:00Z"
    },
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        "sender": myUid,
        "text": _controller.text.trim(),
        "time": DateTime.now().toUtc().toIso8601String()
      });
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today";
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> dateLabels = {};
    return Scaffold(
      backgroundColor: AppColors.navbarcolorbg,
      appBar: AppBar(
        backgroundColor: AppColors.navbarcolorbg,
        title: Text(
          widget.name,
          style: TextStyle(color: AppColors.darkviolet),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                DateTime msgDate =
                    DateTime.parse(messages[index]['time']).toLocal();
                String dateLabel = getDateLabel(msgDate);
                bool showDate = !dateLabels.containsKey(dateLabel);
                dateLabels[dateLabel] = dateLabel;

                bool isMe = messages[index]['sender'] == myUid;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDate)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(dateLabel,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.darkviolet)),
                        ),
                      ),
                    Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.midviolet : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(messages[index]['text'],
                                style: TextStyle(
                                    color: isMe
                                        ? Colors.white
                                        : AppColors.darkviolet)),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.Hm().format(msgDate),
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      isMe ? Colors.white70 : Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: AppColors.midviolet,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
