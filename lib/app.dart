import 'package:flutter/material.dart';
import 'core/theme/satis_theme.dart';
import 'screens/guest_welcome_screen.dart';

class SatisApp extends StatelessWidget {
  const SatisApp({super.key}); // konstruktor super.keyomogucava flutteru da identifikuje widget u stablu aplikacija

  @override
  Widget build(BuildContext context) {//kontekst je objekat koji sadrži informacije o lokaciji widgeta u stablu widgeta, kao i informacije o temi, jeziku i drugim aspektima okruženja aplikacije
    return MaterialApp(//korenski widget koji podešava naziv, temu i početni ekran.
      title: 'Satis',
      debugShowCheckedModeBanner: false,//uklanja debug baner u gornjem desnom uglu aplikacije
      theme: SatisTheme.light,
      home: const GuestWelcomeScreen(),
    );
  }
}
