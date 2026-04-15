const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

// 1. Khởi tạo kết nối với Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 2. Toàn bộ dữ liệu của bạn
const IMAGES = {
  pho: 'https://images.unsplash.com/photo-1677011454858-8ecb6d4e6ce0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  banhmi: 'https://images.unsplash.com/photo-1763703686238-bb654515259c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  cafe: 'https://images.unsplash.com/photo-1764126675509-02fa46a774d4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  bunbo: 'https://images.unsplash.com/photo-1723561796007-2fcf547ec47d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  comtam: 'https://images.unsplash.com/photo-1743790769102-d0856d701466?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  hotpot: 'https://images.unsplash.com/photo-1715168438603-4dc3452f2f4d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  hanoi: 'https://images.unsplash.com/photo-1676047871081-733dc414cbac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
  modern: 'https://images.unsplash.com/photo-1773122150545-b160a4486216?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=800',
};

const categories = [
  { id: 'pho', name: 'Phở', nameEn: 'Pho', icon: '🍜', color: '#FF6B35', count: 124 },
  { id: 'comtam', name: 'Cơm tấm', nameEn: 'Broken Rice', icon: '🍚', color: '#4CAF50', count: 89 },
  { id: 'banhmi', name: 'Bánh mì', nameEn: 'Banh Mi', icon: '🥖', color: '#FF9800', count: 156 },
  { id: 'lau', name: 'Lẩu', nameEn: 'Hotpot', icon: '🫕', color: '#F44336', count: 67 },
  { id: 'cafe', name: 'Cà phê', nameEn: 'Cafe', icon: '☕', color: '#795548', count: 203 },
  { id: 'bunbo', name: 'Bún bò', nameEn: 'Beef Noodles', icon: '🍲', color: '#E91E63', count: 78 },
  { id: 'banh', name: 'Bánh ngọt', nameEn: 'Pastry', icon: '🧁', color: '#9C27B0', count: 45 },
  { id: 'nuoc', name: 'Nước uống', nameEn: 'Drinks', icon: '🧋', color: '#00BCD4', count: 112 },
  { id: 'pizza', name: 'Pizza', nameEn: 'Pizza', icon: '🍕', color: '#FF5722', count: 34 },
  { id: 'sushi', name: 'Sushi', nameEn: 'Sushi', icon: '🍱', color: '#3F51B5', count: 28 },
];

const restaurants = [
  {
    id: 'r1',
    name: 'Phở Thìn Lò Đúc',
    nameEn: 'Pho Thin Lo Duc',
    category: 'pho',
    categoryEn: 'Pho',
    cuisine: 'Phở',
    rating: 4.8,
    reviewCount: 2341,
    priceRange: 2,
    distance: 0.3,
    address: '13 Lò Đúc, Hai Bà Trưng, Hà Nội',
    addressEn: '13 Lo Duc, Hai Ba Trung, Hanoi',
    phone: '024 3821 9945',
    hours: '06:00 - 10:00',
    isOpen: true,
    image: IMAGES.pho,
    images: [IMAGES.pho, IMAGES.hanoi, IMAGES.modern],
    lat: 21.019,
    lng: 105.852,
    tags: ['Phở', 'Truyền thống', 'Sáng sớm', 'Nổi tiếng'],
    description: 'Quán phở truyền thống nổi tiếng Hà Nội, bát phở thơm ngon với nước dùng đậm đà từ xương bò hầm nhiều giờ.',
    descriptionEn: 'Famous traditional Hanoi pho restaurant, with rich broth simmered from beef bones for hours.',
    featured: true,
  },
  {
    id: 'r2',
    name: 'Bánh Mì Phượng',
    nameEn: 'Banh Mi Phuong',
    category: 'banhmi',
    categoryEn: 'Banh Mi',
    cuisine: 'Bánh mì',
    rating: 4.7,
    reviewCount: 1892,
    priceRange: 1,
    distance: 0.8,
    address: '2B Phan Chu Trinh, Hội An, Quảng Nam',
    addressEn: '2B Phan Chu Trinh, Hoi An, Quang Nam',
    phone: '0235 2241 517',
    hours: '06:30 - 21:30',
    isOpen: true,
    image: IMAGES.banhmi,
    images: [IMAGES.banhmi, IMAGES.cafe, IMAGES.hanoi],
    lat: 15.879,
    lng: 108.335,
    tags: ['Bánh mì', 'Hội An', 'Giá rẻ', 'Ngon'],
    description: 'Bánh mì Phượng nổi tiếng từ Hội An, được Bourdain từng ghé thăm. Nhân phong phú, vỏ bánh giòn rụm.',
    descriptionEn: 'Famous Hoi An banh mi, visited by Bourdain. Rich fillings, crispy crust.',
    featured: true,
  },
  {
    id: 'r3',
    name: 'The Workshop Coffee',
    nameEn: 'The Workshop Coffee',
    category: 'cafe',
    categoryEn: 'Cafe',
    cuisine: 'Cà phê',
    rating: 4.6,
    reviewCount: 987,
    priceRange: 3,
    distance: 1.2,
    address: '27 Ngô Đức Kế, Quận 1, TP.HCM',
    addressEn: '27 Ngo Duc Ke, District 1, HCMC',
    phone: '028 3824 6801',
    hours: '08:00 - 21:00',
    isOpen: true,
    image: IMAGES.cafe,
    images: [IMAGES.cafe, IMAGES.modern, IMAGES.banhmi],
    lat: 10.775,
    lng: 106.703,
    tags: ['Cà phê', 'Không gian đẹp', 'Làm việc', 'Hipster'],
    description: 'Quán cà phê phong cách công nghiệp tại quận 1, không gian rộng rãi, menu cà phê đa dạng chất lượng cao.',
    descriptionEn: 'Industrial-style coffee shop in District 1, spacious area, diverse high-quality coffee menu.',
    featured: true,
  },
  {
    id: 'r4',
    name: 'Bún Bò Huế Đông Ba',
    nameEn: 'Dong Ba Hue Beef Noodles',
    category: 'bunbo',
    categoryEn: 'Beef Noodles',
    cuisine: 'Bún bò',
    rating: 4.5,
    reviewCount: 756,
    priceRange: 2,
    distance: 1.5,
    address: '16 Nguyễn Sinh Cung, Huế',
    addressEn: '16 Nguyen Sinh Cung, Hue',
    phone: '0234 3823 148',
    hours: '07:00 - 20:00',
    isOpen: false,
    image: IMAGES.bunbo,
    images: [IMAGES.bunbo, IMAGES.hotpot, IMAGES.pho],
    lat: 16.468,
    lng: 107.594,
    tags: ['Bún bò', 'Huế', 'Cay', 'Truyền thống'],
    description: 'Bún bò Huế chuẩn vị, nước dùng cay đậm, chả heo, giò heo ngon. Đây là địa chỉ được yêu thích tại Huế.',
    descriptionEn: 'Authentic Hue-style beef noodle soup, spicy broth, pork cake, pork knuckle. A favorite in Hue.',
    featured: false,
  },
  {
    id: 'r5',
    name: 'Cơm Tấm Thuận Kiều',
    nameEn: 'Thuan Kieu Broken Rice',
    category: 'comtam',
    categoryEn: 'Broken Rice',
    cuisine: 'Cơm tấm',
    rating: 4.4,
    reviewCount: 1234,
    priceRange: 1,
    distance: 0.5,
    address: '136 Võ Văn Tần, Quận 3, TP.HCM',
    addressEn: '136 Vo Van Tan, District 3, HCMC',
    phone: '028 3932 7465',
    hours: '06:00 - 22:00',
    isOpen: true,
    image: IMAGES.comtam,
    images: [IMAGES.comtam, IMAGES.hanoi, IMAGES.modern],
    lat: 10.778,
    lng: 106.689,
    tags: ['Cơm tấm', 'Sườn nướng', 'Giá rẻ', 'Ngon'],
    description: 'Cơm tấm sườn bì chả đặc trưng Sài Gòn, mở cả ngày. Sườn nướng thơm, bì trộn dai, chả trứng mịn.',
    descriptionEn: 'Saigon-style broken rice with BBQ pork, pork skin, egg meatloaf. Open all day.',
    featured: false,
  },
  {
    id: 'r6',
    name: 'Lẩu Thái Mumuso',
    nameEn: 'Mumuso Thai Hotpot',
    category: 'lau',
    categoryEn: 'Hotpot',
    cuisine: 'Lẩu',
    rating: 4.3,
    reviewCount: 432,
    priceRange: 3,
    distance: 2.1,
    address: '45 Nguyễn Trãi, Quận 5, TP.HCM',
    addressEn: '45 Nguyen Trai, District 5, HCMC',
    phone: '028 3838 9012',
    hours: '11:00 - 23:00',
    isOpen: true,
    image: IMAGES.hotpot,
    images: [IMAGES.hotpot, IMAGES.modern, IMAGES.bunbo],
    lat: 10.761,
    lng: 106.682,
    tags: ['Lẩu', 'Thái', 'Chua cay', 'Buffet'],
    description: 'Lẩu Thái buffet cao cấp với nước dùng chua cay đặc trưng, hải sản tươi, thịt bò Úc và rau sạch đa dạng.',
    descriptionEn: 'Premium Thai hotpot buffet with signature spicy broth, fresh seafood, Australian beef and organic vegetables.',
    featured: false,
  },
  {
    id: 'r7',
    name: 'Nhà Hàng Ngon',
    nameEn: 'Ngon Restaurant',
    category: 'pho', // Dùng tạm 'pho' do bên trên bạn để vậy
    categoryEn: 'Vietnamese',
    cuisine: 'Ẩm thực Việt',
    rating: 4.6,
    reviewCount: 3210,
    priceRange: 3,
    distance: 1.8,
    address: '160 Pasteur, Quận 3, TP.HCM',
    addressEn: '160 Pasteur, District 3, HCMC',
    phone: '028 3827 7131',
    hours: '07:00 - 22:30',
    isOpen: true,
    image: IMAGES.hanoi,
    images: [IMAGES.hanoi, IMAGES.comtam, IMAGES.cafe],
    lat: 10.780,
    lng: 106.697,
    tags: ['Ẩm thực Việt', 'Sân vườn', 'Đặc sản', 'Gia đình'],
    description: 'Nhà hàng Ngon với không gian sân vườn rộng, phục vụ hơn 50 món ăn Việt Nam đặc trưng ba miền.',
    descriptionEn: 'Restaurant Ngon with wide garden setting, serving over 50 signature Vietnamese dishes from all regions.',
    featured: true,
  },
  {
    id: 'r8',
    name: 'Bếp Quê Xưa',
    nameEn: 'Old Countryside Kitchen',
    category: 'comtam', // Dùng tạm
    categoryEn: 'Vietnamese',
    cuisine: 'Ẩm thực truyền thống',
    rating: 4.2,
    reviewCount: 289,
    priceRange: 2,
    distance: 3.2,
    address: '78 Trần Hưng Đạo, Quận 1, TP.HCM',
    addressEn: '78 Tran Hung Dao, District 1, HCMC',
    phone: '028 3836 1234',
    hours: '10:00 - 21:00',
    isOpen: false,
    image: IMAGES.modern,
    images: [IMAGES.modern, IMAGES.comtam, IMAGES.pho],
    lat: 10.769,
    lng: 106.700,
    tags: ['Truyền thống', 'Quê nhà', 'Giá rẻ'],
    description: 'Quán ăn mang phong cách nhà quê, các món ăn dân dã Việt Nam, nguyên liệu tươi sạch mỗi ngày.',
    descriptionEn: 'Restaurant with countryside style, rustic Vietnamese dishes, fresh ingredients daily.',
    featured: false,
  },
];

const reviews = [
  {
    id: 'rv1',
    restaurantId: 'r1',
    userId: 'u2',
    userName: 'Nguyễn Minh Tuấn',
    userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Tuan',
    rating: 5,
    text: 'Phở ngon tuyệt vời! Nước dùng đậm đà, thịt bò mềm. Đây là quán phở số 1 tôi từng ăn ở Hà Nội. Sẽ quay lại nhiều lần nữa.',
    images: [IMAGES.pho],
    date: '2026-03-20',
    helpful: 45,
    categories: { food: 5, service: 4, ambiance: 3, value: 5 },
  },
  {
    id: 'rv2',
    restaurantId: 'r1',
    userId: 'u3',
    userName: 'Trần Thị Lan',
    userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Lan',
    rating: 4,
    text: 'Phở chuẩn vị Hà Nội, xếp hàng khá lâu nhưng xứng đáng. Giờ mở cửa ngắn nên cần đến sớm.',
    images: [],
    date: '2026-03-15',
    helpful: 28,
    categories: { food: 5, service: 3, ambiance: 3, value: 4 },
  },
  {
    id: 'rv3',
    restaurantId: 'r1',
    userId: 'u4',
    userName: 'Lê Văn Hùng',
    userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Hung',
    rating: 5,
    text: 'Bát phở lớn, nước trong, thịt bò tái chín vừa. Quán đông khách, phục vụ nhanh. Giá hợp lý.',
    images: [IMAGES.hanoi],
    date: '2026-03-10',
    helpful: 19,
    categories: { food: 5, service: 4, ambiance: 4, value: 5 },
  },
  {
    id: 'rv4',
    restaurantId: 'r2',
    userId: 'u2',
    userName: 'Nguyễn Minh Tuấn',
    userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Tuan',
    rating: 5,
    text: 'Bánh mì ngon nhất Hội An! Vỏ bánh giòn, nhân đầy. Được thế giới công nhận, xứng đáng 5 sao.',
    images: [IMAGES.banhmi],
    date: '2026-03-18',
    helpful: 62,
    categories: { food: 5, service: 5, ambiance: 4, value: 5 },
  },
];

const notifications = [
  { id: 'n1', type: 'promo', title: 'Ưu đãi hôm nay', titleEn: "Today's Deal", body: 'Phở Thìn Lò Đúc giảm 20% cho đơn từ 100k. Chỉ hôm nay!', bodyEn: 'Pho Thin Lo Duc 20% off orders over 100k. Today only!', time: '09:00', read: false, icon: '🎉' },
  { id: 'n2', type: 'review', title: 'Đánh giá được thích', titleEn: 'Review Liked', body: '12 người thấy đánh giá của bạn về Bánh Mì Phượng hữu ích.', bodyEn: '12 people found your review of Banh Mi Phuong helpful.', time: 'Hôm qua', read: false, icon: '👍' },
  { id: 'n3', type: 'bookmark', title: 'Quán mở cửa rồi!', titleEn: 'Restaurant is Open!', body: 'Bún Bò Huế Đông Ba bạn đã lưu vừa mở cửa trở lại.', bodyEn: 'Dong Ba Hue Beef Noodles you saved has just reopened.', time: '2 ngày trước', read: true, icon: '🔖' },
  { id: 'n4', type: 'system', title: 'Cập nhật ứng dụng', titleEn: 'App Update', body: 'Phiên bản 2.1.0 đã có sẵn với nhiều tính năng mới.', bodyEn: 'Version 2.1.0 is available with many new features.', time: '3 ngày trước', read: true, icon: '📱' },
  { id: 'n5', type: 'promo', title: 'Quán mới gần bạn', titleEn: 'New Restaurant Nearby', body: 'Lẩu Thái Mumuso vừa khai trương cách bạn 2km. Khám phá ngay!', bodyEn: 'Mumuso Thai Hotpot just opened 2km from you. Explore now!', time: '1 tuần trước', read: true, icon: '🆕' },
];

const offlineAreas = [
  { id: 'oa1', name: 'TP. Hồ Chí Minh', nameEn: 'Ho Chi Minh City', size: '24 MB', restaurants: 1240, downloaded: true, progress: 100 },
  { id: 'oa2', name: 'Hà Nội', nameEn: 'Hanoi', size: '18 MB', restaurants: 987, downloaded: false, progress: 0 },
  { id: 'oa3', name: 'Đà Nẵng', nameEn: 'Da Nang', size: '9 MB', restaurants: 456, downloaded: false, progress: 60 },
  { id: 'oa4', name: 'Hội An', nameEn: 'Hoi An', size: '5 MB', restaurants: 234, downloaded: true, progress: 100 },
];

const configs = [
  {
    id: 'filterSettings',
    sortOptions: [
      { value: 'rating', label: 'Đánh giá cao nhất', labelEn: 'Highest Rating' },
      { value: 'distance', label: 'Gần nhất', labelEn: 'Nearest' },
      { value: 'popular', label: 'Phổ biến nhất', labelEn: 'Most Popular' },
      { value: 'newest', label: 'Mới nhất', labelEn: 'Newest' },
    ],
    distanceSettings: {
      min: 0.5,
      max: 20.0,
      defaultMax: 10.0,
      step: 0.5
    },
    priceSettings: {
      min: 1,
      max: 4
    },
    ratingOptions: [0.0, 3.0, 3.5, 4.0, 4.5]
  }
];

// THÊM MỚI: Danh sách người dùng cần tạo
const users = [
  {
    uid: 'u1',
    email: 'demo@foodie.vn',
    password: 'password123', // Mật khẩu thật để bạn test đăng nhập
    displayName: 'Người Dùng Demo',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=demo'
  },
  {
    uid: 'u3',
    email: 'huyleedinh@gmail.com',
    password: '123456',
    displayName: 'Lê Đình Huy',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Huy'
  }
];

// Hàm tạo User Authentication và Firestore Profile
async function seedUsers() {
  console.log('Đang tạo tài khoản người dùng...');
  for (const u of users) {
    try {
      // 1. Tạo tài khoản đăng nhập (Auth)
      await admin.auth().createUser({
        uid: u.uid,
        email: u.email,
        password: u.password,
        displayName: u.displayName,
      });

      // 2. Lưu thông tin hồ sơ vào bảng 'users' (Firestore)
      await db.collection('users').doc(u.uid).set({
        email: u.email,
        displayName: u.displayName,
        avatar: u.avatar,
        role: 'user',
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });
      console.log(`✅ Đã tạo tài khoản: ${u.email}`);
    } catch (error) {
      if (error.code === 'auth/uid-already-exists' || error.code === 'auth/email-already-exists') {
        console.log(`⏩ Bỏ qua ${u.email} (Đã tồn tại)`);
      } else {
        console.error(`❌ Lỗi tạo user ${u.email}:`, error);
      }
    }
  }
}
// 3. Hàm đẩy dữ liệu tự động (Dùng Async/Await)
async function seedData(collectionName, dataArray) {
  console.log(`Đang đẩy dữ liệu lên collection: ${collectionName}...`);

  const promises = dataArray.map(item => {
    return db.collection(collectionName).doc(item.id).set(item);
  });

  await Promise.all(promises);
  console.log(`✅ Hoàn tất collection: ${collectionName}`);
}

// 4. Kích hoạt chạy tất cả các bảng dữ liệu
async function runSeeder() {
  try {
    await seedUsers();
    await seedData('categories', categories);
    await seedData('restaurants', restaurants);
    await seedData('configs', configs);
    await seedData('reviews', reviews);
    await seedData('notifications', notifications);
    await seedData('offlineAreas', offlineAreas);

    console.log("🎉🎉🎉 ĐÃ ĐẨY TOÀN BỘ DỮ LIỆU LÊN FIREBASE THÀNH CÔNG!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Có lỗi xảy ra:", error);
    process.exit(1);
  }
}

runSeeder();