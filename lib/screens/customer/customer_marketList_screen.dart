import 'package:danji_client/services/market_service.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerMarketListScreen extends StatefulWidget {
  const CustomerMarketListScreen({super.key});

  @override
  State<CustomerMarketListScreen> createState() =>
      _CustomerMarketListScreenState();
}

class _CustomerMarketListScreenState extends State<CustomerMarketListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _markets = [];
  bool _hasNext = true;
  bool _isFetching = false;
  int _page = 0;
  String _currentKeyword = "";

  @override
  void initState() {
    super.initState();
    _loadMarkets();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMarkets();
      }
    });
  }

  Future<void> _loadMarkets({bool isSearch = false}) async {
    if (_isFetching || (!_hasNext && !isSearch)) return;

    setState(() {
      _isFetching = true;
    });

    if (isSearch) {
      _page = 0;
      _markets.clear();
      _hasNext = true;
    }
    
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final response = await MarketService().getMarkets(_currentKeyword, _page);
      final newItems = List<Map<String, dynamic>>.from(response['items']);

      setState(() {
        _markets.addAll(newItems);
        _hasNext = response['hasNext'];
        _page++;
        _isFetching = false;
      });
    } catch (e) {
      setState(() {
        _isFetching = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("가게 목록을 불러오지 못했어요.")));
    }
  }

  void _onSearch() {
    setState(() {
      _currentKeyword = _searchController.text;
    });
    _loadMarkets(isSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '가게 ', blackTitle: '둘러보기'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBox(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _markets.length + (_hasNext ? 1 : 0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  if (index < _markets.length) {
                    final market = _markets[index];
                    return _buildStoreCard(
                      id: market['id'],
                      name: market['name'],
                      address: market['address'],
                      imageUrl: market['imageUrl'],
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
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
                onSubmitted: (_) => _onSearch(),
              ),
            ),
            IconButton(
              onPressed: _onSearch,
              icon: const Icon(Icons.search, color: Color(0xFF1E88E5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard({
    required int id,
    required String name,
    required String address,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/home/customer/marketList/detail/$id',
          extra: {'marketName': name, 'marketAddress': address},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/app-icon.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/app-icon.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
