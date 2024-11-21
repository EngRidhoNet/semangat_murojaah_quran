import 'package:my_quran/models/surah.dart';
import 'package:my_quran/models/ayat.dart';

class SurahDetail extends Surah {
  final List<Ayat> ayat;
  final Surah? suratSelanjutnya;
  final Surah? suratSebelumnya;

  SurahDetail({
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audio,
    required this.ayat,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['nama_latin'], // Menggunakan key `nama_latin`
      jumlahAyat: json['jumlah_ayat'], // Menggunakan key `jumlah_ayat`
      tempatTurun: json['tempat_turun'], // Menggunakan key `tempat_turun`
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audio: json['audio'], // Audio dalam string langsung
      ayat: (json['ayat'] as List).map((e) => Ayat.fromJson(e)).toList(),
      suratSelanjutnya: json['surat_selanjutnya'] != false
          ? Surah.fromJson(json['surat_selanjutnya'])
          : null,
      suratSebelumnya: json['surat_sebelumnya'] != false
          ? Surah.fromJson(json['surat_sebelumnya'])
          : null,
    );
  }
}
