import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';

enum _ObligationFilter { all, active, completed }

class ObligationsScreen extends StatefulWidget { //stanje se menja po oznacavanju obaveza
  const ObligationsScreen({super.key});

  @override
  State<ObligationsScreen> createState() => _ObligationsScreenState();
}

class _ObligationsScreenState extends State<ObligationsScreen> { 
  _ObligationFilter _selectedFilter = _ObligationFilter.all; //pamti trenutno izabran filter, inicijalno je izabran filter sve

  static const _categories = [
    'Pisanje',
    'Literatura',
    'Mentor',
    'Rezultati',
    'Odbrana',
  ];

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

  int get _activeCount => _obligations.length - _completedCount; //broji aktivne obaveze

  List<_Obligation> get _filteredObligations { //vraca listu obaveza za odgovarajuci filter
    switch (_selectedFilter) {
      case _ObligationFilter.active:
        return _obligations
            .where((obligation) => !obligation.isCompleted)
            .toList();
      case _ObligationFilter.completed:
        return _obligations
            .where((obligation) => obligation.isCompleted)
            .toList();
      case _ObligationFilter.all:
        return _obligations;
    }
  }

  void _selectFilter(_ObligationFilter filter) { //menja trenutno izabrani filter i ekran se ponovo renderuje
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _setCompleted(_Obligation obligation, bool isCompleted) { //menja stanje obaveze na zavrsenu, ekran se opet azurira posle
    setState(() {
      obligation.isCompleted = isCompleted;
    });
  }

  Future<void> _showAddObligationDialog() async {
    final formKey = GlobalKey<FormState>(); //proverava da li su uneti podaci validni
    final titleController = TextEditingController(); //cuva tekst koji je unet u polje za naziv obaveze
    var selectedCategory = _categories.first; //inicijalno je izabrana prva kategorija
    var selectedDate = DateTime.now().add(const Duration(days: 7)); //inicijalno je izabran datum koji je 7 dana od danas

    final newObligation = await showDialog<_Obligation>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nova obaveza'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Naziv obaveze',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) { //proverava da li je unet naziv obaveze, ako nije vraca poruku o gresci
                    if (value == null || value.trim().isEmpty) {
                      return 'Unesi naziv obaveze.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>( //prikazuje padajuci meni sa kategorijama
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategorija',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem( //pravi dropdown item za svaku kategoriju
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(), //pravi listu DropdownMenuItem widgeta za svaku kategoriju
                  onChanged: (category) {
                    if (category == null) return;
                    setDialogState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
                      if (date == null) return;
                      setDialogState(() {
                        selectedDate = date;
                      });
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text('Rok: ${_formatDate(selectedDate)}'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Otkaži'),
            ),
            FilledButton(
              onPressed: () { //proverava da li su uneti podaci validni, ako jesu zatvara dijalog i vraca novu obavezu, ako nisu ne radi nista
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.of(dialogContext).pop(
                  _Obligation(
                    title: titleController.text.trim(),
                    category: selectedCategory,
                    dueDate: _formatDate(selectedDate),
                  ),
                );
              },
              child: const Text('Dodaj'),
            ),
          ],
        ),
      ),
    );

    titleController.dispose(); //oslobadja resurse koje koristi TextEditingController
    if (newObligation == null || !mounted) return;

    setState(() {//dodaje novu obavezu u listu i ekran se ponovo renderuje
      _obligations.insert(0, newObligation);
    });
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'januar',
      'februar',
      'mart',
      'april',
      'maj',
      'jun',
      'jul',
      'avgust',
      'septembar',
      'oktobar',
      'novembar',
      'decembar',
    ];

    return '${date.day}. ${monthNames[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filteredObligations = _filteredObligations;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddObligationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nova obaveza'),
      ),
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
            Wrap( //mogu da predju u novi red ako nema dovoljno prostora, prikazuje filtere za obaveze
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text('Sve (${_obligations.length})'),
                  selected: _selectedFilter == _ObligationFilter.all,
                  onSelected: (_) => _selectFilter(_ObligationFilter.all),
                ),
                ChoiceChip(
                  label: Text('Aktivne ($_activeCount)'),
                  selected: _selectedFilter == _ObligationFilter.active,
                  onSelected: (_) => _selectFilter(_ObligationFilter.active),
                ),
                ChoiceChip(
                  label: Text('Završene ($_completedCount)'),
                  selected: _selectedFilter == _ObligationFilter.completed,
                  onSelected: (_) =>
                      _selectFilter(_ObligationFilter.completed),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (filteredObligations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    _selectedFilter == _ObligationFilter.completed
                        ? 'Još nema završenih obaveza.'
                        : 'Nema aktivnih obaveza.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: SatisPalette.mutedText,
                    ),
                  ),
                ),
              ),
            for (final obligation in filteredObligations) ...[ //pravi jednu karticu za svaku vidljivu obavezu
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
