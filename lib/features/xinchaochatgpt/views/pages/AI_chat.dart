import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_bacsi_nguyentrongthuy/features/xinchaochatgpt/views/widgets/ai_chat_appbar.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => AiChatState();
}

class AiChatState extends State<AiChat> {
  final _openAI = OpenAI.instance.build(
    token: dotenv.env['OPENAI_API_KEY']!,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 20), // Increased timeout
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Duc', lastName: 'Dat');
  final ChatUser _gptChatUser = ChatUser(
      id: '2',
      firstName: 'Chuột',
      lastName: 'Lang Nước',
      profileImage: 'assets/images/capybara.png');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AiChatAppbar(),
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    try {
      setState(() {
        _messages.insert(0, m);
        _typingUsers.add(_gptChatUser);
      });

      // Mapping ChatMessage to Messages with serialization
      List<Map<String, dynamic>> _messagesHistory = _messages.reversed.map((m) {
        if (m.user == _currentUser) {
          return {'role': 'user', 'content': m.text}; // Convert Role to string
        } else {
          return {
            'role': 'assistant',
            'content': m.text
          }; // Convert Role to string
        }
      }).toList();

      final request = ChatCompleteText(
        model: Gpt4ChatModel(),
        messages: _messagesHistory,
        maxToken: 200,
      );

      final response = await _openAI.onChatCompletion(request: request);

      if (response != null) {
        for (var element in response.choices) {
          if (element.message != null) {
            setState(() {
              _messages.insert(
                0,
                ChatMessage(
                  user: _gptChatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content,
                ),
              );
            });
          }
        }
      }
      // setState(() {
      //   _typingUsers.remove(_gptChatUser);
    } catch (e) {
      debugPrint('Error: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request timed out. Please try again.')),
      );
    }
  }
}
