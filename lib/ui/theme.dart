import 'package:flutter/material.dart';

// Système de design « Escale » — moderne & épuré, en clair et en sombre.
// Fond neutre, surfaces à filet fin (pas d'ombres lourdes), un seul accent
// (teal marine), typographie nette.
class AppTheme {
  AppTheme._();

  static const Color accent = Color(0xFF156F6C); // teal de marque Escale
  static const Color _accentSombre = Color(0xFF2BB5A6); // accent éclairci

  // Tons clairs.
  static const Color _fondL = Color(0xFFF6F7F8);
  static const Color _surfaceL = Colors.white;
  static const Color _filetL = Color(0xFFE6E8EB);
  static const Color _texteL = Color(0xFF1A1C1E);
  static const Color _texteDouxL = Color(0xFF5A6168);

  // Tons sombres.
  static const Color _fondD = Color(0xFF151719);
  static const Color _surfaceD = Color(0xFF1E2123);
  static const Color _filetD = Color(0xFF31353A);
  static const Color _texteD = Color(0xFFE7E9EC);
  static const Color _texteDouxD = Color(0xFF9AA1A8);

  static const double rayon = 14;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final sombre = b == Brightness.dark;
    final fond = sombre ? _fondD : _fondL;
    final surface = sombre ? _surfaceD : _surfaceL;
    final filet = sombre ? _filetD : _filetL;
    final texte = sombre ? _texteD : _texteL;
    final texteDoux = sombre ? _texteDouxD : _texteDouxL;
    final acc = sombre ? _accentSombre : accent;

    final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: b)
        .copyWith(
          primary: acc,
          surface: surface,
          onSurface: texte,
          onSurfaceVariant: texteDoux,
          outlineVariant: filet,
          outline: sombre ? const Color(0xFF44484D) : const Color(0xFFC7CCD1),
        );

    final base = ThemeData(
      colorScheme: scheme,
      brightness: b,
      useMaterial3: true,
      scaffoldBackgroundColor: fond,
    );

    final t = base.textTheme;
    final textTheme = t.copyWith(
      displaySmall: t.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: texte,
      ),
      headlineMedium: t.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: texte,
      ),
      headlineSmall: t.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: texte,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: texte,
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: texte,
      ),
      bodyMedium: t.bodyMedium?.copyWith(color: texte, height: 1.4),
      bodySmall: t.bodySmall?.copyWith(color: texteDoux, height: 1.35),
      labelLarge: t.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    OutlineInputBorder bord(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c, width: w),
    );

    return base.copyWith(
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: fond,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: texte,
        titleTextStyle: TextStyle(
          color: texte,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rayon),
          side: BorderSide(color: filet),
        ),
      ),
      dividerTheme: DividerThemeData(color: filet, space: 1, thickness: 1),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: texteDoux),
        selectedLabelTextStyle: TextStyle(
          color: texte,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelTextStyle: TextStyle(color: texteDoux, fontSize: 13),
        useIndicator: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: bord(filet),
        enabledBorder: bord(filet),
        focusedBorder: bord(acc, 1.6),
        labelStyle: TextStyle(color: texteDoux),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: acc,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 1,
        highlightElevation: 2,
        backgroundColor: acc,
        foregroundColor: Colors.white,
        extendedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: sombre ? const Color(0xFF2D3135) : _texteL,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rayon),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: filet),
        ),
      ),
    );
  }
}
