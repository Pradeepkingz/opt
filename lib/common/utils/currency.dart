import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

String formatCurrency(int value) => _currencyFormatter.format(value);
