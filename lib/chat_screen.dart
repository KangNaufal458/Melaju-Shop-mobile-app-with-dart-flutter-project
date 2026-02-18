import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String carName;

  const ChatScreen({super.key, required this.carName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Data Dummy Chat (Disesuaikan dengan gambar)
  final List<Map<String, dynamic>> _messages = [
    {
      "isMe": false,
      "text": "Hi there!! i booked a repair for my toyota prius. i'm currently at walls street waiting for you to come pick up the car",
      "time": "yesterday 01.00 PM",
      "status": "Seen"
    },
    {
      "isMe": true,
      "text": "Okay i'm on my way right now!!! give me 10mins",
      "time": "Today 12.00 PM",
      "status": "Seen"
    },
    {
      "isMe": true,
      "text": "Hi where are you",
      "time": "Today 12.01 PM",
      "status": "Seen"
    },
    {
      "isMe": false,
      "text": "I'm on a roof wearing a white top and blue jean",
      "time": "Today 01.00 PM",
      "status": "Seen"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulasi pesan masuk otomatis biar seru
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "isMe": true,
            "text": "Halo Mulyono, unit ${widget.carName} apakah ready?",
            "time": "Today 12.05 PM",
            "status": "Sent"
          });
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "isMe": true,
        "text": _controller.text,
        "time": "Today 12.10 PM",
        "status": "Sent"
      });
    });
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C4C4C), // Warna Abu Gelap Background
      
      // 1. APP BAR (Hitam Elegan)
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Hitam
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Foto Profil Mulyono
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profil.png'), 
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green, // Indikator Online
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Mulyono", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Online", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // 2. ISI CHAT
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;

                // Tampilan Tanggal "Today" (Opsional, logika simpel)
                bool showDate = index == 1; 

                return Column(
                  children: [
                    if (showDate)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Today",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Avatar Sales (Kiri)
                          if (!isMe) 
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage: AssetImage('assets/images/profil.png'),
                            ),
                          if (!isMe) const SizedBox(width: 10),

                          // Bubble Chat
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black, // Bubble Hitam Pekat
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                      bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                                      bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    msg['text'],
                                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Waktu & Status Seen
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isMe) ...[
                                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 14),
                                      const SizedBox(width: 4),
                                      const Text("Seen", style: TextStyle(color: Colors.white70, fontSize: 10)),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      msg['time'],
                                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                                    ),
                                    if (!isMe) ...[
                                      const SizedBox(width: 8),
                                      const Text("Seen", style: TextStyle(color: Colors.white70, fontSize: 10)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 14),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (isMe) const SizedBox(width: 10),
                          // Avatar User (Kanan)
                          if (isMe)
                            const CircleAvatar(
                              radius: 16,
                              // Ganti pakai gambar user sendiri nanti
                              backgroundColor: Colors.blueGrey, 
                              child: Icon(Icons.person, color: Colors.white, size: 20), 
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. INPUT TEXT MODERN (Melengkung)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E), // Background bawah hitam
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                // Kolom Ketik Putih Panjang
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: "Type Messages...............",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // Tombol Kirim di DALAM Putih
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E1E1E), // Hitam
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Tombol Mic Terpisah
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C), // Abu gelap
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}