import 'package:flutter/material.dart';
import 'package:my_quran/models/surah.dart';

class SearchSurahWidget extends StatelessWidget {
  final List<Surah> surahs;
  final void Function(Surah) onSurahSelected;

  const SearchSurahWidget({
    Key? key,
    required this.surahs,
    required this.onSurahSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: 'Cari Surah...',
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text.toLowerCase();
        return surahs
            .where((surah) =>
                surah.namaLatin.toLowerCase().contains(query) ||
                surah.nama.contains(query) ||
                surah.arti.toLowerCase().contains(query))
            .map((surah) => ListTile(
                  title: Text(surah.namaLatin),
                  subtitle: Text(surah.arti),
                  trailing: Text(
                    surah.nama,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    controller.closeView(surah.namaLatin);
                    onSurahSelected(surah);
                  },
                ));
      },
    );
  }
}
