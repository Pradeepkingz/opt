class GeocodeStub {
  const GeocodeStub();

  List<String> suggestions(String query) {
    if (query.isEmpty) return const [];
    final lower = query.toLowerCase();
    final places = const [
      'RS Puram',
      'CJB Airport',
      'Peelamedu',
      'Gandhipuram',
      'Town Hall',
      'Brookefields',
      'Sai Baba Colony',
      'Kalapatti',
      'Singanallur',
      'Race Course',
    ];
    return places
        .where((place) => place.toLowerCase().contains(lower))
        .take(5)
        .toList();
  }
}
