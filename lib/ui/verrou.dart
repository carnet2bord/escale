import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import 'logo.dart';

// État du verrouillage de l'application (mot de passe local).
class VerrouController extends ChangeNotifier {
  final AppDatabase db;
  bool _protege = false;
  bool _verrouille = false;

  VerrouController(this.db);

  bool get protege => _protege;
  bool get verrouille => _protege && _verrouille;

  Future<void> charger() async {
    _protege = await db.aMotDePasse();
    _verrouille = _protege; // verrouillé au démarrage si un mot de passe existe
    notifyListeners();
  }

  // À appeler après avoir défini/retiré le mot de passe dans les réglages.
  Future<void> rafraichir() async {
    _protege = await db.aMotDePasse();
    if (!_protege) _verrouille = false;
    notifyListeners();
  }

  void verrouiller() {
    if (_protege) {
      _verrouille = true;
      notifyListeners();
    }
  }

  void deverrouiller() {
    _verrouille = false;
    notifyListeners();
  }
}

// Enveloppe l'application : affiche l'écran de verrouillage si nécessaire,
// et re-verrouille après une période d'inactivité.
class VerrouGate extends StatefulWidget {
  final Widget child;
  const VerrouGate({required this.child, super.key});

  @override
  State<VerrouGate> createState() => _VerrouGateState();
}

class _VerrouGateState extends State<VerrouGate> {
  static const _delaiInactivite = Duration(minutes: 10);
  Timer? _timer;

  void _activite() {
    final ctrl = context.read<VerrouController>();
    if (!ctrl.protege || ctrl.verrouille) return;
    _timer?.cancel();
    _timer = Timer(_delaiInactivite, () {
      if (mounted) context.read<VerrouController>().verrouiller();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verrouille = context.watch<VerrouController>().verrouille;
    if (verrouille) {
      _timer?.cancel();
      return const _EcranVerrou();
    }
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _activite(),
      onPointerSignal: (_) => _activite(),
      child: widget.child,
    );
  }
}

class _EcranVerrou extends StatefulWidget {
  const _EcranVerrou();

  @override
  State<_EcranVerrou> createState() => _EcranVerrouState();
}

class _EcranVerrouState extends State<_EcranVerrou> {
  final _ctrl = TextEditingController();
  bool _erreur = false;
  bool _verif = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    setState(() => _verif = true);
    final db = context.read<AppDatabase>();
    final ok = await db.verifierMotDePasse(_ctrl.text);
    if (!mounted) return;
    if (ok) {
      context.read<VerrouController>().deverrouiller();
    } else {
      setState(() {
        _erreur = true;
        _verif = false;
        _ctrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoLockup(height: 64),
                const SizedBox(height: 28),
                Icon(Icons.lock_outline, size: 32, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  'Application verrouillée',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Saisissez le mot de passe pour accéder aux données.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _ctrl,
                  obscureText: true,
                  autofocus: true,
                  onSubmitted: (_) => _valider(),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    errorText: _erreur ? 'Mot de passe incorrect.' : null,
                    prefixIcon: const Icon(Icons.password_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _verif ? null : _valider,
                    icon: const Icon(Icons.lock_open_outlined),
                    label: const Text('Déverrouiller'),
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
