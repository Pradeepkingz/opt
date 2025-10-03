import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers.dart';
import '../../strings.dart';

class LogsViewer extends ConsumerWidget {
  const LogsViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(logDaoProvider).latest(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final logs = snapshot.data!;
        if (logs.isEmpty) {
          return const Center(child: Text(Strings.logsEmpty));
        }
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              title: Text(log['provider'] as String),
              subtitle: Text(log['payload'] as String),
              trailing: Text(DateTime.fromMillisecondsSinceEpoch(log['ts'] as int)
                  .toLocal()
                  .toString()),
            );
          },
        );
      },
    );
  }
}
