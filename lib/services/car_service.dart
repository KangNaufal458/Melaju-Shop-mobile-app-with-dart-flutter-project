class Car {
  final String id;
  final String name;
  final String price;
  final String originalPrice;
  final String image;
  final bool onSale;
  final double rating;
  Car({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.onSale,
    required this.rating,
  });
}
class CarService {
  static final List<Car> _allCars = [
    Car(
      id: '1',
      name: 'Pajero Sport Dakar',
      price: 'Rp 1.000 Jt',
      originalPrice: 'Rp 1.500 Jt',
      image: 'assets/images/Pajero_Dakar.png',
      onSale: true,
      rating: 4.5,
    ),
    Car(
      id: '2',
      name: 'Kijang Innova',
      price: 'Rp 3.500 Jt',
      originalPrice: 'Rp 4.000 Jt',
      image: 'assets/images/Innova_Reborn.png',
      onSale: true,
      rating: 4.8,
    ),
    Car(
      id: '3',
      name: 'Corolla Altis',
      price: 'Rp 600 Jt',
      originalPrice: 'Rp 790 Jt',
      image: 'assets/images/Altis_New.png',
      onSale: false,
      rating: 4.3,
    ),
    Car(
      id: '4',
      name: 'GR Yaris',
      price: 'Rp 45 M',
      originalPrice: 'Rp 70 M',
      image: 'assets/images/Yaris_GR.png',
      onSale: true,
      rating: 4.6,
    ),
    Car(
      id: '5',
      name: 'Avanza',
      price: 'Rp 200 Jt',
      originalPrice: 'Rp 250 Jt',
      image: 'assets/images/Innova_Reborn.png',
      onSale: false,
      rating: 4.2,
    ),
    Car(
      id: '6',
      name: 'Honda CR-V',
      price: 'Rp 650 Jt',
      originalPrice: 'Rp 800 Jt',
      image: 'assets/images/Pajero_Dakar.png',
      onSale: true,
      rating: 4.7,
    ),
    Car(
      id: '7',
      name: 'Mazda CX-5',
      price: 'Rp 500 Jt',
      originalPrice: 'Rp 650 Jt',
      image: 'assets/images/Altis_New.png',
      onSale: false,
      rating: 4.4,
    ),
    Car(
      id: '8',
      name: 'Nissan X-Trail',
      price: 'Rp 550 Jt',
      originalPrice: 'Rp 700 Jt',
      image: 'assets/images/Yaris_GR.png',
      onSale: true,
      rating: 4.5,
    ),
  ];
  static List<Car> searchCars(String query) {
    if (query.isEmpty) {
      return _allCars;
    }
    return _allCars
        .where((car) =>
            car.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  static List<Car> filterCars({
    required List<Car> cars,
    bool? onSaleOnly,
    double? maxPrice,
    String? sortBy,
  }) {
    var filtered = List<Car>.from(cars);
    if (onSaleOnly == true) {
      filtered = filtered.where((car) => car.onSale).toList();
    }
    if (maxPrice != null) {
      filtered = filtered.where((car) {
        final priceStr = car.price.replaceAll('\$', '').replaceAll(',', '');
        final price = double.tryParse(priceStr) ?? 0;
        return price <= maxPrice;
      }).toList();
    }
    if (sortBy == 'price_low') {
      filtered.sort((a, b) {
        final priceA =
            double.tryParse(a.price.replaceAll('\$', '').replaceAll(',', '')) ??
                0;
        final priceB =
            double.tryParse(b.price.replaceAll('\$', '').replaceAll(',', '')) ??
                0;
        return priceA.compareTo(priceB);
      });
    } else if (sortBy == 'price_high') {
      filtered.sort((a, b) {
        final priceA =
            double.tryParse(a.price.replaceAll('\$', '').replaceAll(',', '')) ??
                0;
        final priceB =
            double.tryParse(b.price.replaceAll('\$', '').replaceAll(',', '')) ??
                0;
        return priceB.compareTo(priceA);
      });
    } else if (sortBy == 'rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return filtered;
  }

  // ✅ Get all cars
  static List<Car> getAllCars() {
    return _allCars;
  }
}