import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';

enum _ObligationFilter { all, active, completed }

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
      dueDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 1))),
    ),
    _Obligation(
      title: 'Poslati metodologiju mentoru',
      category: 'Mentor',
      dueDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 3))),
    ),
    _Obligation(
      title: 'Uneti komentare za rezultate',
      category: 'Rezultati',
      dueDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7))),
      isCompleted: true,
    ),
    _Obligation(
      title: 'Pripremiti plan odbrane',
      category: 'Odbrana',
      dueDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 14))),
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

  Future<void> _confirmDeleteObligation(_Obligation obligation) async { //metoda za brisanje obaveze
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Obrisati obavezu?'),
        content: Text('Obaveza „${obligation.title}“ biće uklonjena sa liste.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Otkaži'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return; //!mounted — ekran je u međuvremenu zatvoren ili uklonjen iz aplikacije

    setState(() {
      _obligations.remove(obligation); //uklanja obavezu iz liste i ekran se ponovo renderuje
    });
  }

  Future<void> _showObligationDialog({_Obligation? obligation}) async { //metoda za prikaz dijaloga za dodavanje ili izmenu obaveze
    final isEditing = obligation != null;//proverava da li je u pitanju izmena ili dodavanje nove obaveze
    final formKey = GlobalKey<FormState>(); //proverava da li su uneti podaci validni
    final titleController = TextEditingController(text: obligation?.title ?? '');
    var selectedCategory = obligation?.category ?? _categories.first;
    var selectedDate = DateUtils.dateOnly(//ako je u pitanju izmena obaveze, inicijalno je izabran datum koji je vec unet, ako je u pitanju nova obaveza, inicijalno je izabran datum za 7 dana unapred
      obligation?.dueDate ?? DateTime.now().add(const Duration(days: 7)),
    );

    final changedObligation = await showDialog<_Obligation>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Izmeni obavezu' : 'Nova obaveza'),
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
                        firstDate: selectedDate.isBefore(DateTime.now())
                            ? selectedDate
                            : DateUtils.dateOnly(DateTime.now()),
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
                    dueDate: selectedDate,
                    isCompleted: obligation?.isCompleted ?? false,
                  ),
                );
              },
              child: Text(isEditing ? 'Sačuvaj' : 'Dodaj'),
            ),
          ],
        ),
      ),
    );

    titleController.dispose(); //oslobadja resurse koje koristi TextEditingController
    if (changedObligation == null || !mounted) return;

    setState(() {
      if (obligation == null) {
        _obligations.insert(0, changedObligation);
      } else {
        final index = _obligations.indexOf(obligation);
        if (index != -1) _obligations[index] = changedObligation;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filteredObligations = _filteredObligations;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showObligationDialog(),
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
                onEdit: () => _showObligationDialog(obligation: obligation),
                onDelete: () => _confirmDeleteObligation(obligation),
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
    required this.onEdit,
    required this.onDelete,
  });

  final _Obligation obligation;
  final ValueChanged<bool> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
                  '${obligation.category} · Rok ${_formatDate(obligation.dueDate)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Izmeni obavezu',
            icon: const Icon(Icons.edit_outlined),
            color: SatisPalette.mutedText,
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: 'Obriši obavezu',
            icon: const Icon(Icons.delete_outline),
            color: SatisPalette.mutedText,
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
  final DateTime dueDate;
  bool isCompleted;
}
