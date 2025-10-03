import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers.dart';
import '../../strings.dart';

class RoleSwitcherPage extends ConsumerWidget {
  const RoleSwitcherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(settingsRepositoryProvider).getRole(),
      builder: (context, snapshot) {
        final role = snapshot.data ?? 'user';
        return Scaffold(
          appBar: AppBar(title: const Text(Strings.roleSwitcherTitle)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  title: const Text(Strings.userRole),
                  value: 'user',
                  groupValue: role,
                  onChanged: (value) async {
                    await ref.read(settingsRepositoryProvider).setRole('user');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text(Strings.adminRole),
                  value: 'admin',
                  groupValue: role,
                  onChanged: (value) async {
                    await ref.read(settingsRepositoryProvider).setRole('admin');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
