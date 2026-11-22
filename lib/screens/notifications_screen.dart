import 'package:flutter/material.dart';

import '../core/theme/satis_palette.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_AppNotification> _notifications = [ //lista obaveštenja koja se prikazuju na ekranu
    _AppNotification(
      title: 'Rok se približava',
      message: 'Pregled literature treba da završiš do 25. novembra.',
      timeLabel: 'Danas',
      icon: Icons.schedule_outlined,
    ),
    _AppNotification(
      title: 'Nova povratna informacija',
      message: 'Mentor je ostavio komentar na poglavlje Metod.',
      timeLabel: 'Juče',
      icon: Icons.chat_bubble_outline,
      isRead: true,
    ),
    _AppNotification(
      title: 'Plan rada je ažuriran',
      message: 'Dodata je obaveza za pripremu plana odbrane.',
      timeLabel: 'Pre 3 dana',
      icon: Icons.edit_calendar_outlined,
      isRead: true,
    ),
  ];

  int get _unreadCount => //prebrojava neprocitana obavestenja
      _notifications.where((notification) => !notification.isRead).length;

  void _markAsRead(_AppNotification notification) { 
    if (notification.isRead) return; //ako je obavestenje vec procitano, ne radi nista

    setState(() {
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() { //flutter ponovo renderuje ekran sa novim stanjem, sve obavestenja se oznacavaju kao procitana
      for (final notification in _notifications) {
        notification.isRead = true;
      }
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
            Text('Obaveštenja', style: textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              _unreadCount == 0
                  ? 'Pročitala si sva obaveštenja.'
                  : 'Imaš $_unreadCount nepročitanih obaveštenja.',
              style: textTheme.bodyMedium?.copyWith(
                color: SatisPalette.mutedText,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _unreadCount == 0 ? null : _markAllAsRead,
                icon: const Icon(Icons.done_all),
                label: const Text('Označi sve kao pročitano'),
              ),
            ),
            const SizedBox(height: 8),
            for (final notification in _notifications) ...[
              _NotificationCard(
                notification: notification,
                onTap: () => _markAsRead(notification),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final _AppNotification notification;
  final VoidCallback onTap; //govori kartici sta treba da uradi kada se klikne na nju, u ovom slucaju oznacava obavestenje kao procitano

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isUnread = !notification.isRead;

    return Material( //daje kartici pozadinu i zaobljene ivice
      color: isUnread ? SatisPalette.surface : SatisPalette.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell( //omogućava dodir i vizuelni talasni efekat
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar( //prikazuje ikonu obaveštenja.
                backgroundColor: isUnread
                    ? SatisPalette.sage
                    : SatisPalette.line,
                child: Icon(notification.icon, color: SatisPalette.ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: textTheme.titleMedium,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.circle,
                            size: 9,
                            color: SatisPalette.apricot,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(notification.message, style: textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(notification.timeLabel, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppNotification {
  _AppNotification({
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.icon,
    this.isRead = false,
  });

  final String title;
  final String message;
  final String timeLabel;
  final IconData icon;
  bool isRead;
}
