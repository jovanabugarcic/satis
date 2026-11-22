import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';

class AuthFormScreen extends StatefulWidget {
  const AuthFormScreen({
    required this.isRegistration,
    super.key,
  });

  final bool isRegistration;

  @override
  State<AuthFormScreen> createState() => _AuthFormScreenState();
}

class _AuthFormScreenState extends State<AuthFormScreen> {
  final _formKey = GlobalKey<FormState>(); //povezuje formu sa njenim stanjem i omogućava pristup metodama za validaciju i čuvanje podataka forme.
  final _nameController = TextEditingController(); //cuva tekstualni unos korisnika u polju za ime i prezime, omogućava pristup unetom tekstu i upravljanje njime.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() { //oslobadja polja kad se ekran zatvori
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() { //da li je forma validna, ako jeste prikazuje poruku da je forma ispravna, u suprotnom prikazuje poruku da forma nije validna.
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final message = widget.isRegistration
        ? 'Forma za registraciju je ispravna.'
        : 'Forma za prijavu je ispravna.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isRegistration = widget.isRegistration;

    return Scaffold(
      appBar: AppBar(
        title: const Text('satis'),
        backgroundColor: SatisPalette.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRegistration ? 'Napravi nalog' : 'Dobro došla nazad',
                  style: textTheme.headlineSmall?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  isRegistration
                      ? 'Unesi podatke da započneš organizaciju svog rada.'
                      : 'Prijavi se da nastaviš tamo gde si stala.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: SatisPalette.mutedText,
                  ),
                ),
                const SizedBox(height: 28),
                if (isRegistration) ...[
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Ime i prezime',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) { //trim brise razmake, pa se proverava da li je ime u razmacima samo
                        return 'Unesi ime i prezime.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email adresa',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) { //provera emaila
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Unesi email adresu.';
                    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$') //da li je email u ispravnom formatu, ako nije vraca poruku o gresci
                        .hasMatch(email)) {
                      return 'Unesi ispravnu email adresu.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      tooltip: _isPasswordVisible
                          ? 'Sakrij lozinku'
                          : 'Prikaži lozinku',
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) return 'Unesi lozinku.';
                    if (isRegistration && password.length < 8) {
                      return 'Lozinka treba da ima najmanje 8 znakova.';
                    }
                    return null;
                  },
                ),
                if (isRegistration) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Potvrdi lozinku',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _isConfirmPasswordVisible
                            ? 'Sakrij lozinku'
                            : 'Prikaži lozinku',
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ponovo unesi lozinku.';
                      }
                      if (value != _passwordController.text) {
                        return 'Lozinke se ne podudaraju.';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submitForm,
                    child: Text(isRegistration ? 'Napravi nalog' : 'Prijavi se'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Nazad'),
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
