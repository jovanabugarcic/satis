import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';
import '../screens/student_dashboard_screen.dart';

class SatisShell extends StatefulWidget {
  const SatisShell({super.key}); //konstruktor const SatisShell({super.key}) je konstruktor koji poziva konstruktor nadklase StatefulWidget i prosleđuje mu ključ (key) koji omogućava Flutteru da identifikuje widget u stablu aplikacija.

  @override
  State<SatisShell> createState() => _SatisShellState(); //njegov sadrzaj se menja kada korisnik interaguje sa navigacionom trakom, pa je potrebno da se koristi StatefulWidget
}//vraca rezultat metode createState koja kreira instancu _SatisShellState klase, koja sadrži stanje i logiku za SatisShell widget.

class _SatisShellState extends State<SatisShell> {
  int _selectedIndex = 0; //Čuva broj trenutno izabrane stavke. Indeksi u listi počinju od nule

  static const _destinations = [ //moguce destinacije koje se prikazuju u navigacionoj traci. 
    NavigationDestination( //Svaka destinacija ima ikonu, selektovanu ikonu i labelu.
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Pregled',
    ),
    NavigationDestination(
      icon: Icon(Icons.checklist_outlined),
      selectedIcon: Icon(Icons.checklist),
      label: 'Obaveze',
    ),
    NavigationDestination(
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications),
      label: 'Obaveštenja',
    ),
  ];

  @override
  Widget build(BuildContext context) { //pravi korisnički interfejs za SatisShell widget. Metoda build se poziva svaki put kada se stanje widgeta promeni, 
  //a kontekst (context) sadrži informacije o lokaciji widgeta u stablu widgeta, kao i informacije o temi, jeziku i drugim aspektima okruženja aplikacije.
    final pages = [ //spisak ekrana
      const StudentDashboardScreen(),
      const _PlaceholderPage(
        title: 'Obaveze',
        description: 'Ovde ćeš pratiti svoje obaveze i rokove.',
        icon: Icons.checklist_outlined,
      ),
      const _PlaceholderPage(
        title: 'Obaveštenja',
        description: 'Ovde će se prikazivati važna obaveštenja.',
        icon: Icons.notifications_outlined,
      ),
    ];

    return Scaffold(//Vraća osnovni Material raspored ekrana
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SatisPalette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.headlineSmall),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Icon(icon, size: 40, color: SatisPalette.mutedText),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
