// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../services/car_service.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;
  late List<Car> _results;
  bool _onSaleOnly = false;
  String _sortBy = 'none';
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _performSearch();
  }

  void _performSearch() {
    final searchResults = CarService.searchCars(_searchController.text);
    final filtered = CarService.filterCars(
      cars: searchResults,
      onSaleOnly: _onSaleOnly ? true : null,
      maxPrice: _maxPrice,
      sortBy: _sortBy == 'none' ? null : _sortBy,
    );
    setState(() {
      _results = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // ✅ SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _performSearch(),
                    decoration: InputDecoration(
                      hintText: "Search cars...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _performSearch();
                              },
                              child: const Icon(Icons.close,
                                  color: Colors.grey),
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ✅ FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // On Sale filter
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _onSaleOnly = !_onSaleOnly;
                    });
                    _performSearch();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _onSaleOnly
                          ? const Color(0xFFEF3F43)
                          : Colors.white,
                      border: Border.all(
                        color: _onSaleOnly
                            ? const Color(0xFFEF3F43)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'On Sale',
                          style: TextStyle(
                            color: _onSaleOnly
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_onSaleOnly)
                          const SizedBox(width: 4),
                        if (_onSaleOnly)
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Price filter
                GestureDetector(
                  onTap: () => _showPriceFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _maxPrice != null
                          ? const Color(0xFFEF3F43)
                          : Colors.white,
                      border: Border.all(
                        color: _maxPrice != null
                            ? const Color(0xFFEF3F43)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: _maxPrice != null
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.expand_more,
                          color: _maxPrice != null
                              ? Colors.white
                              : Colors.black,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Sort filter
                GestureDetector(
                  onTap: () => _showSortFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _sortBy != 'none'
                          ? const Color(0xFFEF3F43)
                          : Colors.white,
                      border: Border.all(
                        color: _sortBy != 'none'
                            ? const Color(0xFFEF3F43)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort',
                          style: TextStyle(
                            color: _sortBy != 'none'
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.expand_more,
                          color: _sortBy != 'none'
                              ? Colors.white
                              : Colors.black,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ✅ RESULTS COUNT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '${_results.length} Results Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ✅ RESULTS LIST or NO RESULTS
          Expanded(
            child: _results.isEmpty
                ? _buildNoResults()
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final car = _results[index];
                      return _buildCarCard(car);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ✅ NO RESULTS WIDGET
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.amber[300],
          ),
          const SizedBox(height: 20),
          const Text(
            "Sorry we couldn't find any",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Text(
            "matching result for your Search.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              _onSaleOnly = false;
              _sortBy = 'none';
              _maxPrice = null;
              _performSearch();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF3F43),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Explore Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ CAR CARD
  Widget _buildCarCard(Car car) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Image.asset(
                  car.image,
                  fit: BoxFit.cover,
                ),
              ),
              // Wishlist button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_outline,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              // On Sale badge
              if (car.onSale)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF3F43),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'On Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Car name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              car.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF3F43),
                  ),
                ),
                if (car.onSale)
                  Text(
                    car.originalPrice,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ PRICE FILTER DIALOG
  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double tempPrice = _maxPrice ?? 100;
        return StatefulBuilder(
          builder: (context, setModalState) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Max Price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: tempPrice,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    setModalState(() {
                      tempPrice = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  '\$$tempPrice.toStringAsFixed(0)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFEF3F43)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFFEF3F43),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _maxPrice = tempPrice;
                          });
                          _performSearch();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF3F43),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ SORT FILTER DIALOG
  void _showSortFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Price: Low to High', 'price_low'),
            _buildSortOption('Price: High to Low', 'price_high'),
            _buildSortOption('Top Rated', 'rating'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        _performSearch();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _sortBy == value
                    ? const Color(0xFFEF3F43)
                    : Colors.black,
              ),
            ),
            if (_sortBy == value)
              const Icon(
                Icons.check,
                color: Color(0xFFEF3F43),
              ),
          ],
        ),
      ),
    );
  }
}
