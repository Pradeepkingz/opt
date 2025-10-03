String formatEta(int minutes) {
  if (minutes < 1) return 'Now';
  return '$minutes min';
}

String formatDateTime(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
