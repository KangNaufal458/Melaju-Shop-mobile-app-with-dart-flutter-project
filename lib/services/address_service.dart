import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Address {
  final String id;
  final String streetAddress;
  final String city;

  Address({
    required this.id,
    required this.streetAddress,
    required this.city,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'streetAddress': streetAddress,
    'city': city,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    streetAddress: json['streetAddress'],
    city: json['city'],
  );
}

class AddressService {
  static const String _keyAddresses = 'user_addresses';

  // ✅ Simpan address baru
  static Future<bool> addAddress({
    required String streetAddress,
    required String city,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addresses = await getAddresses();
      
      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        streetAddress: streetAddress,
        city: city,
      );
      
      addresses.add(newAddress);
      
      final jsonList = addresses.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList(_keyAddresses, jsonList);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Ambil semua address
  static Future<List<Address>> getAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_keyAddresses) ?? [];
      
      return jsonList
          .map((json) => Address.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ✅ Update address
  static Future<bool> updateAddress({
    required String id,
    required String streetAddress,
    required String city,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var addresses = await getAddresses();
      
      final index = addresses.indexWhere((a) => a.id == id);
      if (index != -1) {
        addresses[index] = Address(
          id: id,
          streetAddress: streetAddress,
          city: city,
        );
        
        final jsonList = addresses.map((a) => jsonEncode(a.toJson())).toList();
        await prefs.setStringList(_keyAddresses, jsonList);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // ✅ Hapus address
  static Future<bool> deleteAddress(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var addresses = await getAddresses();
      
      addresses.removeWhere((a) => a.id == id);
      
      final jsonList = addresses.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList(_keyAddresses, jsonList);
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
