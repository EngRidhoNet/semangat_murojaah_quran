import 'dart:convert';

import 'package:my_quran/models/surah.dart';
import 'package:my_quran/models/surah_detail.dart';
import 'package:my_quran/services/api_service.dart';

class QuranRepository {
  final ApiService _apiService;

  QuranRepository(this._apiService);

  // Fetch all Surah
  Future<List<Surah>> getAllSurah() async {
    try {
      final response = await _apiService.get('surat');
      final data = json.decode(response.body) as List;

      return data.map((surah) => Surah.fromJson(surah)).toList();
    } catch (e) {
      throw Exception('Failed to load surahs: $e');
    }
  }

  // Fetch details of a specific Surah
  Future<SurahDetail> getSurahDetail(int nomor) async {
    try {
      final response = await _apiService.get('surat/$nomor');
      final data = json.decode(response.body);

      return SurahDetail.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load surah detail: $e');
    }
  }
}
