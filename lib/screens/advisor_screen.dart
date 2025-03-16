import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class AdvisorScreen extends StatefulWidget {
  @override
  _AdvisorScreenState createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  // Store the last response for debugging
  Map<String, dynamic>? _lastResponse;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    // Add user message to chat
    setState(() {
      _messages.add(Message(text: _controller.text, isUser: true));
      _isLoading = true;
    });

    String userMessage = _controller.text;
    _controller.clear();

    try {
      // Make API call
      final response = await http.post(
        Uri.parse('https://api.langflow.astra.datastax.com/lf/cbf3452a-8165-4c75-96e1-e118556e70bb/api/v1/run/d3ad7f35-ebbb-4f88-885a-cb9bb578501b?stream=false'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['ASTRA_API_TOKEN']}',
        },
        body: jsonEncode({
          'input_value': userMessage,
          'output_type': 'chat',
          'input_type': 'chat',
          'tweaks': {
            'Agent-hg6SP': {},
            'ChatInput-VPdV2': {},
            'ChatOutput-f2iAW': {},
            'CalculatorComponent-9jYQo': {},
            'DuckDuckGoSearchComponent-lAucx': {}
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Store the last response for debugging
        _lastResponse = responseData is Map<String, dynamic> ? responseData : null;
        
        // Extract only the useful text from the complex nested structure
        String botMessage = "";
        
        try {
          // Print response structure for debugging
          print("API Response received");
          
          // Navigate through the nested structure to find the actual message content
          if (responseData is Map) {
            if (responseData.containsKey('outputs') && 
                responseData['outputs'] is List && 
                responseData['outputs'].isNotEmpty) {
              
              var firstOutput = responseData['outputs'][0];
              
              // Try to extract from the messages array first (most reliable path)
              if (firstOutput.containsKey('outputs') && 
                  firstOutput['outputs'] is List && 
                  firstOutput['outputs'].isNotEmpty) {
                
                var innerOutput = firstOutput['outputs'][0];
                
                if (innerOutput.containsKey('messages') && 
                    innerOutput['messages'] is List && 
                    innerOutput['messages'].isNotEmpty) {
                  
                  var message = innerOutput['messages'][0];
                  if (message.containsKey('message')) {
                    botMessage = message['message'].toString();
                  }
                }
                // If messages path doesn't work, try the results path
                else if (innerOutput.containsKey('results') && 
                         innerOutput['results'].containsKey('message') &&
                         innerOutput['results']['message'].containsKey('data') &&
                         innerOutput['results']['message']['data'].containsKey('text')) {
                  
                  botMessage = innerOutput['results']['message']['data']['text'].toString();
                }
                // Try artifacts path as fallback
                else if (innerOutput.containsKey('artifacts') && 
                         innerOutput['artifacts'].containsKey('message')) {
                  
                  botMessage = innerOutput['artifacts']['message'].toString();
                }
              }
            }
          }
          
          // If we couldn't extract the message through the known paths
          if (botMessage.isEmpty) {
            print("Could not extract message from standard paths, using fallback");
            botMessage = "Sorry, I couldn't process the response correctly.";
          }
        } catch (e) {
          print("Error extracting message: $e");
          botMessage = "Error extracting response: $e";
        }
        
        // Add exactly one message to the chat
        setState(() {
          _messages.add(Message(text: botMessage, isUser: false));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(Message(text: "Error: Couldn't get a response.", isUser: false));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(text: "Error: $e", isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      appBar: AppBar(
        backgroundColor: Color(0xFF1c1c1e),
        title: Text("Advisor", style: TextStyle(color: Colors.white)),
        actions: [
          // Debug button to show response structure
          IconButton(
            icon: Icon(Icons.bug_report, color: Colors.white70),
            onPressed: () {
              if (_lastResponse != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Last API Response"),
                    content: SingleChildScrollView(
                      child: Text(
                        const JsonEncoder.withIndent('  ').convert(_lastResponse),
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Close"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No response data available")),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      "Ask the advisor anything",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageRow(message);
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageRow(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(isUser: false),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: message.isUser ? 60 : 8,
                right: message.isUser ? 8 : 60,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[700] : Color(0xFF3a3a3c),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          if (message.isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: isUser ? Colors.blue[800] : Colors.green,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1c1c1e),
        border: Border(top: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask a question...',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Color(0xFF2c2c2e),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF50c878),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
