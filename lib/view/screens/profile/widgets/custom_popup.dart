import 'package:flutter/material.dart';
import 'package:tube_vibe/provider/user_provider.dart';

class CustomPopupMenu extends StatelessWidget {
  final UserProvider userProvider;
  const CustomPopupMenu({
    super.key,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'Watchlist':
            Navigator.of(context).pushNamed('watch-list');
            break;
          case 'Logout':
            userProvider.logout(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'Watchlist',
            child: Text('Watchlist'),
          ),
          const PopupMenuItem<String>(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert),
    );
  }
}
