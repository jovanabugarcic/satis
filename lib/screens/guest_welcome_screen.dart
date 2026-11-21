import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';
import '../navigation/satis_shell.dart';

class GuestWelcomeScreen extends StatelessWidget {
  const GuestWelcomeScreen({super.key});

  void _continueAsGuest(BuildContext context) {
    Navigator.of(context).pushReplacement( //otvara novi ekran i uklanja trenutni ekran iz navigacionog steka, tako da korisnik ne može da se vrati na prethodni ekran pritiskom na dugme za povratak.
      MaterialPageRoute<void>(
        builder: (context) => const SatisShell(), //usmerava korisnika na SatisShell ekran, koji je glavni ekran aplikacije za studente.
      ),
    );
  }

  void _showComingSoon(BuildContext context, String featureName) { 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opcija $featureName biće dostupna.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: SatisPalette.ink,
                    size: 27,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'satis',
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 22,
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: SatisPalette.sage,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: SatisPalette.ink,
                  size: 32,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Manje stresa.\nViše jasnoće.',
                style: textTheme.headlineSmall?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 14),
              Text(
                'Organizuj rad na završnom radu, prati obaveze i uvek znaj koji je sledeći korak.',
                style: textTheme.bodyMedium?.copyWith(
                  color: SatisPalette.mutedText,
                  fontSize: 16,
                ),
              ),
              const Spacer(), //dodaje fleksibilni prostor između prethodnog teksta i dugmadi ispod, gurajući dugmad ka dnu ekrana.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _showComingSoon(context, 'Prijava'),
                  child: const Text('Prijavi se'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showComingSoon(context, 'Registracija'),
                  child: const Text('Napravi nalog'),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => _continueAsGuest(context),
                  child: const Text('Nastavi kao gost'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
