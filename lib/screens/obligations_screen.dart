import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';

class ObligationsScreen extends StatefulWidget { //stanje se menja po oznacavanju obaveza
  const ObligationsScreen({super.key});

  @override
  State<ObligationsScreen> createState() => _ObligationsScreenState();
}

class _ObligationsScreenState extends State<ObligationsScreen> {
  final List<_Obligation> _obligations = [ //lista obaveza koje se prikazuju na ekranu
    _Obligation(
      title: 'Dovršiti pregled literature',
      category: 'Literatura',
      dueDate: '25. novembar',
    ),
    _Obligation(
      title: 'Poslati metodologiju mentoru',
      category: 'Mentor',
      dueDate: '24. novembar',
    ),
    _Obligation(
      title: 'Uneti komentare za rezultate',
      category: 'Rezultati',
      dueDate: '28. novembar',
      isCompleted: true,
    ),
    _Obligation(
      title: 'Pripremiti plan odbrane',
      category: 'Odbrana',
      dueDate: '5. decembar',
    ),
  ];

  int get _completedCount => //prebrojava zavrsene zadatke
      _obligations.where((obligation) => obligation.isCompleted).length;

  void _setCompleted(_Obligation obligation, bool isCompleted) { //menja stanje obaveze na zavrsenu, ekran se opet azurira posle
    setState(() {
      obligation.isCompleted = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text('Obaveze', style: textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Prati sledeće korake na putu do završnog rada.',
              style: textTheme.bodyMedium?.copyWith(
                color: SatisPalette.mutedText,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: SatisPalette.sage,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$_completedCount od ${_obligations.length} obaveza završeno',
                      style: textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tvoj plan', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final obligation in _obligations) ...[ //pravi jednu karticu za svaku obavezu iz liste, sa checkboxom koji menja stanje obaveze
              _ObligationCard( //prikazuje karticu sa obavezom
                obligation: obligation,
                onChanged: (isCompleted) =>
                    _setCompleted(obligation, isCompleted),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _ObligationCard extends StatelessWidget {
  const _ObligationCard({
    required this.obligation,
    required this.onChanged,
  });

  final _Obligation obligation;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = obligation.isCompleted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCompleted ? SatisPalette.closedBackground : SatisPalette.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: SatisPalette.closedText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obligation.title,
                  style: textTheme.bodyMedium?.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? SatisPalette.closedText
                        : SatisPalette.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${obligation.category} · Rok ${obligation.dueDate}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Obligation {
  _Obligation({
    required this.title,
    required this.category,
    required this.dueDate,
    this.isCompleted = false,
  });

  final String title;
  final String category;
  final String dueDate;
  bool isCompleted;
}
