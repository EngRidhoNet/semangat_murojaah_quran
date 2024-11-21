import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SurahInfoWidget extends StatelessWidget {
  final String deskripsi;

  const SurahInfoWidget({
    Key? key,
    required this.deskripsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Surah',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Html(
              data: deskripsi,
              style: {
                'body': Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(16),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                'i': Style(
                  fontStyle: FontStyle.italic,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
