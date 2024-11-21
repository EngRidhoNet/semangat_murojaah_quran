class Ayat {
  final int id;
  final int surah;
  final int nomor;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  Ayat({
    required this.id,
    required this.surah,
    required this.nomor,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      id: json['id'],
      surah: json['surah'],
      nomor: json['nomor'],
      teksArab: json['ar'], // Menggunakan key `ar` untuk teks Arab
      teksLatin: json['tr'], // Menggunakan key `tr` untuk teks Latin
      teksIndonesia:
          json['idn'], // Menggunakan key `idn` untuk terjemahan Indonesia
    );
  }
}
