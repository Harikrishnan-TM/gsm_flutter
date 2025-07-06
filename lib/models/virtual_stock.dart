class VirtualStock {
  final int id;
  final String name;
  final String ticker;
  final double currentPrice;
  final DateTime lastUpdated;

  VirtualStock({
    required this.id,
    required this.name,
    required this.ticker,
    required this.currentPrice,
    required this.lastUpdated,
  });

  factory VirtualStock.fromJson(Map<String, dynamic> json) {
    return VirtualStock(
      id: json['id'],
      name: json['name'],
      ticker: json['ticker'],
      currentPrice: json['current_price'].toDouble(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}
