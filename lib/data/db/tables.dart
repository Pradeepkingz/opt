import 'package:drift/drift.dart';

class SearchQuery extends Table {
  TextColumn get id => text()();
  TextColumn get origin => text()();
  TextColumn get destination => text()();
  IntColumn get when => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProviderQuote extends Table {
  TextColumn get id => text()();
  TextColumn get queryId => text().references(SearchQuery, #id)();
  TextColumn get provider => text()();
  IntColumn get etaMin => integer()();
  IntColumn get base => integer()();
  IntColumn get fees => integer()();
  IntColumn get total => integer()();
  RealColumn get rating => real()();
  IntColumn get createdAt => integer()();
  BoolColumn get isStale => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['INDEX(provider_quote_query_id_index ON provider_quote(query_id))'];
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class AdapterLog extends Table {
  TextColumn get id => text()();
  TextColumn get provider => text()();
  TextColumn get payload => text()();
  TextColumn get result => text()();
  IntColumn get ts => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['INDEX(adapter_log_ts_index ON adapter_log(ts DESC))'];
}
