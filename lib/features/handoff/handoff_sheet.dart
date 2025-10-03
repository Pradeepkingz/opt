import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../strings.dart';

class HandoffSheet extends StatelessWidget {
  const HandoffSheet({super.key, required this.provider});

  final String provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(provider.substring(0, 1))),
              const SizedBox(width: 12),
              Text(
                provider,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            Strings.handoffDescription,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Launching $provider app...');
              },
              child: const Text(Strings.simulateDeepLink),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.close),
            ),
          ),
        ],
      ),
    );
  }
}
