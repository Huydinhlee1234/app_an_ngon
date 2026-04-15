import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../../viewmodels/home/restaurant_viewmodel.dart';
import '../search/filter_bottom_sheet.dart';
import '../search/search_page.dart';
import '../shared_widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantViewModel>(context, listen: false).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<RestaurantViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.restaurants.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.errorMessage != null && viewModel.restaurants.isEmpty) {
            return Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)));
          }

          final aiPicks = viewModel.restaurants.take(3).toList();
          final nearby = viewModel.restaurants.skip(2).take(4).toList();
          final topRated = viewModel.restaurants;

          return RefreshIndicator(
            onRefresh: () => viewModel.loadInitialData(),
            child: CustomScrollView(                          // ✅ Thay SingleChildScrollView → CustomScrollView
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                if (viewModel.categories.isNotEmpty)
                  SliverToBoxAdapter(child: _buildCategorySection(viewModel)),
                if (aiPicks.isNotEmpty)
                  SliverToBoxAdapter(child: _buildAIPicksSection(aiPicks)),
                if (nearby.isNotEmpty)
                  SliverToBoxAdapter(child: _buildNearbyHeader()),
                if (nearby.isNotEmpty)
                  _buildNearbyGrid(nearby),               // ✅ SliverGrid thay GridView
                if (topRated.isNotEmpty)
                  SliverToBoxAdapter(child: _buildTopRatedHeader()),
                if (topRated.isNotEmpty)
                  _buildTopRatedList(topRated),            // ✅ SliverList thay ListView
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 64, bottom: 24, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Xin chào 👋',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                      Text(authVM.currentUser?.displayName ?? 'Khách',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Text('2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white.withValues(alpha: 0.8), size: 16),
                  const SizedBox(width: 4),
                  Text('TP. Hồ Chí Minh, Quận 1',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(16),
              //       boxShadow: [
              //         BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)
              //       ]),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.search, color: Colors.grey, size: 20),
              //       const SizedBox(width: 12),
              //       const Expanded(
              //           child: Text('Tìm quán ăn, món ăn...',
              //               style: TextStyle(color: Colors.grey, fontSize: 14))),
              //       Container(
              //         padding: const EdgeInsets.all(6),
              //         decoration: BoxDecoration(
              //             color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              //         child: const Icon(Icons.tune, color: Colors.white, size: 16),
              //       )
              //     ],
              //   ),
              // ),
              // ... Đoạn mã location_on giữ nguyên phía trên

              // THANH TÌM KIẾM TRÊN HOME PAGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)
                    ]),
                child: Row(
                  children: [
                    // Bấm vào khu vực chữ/kính lúp -> Nhảy sang SearchPage
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque, // Giúp vùng bấm nhạy hơn
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: Colors.grey, size: 20),
                            SizedBox(width: 12),
                            Text('Tìm quán ăn, món ăn...', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    // Bấm vào nút Tune -> Mở thẳng BottomSheet Filter
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FilterBottomSheet(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.tune, color: Colors.white, size: 16),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(RestaurantViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Danh mục',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('Xem tất cả',
                  style: TextStyle(
                      color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final cat = viewModel.categories[index];
              Color catColor = Colors.grey;
              try {
                catColor = Color(int.parse(cat.color.replaceFirst('#', '0xFF')));
              } catch (_) {}

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.center,
                      child: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(height: 8),
                    Text(cat.name,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAIPicksSection(List aiPicks) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF0F9FF), Color(0xFFEEF2FF)])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.auto_awesome, color: Colors.indigo, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('AI Gợi ý cho bạn',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: aiPicks.length,
              itemBuilder: (context, index) => SizedBox(
                width: 260,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RestaurantCard(
                    restaurant: aiPicks[index],
                    isSaved: false,
                    onBookmarkToggle: () {},
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurant: aiPicks[index]))),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ Tách header "Gần bạn" ra riêng
  Widget _buildNearbyHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Gần bạn',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const Text('Xem bản đồ',
              style: TextStyle(
                  color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ✅ SliverGrid thay thế GridView lồng trong ScrollView
  Widget _buildNearbyGrid(List nearby) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => RestaurantCard(
            restaurant: nearby[index],
            isSaved: false,
            onBookmarkToggle: () {},
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurant: nearby[index]))),
          ),
          childCount: nearby.length,
        ),
      ),
    );
  }

  // ✅ Tách header "Top rated" ra riêng
  Widget _buildTopRatedHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Text('⭐ Đánh giá cao nhất',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  // ✅ SliverList thay thế ListView lồng trong ScrollView
  Widget _buildTopRatedList(List topRated) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RestaurantCard(
              restaurant: topRated[index],
              isSaved: false,
              onBookmarkToggle: () {},
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurant: topRated[index]))),
            ),
          ),
          childCount: topRated.length,
        ),
      ),
    );
  }
}