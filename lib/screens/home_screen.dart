import 'package:flutter/material.dart';
import '../models/virtual_stock.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<VirtualStock>> _futureStocks;

  @override
  void initState() {
    super.initState();
    _futureStocks = ApiService.fetchStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Stock Market'),
      ),
      body: FutureBuilder<List<VirtualStock>>(
        future: _futureStocks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stocks available.'));
          }

          final stocks = snapshot.data!;

          return ListView.builder(
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return ListTile(
                title: Text(stock.name),
                subtitle: Text(stock.ticker),
                trailing: Text('₹${stock.currentPrice.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
