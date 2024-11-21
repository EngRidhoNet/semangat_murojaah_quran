import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/models/surah_detail.dart';
import 'package:my_quran/repositories/quran_repository.dart';
import 'package:provider/provider.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen({
    Key? key,
    required this.surahNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quranRepository = context.read<QuranRepository>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/light_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: FutureBuilder<SurahDetail>(
          future: quranRepository.getSurahDetail(surahNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F4690)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: textTheme.titleMedium,
                ),
              );
            }

            final surah = snapshot.data!;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground
                    ],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient Background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF1F4690),
                                Color(0xFF3A5BA0),
                              ],
                            ),
                          ),
                        ),
                        // Islamic Pattern Overlay
                        Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/images/islamic_pattern_overlay.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Content
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ornamental Divider Top
                              Image.asset(
                                'assets/images/bismillah.png',
                                height: 40,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              SizedBox(height: 20),
                              Text(
                                surah.nama,
                                style: GoogleFonts.amiri(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                surah.namaLatin,
                                style: GoogleFonts.cairo(
                                  fontSize: 24,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  surah.arti,
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildInfoChip(
                                    icon: surah.tempatTurun.toLowerCase() ==
                                            'mekah'
                                        ? Icons.mosque
                                        : Icons.location_city,
                                    label: surah.tempatTurun,
                                  ),
                                  SizedBox(width: 12),
                                  _buildInfoChip(
                                    icon: Icons.format_list_numbered,
                                    label: '${surah.jumlahAyat} Ayat',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Daftar Ayat
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ayat = surah.ayat[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF1F4690).withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header Ayat
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1F4690).withOpacity(0.05),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1F4690),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${ayat.nomor}',
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.bookmark_border),
                                      color: Color(0xFF1F4690),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.play_circle_outline),
                                      color: Color(0xFF1F4690),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.share_outlined),
                                      color: Color(0xFF1F4690),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              // Konten Ayat
                              Container(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Teks Arab
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        ayat.teksArab,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.amiri(
                                          fontSize: 28,
                                          height: 2.0,
                                          color: Color(0xFF1F4690),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    // Teks Latin
                                    Text(
                                      ayat.teksLatin,
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Divider(height: 24),
                                    // Terjemahan
                                    Text(
                                      ayat.teksIndonesia,
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: surah.ayat.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
