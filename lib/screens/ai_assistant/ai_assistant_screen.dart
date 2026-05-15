/// ================================================
/// File    : ai_assistant_screen.dart
/// Module  : AI Assistant
/// Desc    : Intelligence chatbot interface
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/drone_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/threat_provider.dart';
import '../../providers/sales_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Welcome to AMOPS AI. How can I assist with military operations today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _handleSend() {
    if (_controller.text.isEmpty) return;
    
    final userText = _controller.text;
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true, timestamp: DateTime.now()));
      _controller.clear();
    });

    _generateAIResponse(userText);
  }

  Future<void> _generateAIResponse(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    String response = "I'm analyzing the real-time data from Firestore. Please wait...";
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains("battery")) {
      final droneState = ref.read(droneProvider);
      final lowest = droneState.drones.reduce((a, b) => a.battery < b.battery ? a : b);
      response = "The drone with the lowest battery is ${lowest.id} at ${lowest.battery}%. It is currently in ${lowest.status} status.";
    } else if (lowerQuery.contains("maintenance") || lowerQuery.contains("tank")) {
      final vehicleState = ref.read(vehicleProvider);
      final atRisk = vehicleState.vehicles.where((v) => v.engineHours > 500).toList();
      response = atRisk.isEmpty 
          ? "All tanks are currently within safe operating hours." 
          : "Attention: ${atRisk.length} vehicles need immediate maintenance, including ${atRisk.first.id}.";
    } else if (lowerQuery.contains("threat")) {
      final threatState = ref.read(threatProvider);
      response = "Currently monitoring ${threatState.threats.length} threats. Highest activity detected in Sector Alpha.";
    } else if (lowerQuery.contains("deal") || lowerQuery.contains("sales")) {
      final salesState = ref.read(salesProvider);
      final top = salesState.deals.reduce((a, b) => a.winProbability > b.winProbability ? a : b);
      response = "Our strongest deal is with ${top.country} for ${top.product} with a ${top.winProbability}% win probability.";
    } else {
      response = "AMOPS AI: Analyzing operational data... Command: All systems nominal across HIT/MHIL manufacturing units.";
    }

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy_outlined),
            SizedBox(width: 12),
            Text("AMOPS AI Assistant"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildQuickActions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: msg.isUser 
              ? null 
              : const Border(left: BorderSide(color: AppColors.primary, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.isUser ? "Command" : "AI Assistant",
              style: TextStyle(
                color: msg.isUser ? Colors.black87 : AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg.text,
              style: TextStyle(color: msg.isUser ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final questions = [
      "Which drone has lowest battery?",
      "Which tank needs maintenance?",
      "Current threat level?",
      "Best sales deal?"
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: questions.map((q) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(q, style: const TextStyle(fontSize: 10)),
            backgroundColor: AppColors.card,
            onPressed: () {
              _controller.text = q;
              _handleSend();
            },
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.card,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type operational query...",
                border: InputBorder.none,
                filled: false,
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
