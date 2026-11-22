import 'package:flutter/material.dart';

import '../screens/notifications_screen.dart';
import '../screens/obligations_screen.dart';
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
      const ObligationsScreen(),
      const NotificationsScreen(),
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
