// lib/services/prayer_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerTimesResponse {
  final Map<String, String> timings;
  final DateTime date;

  PrayerTimesResponse({required this.timings, required this.date});
}

class PrayerService {
  static const String baseUrl = 'http://api.aladhan.com/v1';

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<PrayerTimesResponse> getPrayerTimes() async {
    try {
      final position = await _getCurrentLocation();
      final date = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);

      final response = await http.get(Uri.parse(
          '$baseUrl/timings/$formattedDate?latitude=${position.latitude}&longitude=${position.longitude}&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = Map<String, String>.from(data['data']['timings']);

        // Convert 24-hour format to 12-hour format
        timings.forEach((key, value) {
          final time = DateFormat('HH:mm').parse(value);
          timings[key] = DateFormat('hh:mm a').format(time);
        });

        return PrayerTimesResponse(
          timings: timings,
          date: date,
        );
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Error getting prayer times: $e');
    }
  }

  String getNextPrayer(Map<String, String> timings) {
    final now = DateTime.now();
    final prayers = {
      'Fajr': timings['Fajr'],
      'Dhuhr': timings['Dhuhr'],
      'Asr': timings['Asr'],
      'Maghrib': timings['Maghrib'],
      'Isha': timings['Isha'],
    };

    String nextPrayer = '';
    DateTime? nextTime;

    prayers.forEach((prayer, timeStr) {
      if (timeStr != null) {
        final time = DateFormat('hh:mm a').parse(timeStr);
        final prayerTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        if (prayerTime.isAfter(now) &&
            (nextTime == null || prayerTime.isBefore(nextTime!))) {
          nextPrayer = prayer;
          nextTime = prayerTime;
        }
      }
    });

    if (nextPrayer.isEmpty) {
      nextPrayer = 'Fajr'; // If no next prayer today, next is Fajr tomorrow
    }

    return nextPrayer;
  }

  String getRemainingTime(String prayerTime) {
    final now = DateTime.now();
    final time = DateFormat('hh:mm a').parse(prayerTime);
    final prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final difference = prayerDateTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    return '$hours jam ${minutes.abs()} menit';
  }
}
