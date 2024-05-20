enum Category {
  pants,
  shirts,
  dresses,
  bags,
  accessories,
  shoes,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.pants:
        return 'Pants';
      case Category.shirts:
        return 'Shirts';
      case Category.dresses:
        return 'Dresses';
      case Category.bags:
        return 'Bags';
      case Category.accessories:
        return 'Accessories';
      case Category.shoes:
        return 'Shoes';
      default:
        return '';
    }
  }

  static Category fromString(String category) {
    switch (category) {
      case 'Pants':
        return Category.pants;
      case 'Shirts':
        return Category.shirts;
      case 'Dresses':
        return Category.dresses;
      case 'Bags':
        return Category.bags;
      case 'Accessories':
        return Category.accessories;
      case 'Shoes':
        return Category.shoes;
      default:
        throw Exception('Unknown category: $category');
    }
  }
}
