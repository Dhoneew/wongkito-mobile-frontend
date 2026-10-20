
import 'package:flutter/material.dart';
import '../tracking/tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTab = 0;

  static const Color orange = Color(0xFFFF6200);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);

  final List<Map<String, dynamic>> orders = [
    {
      'id': 'WK-001',
      'items': '2 Item',
      'price': 61000,
      'date': '28 September 2026',
      'status': 'Sedang Diproses',
    },
    {
      'id': 'WK-002',
      'items': '1 Item',
      'price': 18000,
      'date': '25 September 2026',
      'status': 'Selesai',
    },
    {
      'id': 'WK-003',
      'items': '2 Item',
      'price': 30000,
      'date': '29 September 2026',
      'status': 'Selesai',
    },
    {
      'id': 'WK-004',
      'items': '1 Item',
      'price': 12000,
      'date': '28 September 2026',
      'status': 'Selesai',
    },
    {
      'id': 'WK-011',
      'items': '2 Item',
      'price': 20000,
      'date': '28 September 2026',
      'status': 'Selesai',
    },
  ];

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = selectedTab == 0
        ? orders
            .where((order) => order['status'] == 'Sedang Diproses')
            .toList()
        : orders
            .where((order) => order['status'] == 'Selesai')
            .toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 21,
                        color: orange,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pesanan Saya',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        _buildTab('Dalam Proses [1]', 0),
                        _buildTab('Riwayat [5]', 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visibleOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada pesanan.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFF888888),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                      itemCount: visibleOrders.length,
                      itemBuilder: (context, index) {
                        final order = visibleOrders[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TrackingScreen(
                                  orderId: order['id'] as String,
                                  total: order['price'] as int,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFDDDDDD),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order['date'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '#${order['id']}',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: dark,
                                            ),
                                          ),
                                          Text(
                                            '${order['items']} · Dine-in · Meja 05',
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              color: dark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      rupiah(order['price'] as int),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: dark,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: orange,
                                        borderRadius:
                                            BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        order['status'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (order['status'] ==
                                        'Sedang Diproses')
                                      const Text(
                                        'Estimasi 14:22',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: selected ? Colors.white : orange,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: selected ? dark : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}