import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/filter_entity.dart';
import '../../viewmodels/search/search_viewmodel.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _sortBy;
  late double _maxDistance;
  late double _minRating;
  late List<int> _priceRange;
  late List<String> _selectedCategories;

  final List<Map<String, String>> _sortOptions = [
    {'value': 'rating', 'label': 'Đánh giá cao nhất'},
    {'value': 'distance', 'label': 'Gần nhất'},
    {'value': 'popular', 'label': 'Phổ biến nhất'},
    {'value': 'newest', 'label': 'Mới nhất'},
  ];

  // BỘ TỪ ĐIỂN DỊCH MỨC GIÁ TỪ 1-4 SANG TIẾNG VIỆT
  final Map<int, String> _priceLabels = {
    1: 'Dưới 50k',
    2: '50k - 100k',
    3: '100k - 200k',
    4: 'Trên 200k',
  };

  @override
  void initState() {
    super.initState();
    final currentFilter = context.read<SearchViewModel>().activeFilter;
    _sortBy = currentFilter.sortBy;
    _maxDistance = currentFilter.maxDistance;
    _minRating = currentFilter.minRating;
    _priceRange = List.from(currentFilter.priceRange);
    _selectedCategories = List.from(currentFilter.categories);
  }

  void _reset() {
    setState(() {
      _sortBy = 'rating';
      _maxDistance = 10.0;
      _priceRange = [1, 4];
      _minRating = 0.0;
      _selectedCategories.clear();
    });
  }

  void _apply() {
    final newFilter = FilterEntity(
      sortBy: _sortBy,
      maxDistance: _maxDistance,
      minRating: _minRating,
      priceRange: _priceRange,
      categories: _selectedCategories,
    );
    context.read<SearchViewModel>().updateFilter(newFilter);
    Navigator.pop(context);
  }

  void _toggleCategory(String id) {
    setState(() {
      if (_selectedCategories.contains(id)) {
        _selectedCategories.remove(id);
      } else {
        _selectedCategories.add(id);
      }
    });
  }

  void _setPriceRange(int p) {
    setState(() {
      int min = _priceRange[0];
      int max = _priceRange[1];
      if (p == min && p == max) return;
      if (p < min) {
        _priceRange = [p, max];
      } else if (p > max) {
        _priceRange = [min, p];
      } else {
        _priceRange = [p, p];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Đọc danh sách Categories từ Firebase thông qua ViewModel
    final firebaseCategories = context.watch<SearchViewModel>().categories;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bộ lọc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.close, size: 16, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SẮP XẾP ---
                  _buildSectionTitle('Sắp xếp theo'),
                  GridView.count(
                    crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, shrinkWrap: true,
                    childAspectRatio: 3.5, physics: const NeverScrollableScrollPhysics(),
                    children: _sortOptions.map((opt) {
                      final isSelected = _sortBy == opt['value'];
                      return _buildCustomButton(
                        label: opt['label']!,
                        isSelected: isSelected,
                        onTap: () => setState(() => _sortBy = opt['value']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // --- DANH MỤC (Load từ Firebase) ---
                  _buildSectionTitle('Danh mục'),
                  if (firebaseCategories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: firebaseCategories.map((cat) {
                        final isSelected = _selectedCategories.contains(cat.id);
                        return GestureDetector(
                          onTap: () => _toggleCategory(cat.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
                              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat.icon, style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(cat.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? AppColors.primary : Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),

                  // --- KHOẢNG CÁCH ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Khoảng cách tối đa'),
                      Text('${_maxDistance.toStringAsFixed(1)} km', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(trackHeight: 4, activeTrackColor: AppColors.primary, inactiveTrackColor: Colors.grey.shade200, thumbColor: AppColors.primary),
                    child: Slider(
                      value: _maxDistance, min: 0.5, max: 20.0, divisions: 39,
                      onChanged: (val) => setState(() => _maxDistance = val),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0.5 km', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('20 km', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- MỨC GIÁ MỚI ---
                  _buildSectionTitle('Mức giá'),
                  GridView.count(
                    crossAxisCount: 2, // Đổi sang 2 cột để chữ hiển thị rõ ràng
                    crossAxisSpacing: 8, mainAxisSpacing: 8, shrinkWrap: true,
                    childAspectRatio: 3.5, physics: const NeverScrollableScrollPhysics(),
                    children: [1, 2, 3, 4].map((p) {
                      final isSelected = p >= _priceRange[0] && p <= _priceRange[1];
                      return _buildCustomButton(
                        label: _priceLabels[p]!, // Dùng từ điển để hiện "Dưới 50k", v.v...
                        isSelected: isSelected,
                        onTap: () => _setPriceRange(p),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // --- ĐÁNH GIÁ ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Đánh giá tối thiểu'),
                      Text(_minRating > 0 ? '$_minRating+' : 'Tất cả', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [0.0, 3.0, 3.5, 4.0, 4.5].map((r) {
                      final isSelected = _minRating == r;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: r == 4.5 ? 0 : 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _minRating = r),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
                                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: 1.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (r > 0) ...[const Icon(Icons.star, size: 12, color: Colors.amber), const SizedBox(width: 2)],
                                  Text(r == 0 ? 'Tất cả' : '$r', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // --- FOOTER ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F9FF), width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.lightBlue.shade200, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Đặt lại', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      elevation: 4, shadowColor: Colors.lightBlue.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Áp dụng', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildCustomButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? AppColors.primary : Colors.grey.shade600),
        ),
      ),
    );
  }
}