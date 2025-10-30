import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_data.dart';

class GameService {
  static Future<GameData> loadGameData() async {
    final String jsonString = await rootBundle.loadString('assets/bebedeira.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return GameData.fromJson(jsonData);
  }
}
