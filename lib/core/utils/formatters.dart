class Formatters {
  // Hàm chuyển đổi số 1-4 thành chuỗi tiền tệ (VD: 2 -> '₫₫')
  static String priceRangeToSymbol(int range) {
    if (range < 1) return '₫';
    if (range > 4) return '₫₫₫₫';
    return '₫' * range;
  }

  // Hàm định dạng khoảng cách (Ví dụ: 1.2345 km -> 1.2 km)
  static String formatDistance(double distance) {
    return '${distance.toStringAsFixed(1)} km';
  }
}