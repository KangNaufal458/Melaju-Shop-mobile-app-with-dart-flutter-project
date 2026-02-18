import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentCard {
  final String id;
  final String cardNumber;
  final String ccv;
  final String expiry;
  final String cardholderName;

  PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.ccv,
    required this.expiry,
    required this.cardholderName,
  });

  String get maskedCard => '•••• ${cardNumber.substring(cardNumber.length - 4)}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'cardNumber': cardNumber,
    'ccv': ccv,
    'expiry': expiry,
    'cardholderName': cardholderName,
  };

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
    id: json['id'],
    cardNumber: json['cardNumber'],
    ccv: json['ccv'],
    expiry: json['expiry'],
    cardholderName: json['cardholderName'],
  );
}

class PaymentService {
  static const String _keyCards = 'user_payment_cards';
  static const String _keyPayPal = 'user_paypal';

  // ✅ Simpan kartu kredit baru
  static Future<bool> addCard({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cards = await getCards();
      
      final newCard = PaymentCard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardNumber: cardNumber,
        ccv: ccv,
        expiry: expiry,
        cardholderName: cardholderName,
      );
      
      cards.add(newCard);
      
      final jsonList = cards.map((c) => jsonEncode(c.toJson())).toList();
      await prefs.setStringList(_keyCards, jsonList);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Ambil semua kartu
  static Future<List<PaymentCard>> getCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_keyCards) ?? [];
      
      return jsonList
          .map((json) => PaymentCard.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ✅ Hapus kartu
  static Future<bool> deleteCard(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var cards = await getCards();
      
      cards.removeWhere((c) => c.id == id);
      
      final jsonList = cards.map((c) => jsonEncode(c.toJson())).toList();
      await prefs.setStringList(_keyCards, jsonList);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Simpan PayPal email
  static Future<bool> savePayPalEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPayPal, email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Ambil PayPal email
  static Future<String?> getPayPalEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyPayPal);
    } catch (e) {
      return null;
    }
  }
}
