import 'package:flutter/material.dart';

// Logo « Escale » à partir des fichiers de marque fournis.
//
// LogoEscale : le badge (symbole blanc sur carré teal) — pour la version
// compacte et les petits emplacements.
class LogoEscale extends StatelessWidget {
  final double size;
  const LogoEscale({this.size = 44, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/badge.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
    );
  }
}

// LogoLockup : le verrouillage horizontal complet (symbole + « Escale » +
// signature), fond transparent.
class LogoLockup extends StatelessWidget {
  final double height;
  const LogoLockup({this.height = 56, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/logo_escale.png',
      height: height,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      filterQuality: FilterQuality.medium,
    );
  }
}
