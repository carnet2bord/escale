import 'package:flutter/material.dart';

import '../domain/distance.dart';
import 'widgets.dart';

// Bloc « Adresse & localisation » réutilisé par les éditeurs accueillant/enfant.
// Géocodage BAN à la demande (appel externe) ou saisie manuelle des coordonnées.
// Le calcul de distance se fait ensuite localement.
class BlocAdresse extends StatefulWidget {
  final TextEditingController adresse;
  final TextEditingController latitude;
  final TextEditingController longitude;
  const BlocAdresse({
    super.key,
    required this.adresse,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<BlocAdresse> createState() => _BlocAdresseState();
}

class _BlocAdresseState extends State<BlocAdresse> {
  bool _chargement = false;

  Future<void> _geocoder() async {
    final adresse = widget.adresse.text.trim();
    if (adresse.isEmpty) return;
    setState(() => _chargement = true);
    final c = await geocoderBAN(adresse);
    if (!mounted) return;
    setState(() => _chargement = false);
    if (c != null) {
      widget.latitude.text = c.latitude.toStringAsFixed(6);
      widget.longitude.text = c.longitude.toStringAsFixed(6);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coordonnées trouvées via la BAN.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adresse introuvable (BAN).')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBloc(
      titre: 'Adresse & localisation',
      sousTitre:
          'Sert au calcul des distances. Le géocodage envoie l\'adresse à la '
          'BAN (data.gouv.fr) ; vous pouvez aussi saisir les coordonnées à la '
          'main. Données fictives tant que le DPO n\'a pas validé.',
      enfants: [
        TextFormField(
          controller: widget.adresse,
          decoration: const InputDecoration(
            labelText: 'Adresse',
            hintText: 'N°, rue, code postal, ville',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.latitude,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: widget.longitude,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: _chargement ? null : _geocoder,
              icon: _chargement
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.travel_explore),
              label: const Text('Géocoder'),
            ),
          ],
        ),
      ],
    );
  }
}
