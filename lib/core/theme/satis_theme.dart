import 'package:flutter/material.dart';
import 'satis_palette.dart';

abstract final class SatisTheme {
  static ThemeData get light { //light je statički getter koji vraća svetlu ThemeData
    final colorScheme = ColorScheme.fromSeed(//sema boja
      seedColor: SatisPalette.sage,
      brightness: Brightness.light,
    ).copyWith(
      primary: SatisPalette.ink,
      secondary: SatisPalette.sage,
      surface: SatisPalette.surface,
      onSurface: SatisPalette.ink,
    );

    return ThemeData( //ThemeData je klasa koja definiše vizuelni izgled aplikacije, uključujući boje, fontove i stilove widgeta
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SatisPalette.background,
      fontFamily: 'Instrument Sans',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(//headlineSmall je stil za naslov
          fontFamily: 'Newsreader',
          color: SatisPalette.ink,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.15,
        ),
        titleMedium: TextStyle(//stil za srednje naslove
          color: SatisPalette.ink,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(//stil za srednji tekst
          color: SatisPalette.ink,
          fontSize: 14,
          height: 1.35,
        ),
        bodySmall: TextStyle(//stil za mali tekst
          color: SatisPalette.mutedText,
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
  }
}