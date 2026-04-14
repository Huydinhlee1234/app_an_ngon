import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../viewmodels/search/search_viewmodel.dart';
import '../shared_widgets/restaurant_card.dart';
import '../home/restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<SearchViewModel>(
                builder: (context, viewModel, child) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: viewModel.query.isEmpty
                          ? _buildIdleState(viewModel)
                          : _buildSearchingState(viewModel),
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

  Widget _buildHeader(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F9FF), width: 1)),
      ),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Navigator.pop(context),
          //   child: Container(
          //     width: 36, height: 36,
          //     decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(18)),
          //     child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.primary),
          //   ),
          // ),
          // const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _textController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (val) => viewModel.setQuery(val),
              onSubmitted: (val) => viewModel.submitSearch(val),
              decoration: InputDecoration(
                hintText: 'Tìm quán ăn, món...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                suffixIcon: Consumer<SearchViewModel>(
                  builder: (context, vm, _) => vm.query.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    onPressed: () {
                      _textController.clear();
                      viewModel.setQuery('');
                    },
                  )
                      : const SizedBox.shrink(),
                ),
                filled: true,
                fillColor: const Color(0xFFF0F9FF),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Consumer<SearchViewModel>(
              builder: (context, vm, _) {
                final hasFilters = vm.activeFilter.hasActiveFilters;
                return Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: hasFilters ? AppColors.primary : const Color(0xFFF0F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.tune, size: 18, color: hasFilters ? Colors.white : AppColors.primary),
                );
              }
          ),
        ],
      ),
    );
  }

  Widget _buildIdleState(SearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        if (viewModel.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Tìm kiếm gần đây', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              GestureDetector(
                onTap: () => viewModel.clearRecentSearches(),
                child: const Text('Xóa tất cả', style: TextStyle(color: AppColors.primary, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: viewModel.recentSearches.map((s) => ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.primary)),
              backgroundColor: const Color(0xFFF0F9FF),
              side: BorderSide.none,
              onPressed: () {
                _textController.text = s;
                viewModel.submitSearch(s);
              },
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],

        Row(
          children: const [
            Icon(Icons.trending_up, size: 16, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Xu hướng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: viewModel.trendingSuggestions.map((s) => ActionChip(
            label: Text('🔥 $s', style: const TextStyle(fontSize: 13, color: AppColors.primary)),
            backgroundColor: const Color(0xFFF0F9FF),
            side: BorderSide.none,
            onPressed: () {
              _textController.text = s;
              viewModel.submitSearch(s);
            },
          )).toList(),
        ),
        const SizedBox(height: 32),
        const Text('Tất cả quán ăn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        _buildResultList(viewModel.searchResults),
      ],
    );
  }

  Widget _buildSearchingState(SearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            children: [
              TextSpan(text: '${viewModel.searchResults.length} kết quả cho '),
              TextSpan(text: '"${viewModel.query}"', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (viewModel.searchResults.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 64),
            child: Center(
              child: Column(
                children: [
                  Text('🔍', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 16),
                  Text('Không tìm thấy kết quả', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          )
        else
          _buildResultList(viewModel.searchResults),
      ],
    );
  }

  Widget _buildResultList(List<RestaurantEntity> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RestaurantCard(
            restaurant: list[index],
            isSaved: false,
            onBookmarkToggle: () {},
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurant: list[index]))),
          ),
        );
      },
    );
  }
}