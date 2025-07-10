import 'package:danji_client/services/market_service.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';

class CustomerMarketListScreen extends StatefulWidget {
  const CustomerMarketListScreen({super.key});

  @override
  State<CustomerMarketListScreen> createState() =>
      _CustomerMarketListScreenState();
}

class _CustomerMarketListScreenState extends State<CustomerMarketListScreen> {
  List<Map<String, dynamic>> markets = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _loadMarkets({String keyword = ""}) async {
    try {
      final response = await MarketService().getMarkets(keyword);
      setState(() {
        markets = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("가게 목록을 불러오지 못했어요.")));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkets(); // 화면 진입 시 keyword 없이 요청
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(blueTitle: '가게 ', blackTitle: '둘러보기'),
              const SizedBox(height: 16),

              // 검색창
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1E88E5)),
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: '검색어를 입력하세요',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _loadMarkets(keyword: _searchController.text);
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 마켓 리스트
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : markets.isEmpty
                    ? const Center(child: Text("등록된 가게가 없어요."))
                    : ListView.builder(
                        itemCount: markets.length,
                        itemBuilder: (context, index) {
                          final market = markets[index];
                          return _buildStoreCard(
                            name: market['name'],
                            address: market['address'],
                            imageUrl: market['imageUrl'],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard({
    required String name,
    required String address,
    String? imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // 마켓 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF535353),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Color(0xFF5B5B5B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.52,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // 이미지 영역
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/app-logo.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}
