import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/utils/time_fmt.dart';
import '../../providers.dart';
import '../../strings.dart';
import '../rides/controllers/ride_quotes_controller.dart';
import '../rides/controllers/ride_search_controller.dart';

class RideSearchForm extends ConsumerWidget {
  const RideSearchForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideSearchControllerProvider);
    final controller = ref.read(rideSearchControllerProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.tagline,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _TextField(
              label: Strings.originHint,
              value: state.origin,
              onChanged: controller.setOrigin,
              suggestions: controller.suggestions,
            ),
            const SizedBox(height: 12),
            _TextField(
              label: Strings.destinationHint,
              value: state.destination,
              onChanged: controller.setDestination,
              suggestions: controller.suggestions,
            ),
            const SizedBox(height: 12),
            SegmentedButton<RideTimeOption>(
              segments: const [
                ButtonSegment(value: RideTimeOption.now, label: Text(Strings.whenNow)),
                ButtonSegment(value: RideTimeOption.later, label: Text(Strings.whenLater)),
              ],
              selected: {state.when},
              onSelectionChanged: (values) => controller.setWhen(values.first),
            ),
            if (state.when == RideTimeOption.later) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 7)),
                  );
                  if (picked == null) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30))),
                  );
                  if (time == null) return;
                  controller.setDeparture(DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    time.hour,
                    time.minute,
                  ));
                },
                icon: const Icon(Icons.schedule),
                label: Text(state.departure == null
                    ? 'Choose time'
                    : formatDateTime(state.departure!)),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  controller.validate();
                  if (!ref.read(rideSearchControllerProvider).isValid) return;
                  final city = await ref.read(settingsRepositoryProvider).city();
                  final input = controller.buildInput(city);
                  await ref
                      .read(rideQuotesControllerProvider.notifier)
                      .fetch(input);
                  if (context.mounted) {
                    context.go('/compare');
                  }
                },
                child: const Text(Strings.searchCta),
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  const _TextField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.suggestions,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final List<String> Function(String) suggestions;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  List<String> options = const [];

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
    controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant _TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != controller.text) {
      controller.text = widget.value;
    }
  }

  void _onChanged() {
    widget.onChanged(controller.text);
    setState(() {
      options = widget.suggestions(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: widget.label),
        ),
        if (options.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                for (final option in options)
                  ListTile(
                    dense: true,
                    title: Text(option),
                    onTap: () {
                      controller.text = option;
                      widget.onChanged(option);
                      setState(() => options = const []);
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
