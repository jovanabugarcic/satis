import 'package:flutter/material.dart';
import '../core/theme/satis_palette.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {//pomocu context-a se pristupa temama i stilovima aplikacije, a zatim se kreira Scaffold koji sadrži SafeArea i SingleChildScrollView za prikaz sadržaja ekrana
    return Scaffold(
      body: SafeArea(//SafeArea je widget koji osigurava da sadržaj ekrana ne bude preklopljen status barom, notch-om ili drugim sistemskim elementima
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandHeader(),
              const SizedBox(height: 28),
              Text(
                'Master rad · UX psihologija',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Preopterećenost izborom u onboardingu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: _Metric(value: '2/5', label: 'poglavlja')),
                  SizedBox(width: 10),
                  Expanded(child: _Metric(value: '3', label: 'obavezne')),
                  SizedBox(width: 10),
                  Expanded(child: _Metric(value: '38', label: 'dana')),
                ],
              ),
              const SizedBox(height: 22),
              const _StatusPanel(),
              const SizedBox(height: 12),
              const _NextStepPanel(),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Poglavlja', style: Theme.of(context).textTheme.titleMedium),
                  Text('2 od 5', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 10),
              const _ChapterRow(name: 'Uvod', progress: '5/5', closed: true),
              const SizedBox(height: 8),
              const _ChapterRow(name: 'Metod', progress: '4/4', closed: true),
              const SizedBox(height: 8),
              const _ChapterRow(name: 'Rezultati', progress: '2/5'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget { //gornji deo ekrana sa logom i notifikacijama
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: SatisPalette.ink, size: 27),
        const SizedBox(width: 8),
        Text(
          'satis',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 22,
                letterSpacing: -0.8,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          tooltip: 'Obaveštenja',
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {//prikazuje metriku sa vrednošću i labelom
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: SatisPalette.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(//za prikazivanje vrednosti i labela u metriki
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'Geist Mono', fontSize: 21)),
          const SizedBox(height: 3),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {//prikazuje status rada sa informacijama o planu i roku
  const _StatusPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SatisPalette.sage,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status rada', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: SatisPalette.ink)),
          const SizedBox(height: 5),
          Text('U planu', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text('Rok 14. decembar · bez kašnjenja', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: SatisPalette.ink)),
        ],
      ),
    );
  }
}

class _NextStepPanel extends StatelessWidget { //prikazuje sledeći korak sa informacijama o obavezama i linkom za otvaranje poglavlja
  const _NextStepPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SatisPalette.apricot,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sledeći korak', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: SatisPalette.ink)),
          const SizedBox(height: 5),
          Text('3 obavezne izmene u poglavlju Rezultati', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Text('Otvori poglavlje  →', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {//prikazuje red sa informacijama o poglavlju, uključujući naziv, napredak i status zatvorenosti
  const _ChapterRow({required this.name, required this.progress, this.closed = false});

  final String name;
  final String progress;
  final bool closed;

  @override
  Widget build(BuildContext context) {
    final background = closed ? SatisPalette.closedBackground : SatisPalette.surface;
    final foreground = closed ? SatisPalette.closedText : SatisPalette.ink;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            closed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            color: closed ? SatisPalette.closedText : SatisPalette.mutedText,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: foreground))),
          Text(progress, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground)),
        ],
      ),
    );
  }
}