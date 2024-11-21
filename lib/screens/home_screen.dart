import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/models/surah.dart';
import 'package:my_quran/providers/theme_provider.dart';
import 'package:my_quran/repositories/quran_repository.dart';
import 'package:my_quran/screens/surah_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quranRepository = context.read<QuranRepository>();
    final themeProvider = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/islamic_pattern.png'), // Tambahkan background pattern islami
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 280.0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1F4690), // Warna biru yang lebih elegan
                        Color(0xFF3A5BA0),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Ornamen Islamic Pattern
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/ornament.png'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.1),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Al-Quran',
                                        style: GoogleFonts.amiri(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Panduan Spiritual Setiap Hari',
                                        style: GoogleFonts.cairo(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        themeProvider.isDarkMode
                                            ? Icons.light_mode
                                            : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          themeProvider.toggleTheme(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              // Card Terakhir Dibaca
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2E5CAD),
                                      Color(0xFF4A72C4),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bookmark,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Terakhir Dibaca',
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Al-Fatiha',
                                      style: GoogleFonts.amiri(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Ayat 1',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Surah...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Color(0xFF1F4690)),
                    ),
                  ),
                ),
              ),
            ),

            // Daftar Surah
            FutureBuilder<List<Surah>>(
              future: quranRepository.getAllSurah(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1F4690)),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final surahs = snapshot.data!;
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final surah = surahs[index];
                        return _buildSurahCard(context, surah);
                      },
                      childCount: surahs.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, Surah surah) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailScreen(
                surahNumber: surah.nomor,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Nomor Surah
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF1F4690).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.nomor}',
                      style: GoogleFonts.amiri(
                        color: Color(0xFF1F4690),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Informasi Surah
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            surah.namaLatin,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            surah.nama,
                            style: GoogleFonts.amiri(
                              fontSize: 20,
                              color: Color(0xFF1F4690),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            surah.tempatTurun.toLowerCase() == 'mekah'
                                ? Icons.mosque
                                : Icons.location_city,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            surah.tempatTurun,
                            style: GoogleFonts.cairo(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.format_list_numbered,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${surah.jumlahAyat} Ayat',
                            style: GoogleFonts.cairo(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
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
      ),
    );
  }
}
