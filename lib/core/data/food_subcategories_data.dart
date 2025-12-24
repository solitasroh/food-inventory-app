import '../../features/inventory/domain/entities/enums.dart';
import 'food_subcategory.dart';

/// 신선식품 보관기간 데이터베이스
/// 출처: 식품안전나라, 식약처 가이드라인
const List<FoodSubCategory> foodSubCategories = [
  // ===== 육류 (meat) =====
  FoodSubCategory(
    id: 'meat_ground',
    name: '다진고기',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 90,
    },
    keywords: ['다짐육', '간고기', '민스', '햄버거패티'],
  ),
  FoodSubCategory(
    id: 'meat_beef_steak',
    name: '소고기(스테이크)',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 180,
    },
    keywords: ['스테이크', '등심', '안심', '채끝', '소고기'],
  ),
  FoodSubCategory(
    id: 'meat_beef_slice',
    name: '소고기(불고기용)',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 120,
    },
    keywords: ['불고기', '차돌박이', '국거리', '소고기'],
  ),
  FoodSubCategory(
    id: 'meat_pork',
    name: '돼지고기',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 120,
    },
    keywords: ['삼겹살', '목살', '앞다리', '뒷다리', '돼지'],
  ),
  FoodSubCategory(
    id: 'meat_pork_belly',
    name: '삼겹살',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 30,
    },
    keywords: ['삼겹', '오겹살', '대패삼겹살'],
  ),
  FoodSubCategory(
    id: 'meat_chicken',
    name: '닭고기',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 365,
    },
    keywords: ['치킨', '닭', '닭가슴살', '닭다리', '닭날개', '닭볶음탕'],
  ),
  FoodSubCategory(
    id: 'meat_duck',
    name: '오리고기',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 180,
    },
    keywords: ['오리', '훈제오리'],
  ),
  FoodSubCategory(
    id: 'meat_lamb',
    name: '양고기',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 180,
    },
    keywords: ['양', '램', '양갈비'],
  ),
  FoodSubCategory(
    id: 'meat_processed',
    name: '햄/소시지',
    parentCategory: FoodCategory.meat,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 60,
    },
    keywords: ['햄', '소시지', '베이컨', '프랑크', '비엔나'],
  ),

  // ===== 해산물 (seafood) =====
  FoodSubCategory(
    id: 'seafood_fish_raw',
    name: '생선(생것)',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 30,
    },
    keywords: ['생선', '회', '고등어', '갈치', '조기', '삼치'],
  ),
  FoodSubCategory(
    id: 'seafood_fish_salted',
    name: '생선(절인것)',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 4,
      StorageLocation.freezer: 365,
    },
    keywords: ['자반', '간고등어', '굴비', '절임생선'],
  ),
  FoodSubCategory(
    id: 'seafood_shrimp',
    name: '새우',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 180,
    },
    keywords: ['새우', '대하', '흰다리새우', '블랙타이거'],
  ),
  FoodSubCategory(
    id: 'seafood_squid',
    name: '오징어',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 90,
    },
    keywords: ['오징어', '한치', '낙지', '문어', '주꾸미'],
  ),
  FoodSubCategory(
    id: 'seafood_shellfish',
    name: '조개류',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 30,
    },
    keywords: ['조개', '바지락', '모시조개', '홍합', '전복', '굴'],
  ),
  FoodSubCategory(
    id: 'seafood_crab',
    name: '게',
    parentCategory: FoodCategory.seafood,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 90,
    },
    keywords: ['게', '꽃게', '대게', '킹크랩', '홍게'],
  ),

  // ===== 채소 (vegetables) =====
  FoodSubCategory(
    id: 'veg_leafy',
    name: '잎채소',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 30,
    },
    keywords: ['시금치', '상추', '청경채', '깻잎', '부추', '미나리', '쑥갓'],
  ),
  FoodSubCategory(
    id: 'veg_cabbage',
    name: '양배추',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.freezer: 30,
    },
    keywords: ['양배추', '적양배추', '방울양배추'],
  ),
  FoodSubCategory(
    id: 'veg_napa_cabbage',
    name: '배추',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.freezer: 30,
    },
    keywords: ['배추', '알배추', '쌈배추'],
  ),
  FoodSubCategory(
    id: 'veg_carrot',
    name: '당근',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.freezer: 30,
    },
    keywords: ['당근', '미니당근'],
  ),
  FoodSubCategory(
    id: 'veg_onion',
    name: '양파',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.freezer: 30,
      StorageLocation.pantry: 30,
    },
    keywords: ['양파', '자색양파', '적양파'],
  ),
  FoodSubCategory(
    id: 'veg_green_onion',
    name: '대파',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.freezer: 30,
    },
    keywords: ['대파', '쪽파', '파'],
  ),
  FoodSubCategory(
    id: 'veg_garlic',
    name: '마늘',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.pantry: 30,
    },
    keywords: ['마늘', '깐마늘', '다진마늘'],
  ),
  FoodSubCategory(
    id: 'veg_ginger',
    name: '생강',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 21,
      StorageLocation.freezer: 180,
    },
    keywords: ['생강', '편생강'],
  ),
  FoodSubCategory(
    id: 'veg_potato',
    name: '감자',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.pantry: 21,
    },
    keywords: ['감자', '알감자', '수미감자'],
  ),
  FoodSubCategory(
    id: 'veg_sweet_potato',
    name: '고구마',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.pantry: 30,
    },
    keywords: ['고구마', '밤고구마', '호박고구마'],
  ),
  FoodSubCategory(
    id: 'veg_radish',
    name: '무',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.freezer: 30,
    },
    keywords: ['무', '알타리무', '총각무', '열무'],
  ),
  FoodSubCategory(
    id: 'veg_cucumber',
    name: '오이',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
    },
    keywords: ['오이', '백오이', '취청오이', '가시오이'],
  ),
  FoodSubCategory(
    id: 'veg_zucchini',
    name: '애호박',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 30,
    },
    keywords: ['애호박', '호박', '주키니'],
  ),
  FoodSubCategory(
    id: 'veg_eggplant',
    name: '가지',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
    },
    keywords: ['가지'],
  ),
  FoodSubCategory(
    id: 'veg_pepper',
    name: '고추',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 180,
    },
    keywords: ['고추', '청양고추', '오이고추', '풋고추', '홍고추'],
  ),
  FoodSubCategory(
    id: 'veg_bell_pepper',
    name: '파프리카',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.freezer: 30,
    },
    keywords: ['파프리카', '피망'],
  ),
  FoodSubCategory(
    id: 'veg_tomato',
    name: '토마토',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.pantry: 5,
    },
    keywords: ['토마토', '방울토마토', '대추토마토'],
  ),
  FoodSubCategory(
    id: 'veg_broccoli',
    name: '브로콜리',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 30,
    },
    keywords: ['브로콜리', '콜리플라워'],
  ),
  FoodSubCategory(
    id: 'veg_mushroom',
    name: '버섯',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 30,
    },
    keywords: ['버섯', '새송이', '팽이', '표고', '느타리', '양송이', '목이버섯'],
  ),
  FoodSubCategory(
    id: 'veg_bean_sprout',
    name: '콩나물/숙주',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
    },
    keywords: ['콩나물', '숙주', '숙주나물'],
  ),
  FoodSubCategory(
    id: 'veg_tofu',
    name: '두부',
    parentCategory: FoodCategory.vegetables,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 90,
    },
    keywords: ['두부', '순두부', '연두부', '부침두부'],
  ),

  // ===== 과일 (fruits) =====
  FoodSubCategory(
    id: 'fruit_apple',
    name: '사과',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 30,
      StorageLocation.pantry: 7,
    },
    keywords: ['사과', '부사', '홍로', '아오리'],
  ),
  FoodSubCategory(
    id: 'fruit_pear',
    name: '배',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 30,
      StorageLocation.pantry: 7,
    },
    keywords: ['배', '신고배', '원황배'],
  ),
  FoodSubCategory(
    id: 'fruit_banana',
    name: '바나나',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.pantry: 5,
    },
    keywords: ['바나나'],
  ),
  FoodSubCategory(
    id: 'fruit_orange',
    name: '오렌지/귤',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 21,
      StorageLocation.pantry: 7,
    },
    keywords: ['오렌지', '귤', '한라봉', '천혜향', '레드향', '감귤'],
  ),
  FoodSubCategory(
    id: 'fruit_grape',
    name: '포도',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 30,
    },
    keywords: ['포도', '청포도', '거봉', '샤인머스캣', '캠벨'],
  ),
  FoodSubCategory(
    id: 'fruit_strawberry',
    name: '딸기',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 30,
    },
    keywords: ['딸기', '설향'],
  ),
  FoodSubCategory(
    id: 'fruit_blueberry',
    name: '블루베리',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.freezer: 180,
    },
    keywords: ['블루베리', '라즈베리', '베리'],
  ),
  FoodSubCategory(
    id: 'fruit_watermelon',
    name: '수박',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.pantry: 7,
    },
    keywords: ['수박', '애플수박'],
  ),
  FoodSubCategory(
    id: 'fruit_melon',
    name: '멜론/참외',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.pantry: 5,
    },
    keywords: ['멜론', '참외', '머스크멜론'],
  ),
  FoodSubCategory(
    id: 'fruit_peach',
    name: '복숭아',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.pantry: 3,
    },
    keywords: ['복숭아', '천도복숭아', '백도', '황도'],
  ),
  FoodSubCategory(
    id: 'fruit_persimmon',
    name: '감',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
      StorageLocation.freezer: 90,
      StorageLocation.pantry: 7,
    },
    keywords: ['감', '단감', '홍시', '곶감'],
  ),
  FoodSubCategory(
    id: 'fruit_kiwi',
    name: '키위',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 21,
      StorageLocation.pantry: 7,
    },
    keywords: ['키위', '골드키위', '그린키위'],
  ),
  FoodSubCategory(
    id: 'fruit_mango',
    name: '망고',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 90,
    },
    keywords: ['망고', '애플망고'],
  ),
  FoodSubCategory(
    id: 'fruit_avocado',
    name: '아보카도',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.pantry: 5,
    },
    keywords: ['아보카도'],
  ),
  FoodSubCategory(
    id: 'fruit_lemon',
    name: '레몬/라임',
    parentCategory: FoodCategory.fruits,
    shelfLifeDays: {
      StorageLocation.refrigerator: 30,
      StorageLocation.pantry: 7,
    },
    keywords: ['레몬', '라임', '유자'],
  ),

  // ===== 유제품 (dairy) =====
  FoodSubCategory(
    id: 'dairy_milk',
    name: '우유',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
    },
    keywords: ['우유', '저지방우유', '무지방우유', '흰우유'],
  ),
  FoodSubCategory(
    id: 'dairy_yogurt',
    name: '요거트',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
    },
    keywords: ['요거트', '요구르트', '그릭요거트', '플레인요거트', '떠먹는요거트'],
  ),
  FoodSubCategory(
    id: 'dairy_cheese',
    name: '치즈',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 30,
      StorageLocation.freezer: 180,
    },
    keywords: ['치즈', '슬라이스치즈', '모짜렐라', '체다', '크림치즈'],
  ),
  FoodSubCategory(
    id: 'dairy_butter',
    name: '버터',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 90,
      StorageLocation.freezer: 180,
    },
    keywords: ['버터', '무염버터', '가염버터'],
  ),
  FoodSubCategory(
    id: 'dairy_egg',
    name: '달걀',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 35,
    },
    keywords: ['달걀', '계란', '유정란', '무정란'],
  ),
  FoodSubCategory(
    id: 'dairy_cream',
    name: '생크림',
    parentCategory: FoodCategory.dairy,
    shelfLifeDays: {
      StorageLocation.refrigerator: 10,
      StorageLocation.freezer: 90,
    },
    keywords: ['생크림', '휘핑크림', '쿠킹크림'],
  ),

  // ===== 곡류 (grains) =====
  FoodSubCategory(
    id: 'grain_rice',
    name: '쌀',
    parentCategory: FoodCategory.grains,
    shelfLifeDays: {
      StorageLocation.refrigerator: 180,
      StorageLocation.pantry: 90,
    },
    keywords: ['쌀', '백미', '현미', '잡곡'],
  ),
  FoodSubCategory(
    id: 'grain_cooked_rice',
    name: '밥(조리된)',
    parentCategory: FoodCategory.grains,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
      StorageLocation.freezer: 30,
    },
    keywords: ['밥', '즉석밥', '잡곡밥', '현미밥'],
  ),
  FoodSubCategory(
    id: 'grain_noodle',
    name: '면류(생면)',
    parentCategory: FoodCategory.grains,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 90,
    },
    keywords: ['생면', '우동면', '라면사리', '칼국수면', '수제비'],
  ),
  FoodSubCategory(
    id: 'grain_bread',
    name: '빵',
    parentCategory: FoodCategory.grains,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 90,
      StorageLocation.pantry: 3,
    },
    keywords: ['빵', '식빵', '모닝빵', '바게트', '크로와상'],
  ),
  FoodSubCategory(
    id: 'grain_cake',
    name: '케이크',
    parentCategory: FoodCategory.grains,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 30,
    },
    keywords: ['케이크', '생크림케이크', '치즈케이크', '롤케이크'],
  ),

  // ===== 조미료 (seasonings) =====
  FoodSubCategory(
    id: 'season_soy_sauce',
    name: '간장',
    parentCategory: FoodCategory.seasonings,
    shelfLifeDays: {
      StorageLocation.refrigerator: 365,
      StorageLocation.pantry: 180,
    },
    keywords: ['간장', '진간장', '국간장', '양조간장'],
  ),
  FoodSubCategory(
    id: 'season_doenjang',
    name: '된장',
    parentCategory: FoodCategory.seasonings,
    shelfLifeDays: {
      StorageLocation.refrigerator: 365,
    },
    keywords: ['된장', '재래된장', '쌈장'],
  ),
  FoodSubCategory(
    id: 'season_gochujang',
    name: '고추장',
    parentCategory: FoodCategory.seasonings,
    shelfLifeDays: {
      StorageLocation.refrigerator: 365,
    },
    keywords: ['고추장', '초고추장', '찹쌀고추장'],
  ),
  FoodSubCategory(
    id: 'season_sesame_oil',
    name: '참기름/들기름',
    parentCategory: FoodCategory.seasonings,
    shelfLifeDays: {
      StorageLocation.refrigerator: 180,
      StorageLocation.pantry: 90,
    },
    keywords: ['참기름', '들기름', '향기름'],
  ),

  // ===== 가공식품 (processed) =====
  FoodSubCategory(
    id: 'proc_kimchi',
    name: '김치',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 30,
      StorageLocation.freezer: 90,
    },
    keywords: ['김치', '배추김치', '깍두기', '총각김치', '열무김치', '파김치'],
  ),
  FoodSubCategory(
    id: 'proc_banchan',
    name: '반찬(나물류)',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 30,
    },
    keywords: ['나물', '시금치나물', '콩나물무침', '무나물'],
  ),
  FoodSubCategory(
    id: 'proc_banchan_stir',
    name: '반찬(볶음류)',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 5,
      StorageLocation.freezer: 30,
    },
    keywords: ['볶음', '어묵볶음', '멸치볶음', '감자볶음', '소시지볶음'],
  ),
  FoodSubCategory(
    id: 'proc_banchan_jorim',
    name: '반찬(조림류)',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
      StorageLocation.freezer: 30,
    },
    keywords: ['조림', '장조림', '감자조림', '연근조림', '두부조림'],
  ),
  FoodSubCategory(
    id: 'proc_soup',
    name: '국/찌개',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 30,
    },
    keywords: ['국', '찌개', '된장찌개', '김치찌개', '미역국', '육개장'],
  ),
  FoodSubCategory(
    id: 'proc_stew',
    name: '탕/전골',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 3,
      StorageLocation.freezer: 30,
    },
    keywords: ['탕', '전골', '감자탕', '설렁탕', '곰탕', '삼계탕'],
  ),
  FoodSubCategory(
    id: 'proc_salad',
    name: '샐러드',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
    },
    keywords: ['샐러드', '과일샐러드', '치킨샐러드', '포테이토샐러드'],
  ),
  FoodSubCategory(
    id: 'proc_sandwich',
    name: '샌드위치',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 2,
    },
    keywords: ['샌드위치', '클럽샌드위치', '에그샌드위치'],
  ),
  FoodSubCategory(
    id: 'proc_kimbap',
    name: '김밥',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.refrigerator: 1,
    },
    keywords: ['김밥', '충무김밥', '참치김밥'],
  ),
  FoodSubCategory(
    id: 'proc_frozen_meal',
    name: '냉동식품',
    parentCategory: FoodCategory.processed,
    shelfLifeDays: {
      StorageLocation.freezer: 180,
    },
    keywords: ['냉동', '냉동만두', '냉동피자', '냉동밥', '냉동볶음밥'],
  ),

  // ===== 음료 (beverages) =====
  FoodSubCategory(
    id: 'bev_juice',
    name: '과일주스',
    parentCategory: FoodCategory.beverages,
    shelfLifeDays: {
      StorageLocation.refrigerator: 7,
    },
    keywords: ['주스', '오렌지주스', '사과주스', '포도주스', '착즙주스'],
  ),
  FoodSubCategory(
    id: 'bev_coffee',
    name: '커피(액상)',
    parentCategory: FoodCategory.beverages,
    shelfLifeDays: {
      StorageLocation.refrigerator: 14,
    },
    keywords: ['커피', '아이스커피', '콜드브루', '라떼'],
  ),
];

/// 카테고리별 기본 보관기간 (서브카테고리 매칭 실패 시 사용)
const Map<FoodCategory, Map<StorageLocation, int>> categoryDefaults = {
  FoodCategory.meat: {
    StorageLocation.refrigerator: 3,
    StorageLocation.freezer: 90,
  },
  FoodCategory.seafood: {
    StorageLocation.refrigerator: 2,
    StorageLocation.freezer: 30,
  },
  FoodCategory.vegetables: {
    StorageLocation.refrigerator: 7,
    StorageLocation.freezer: 30,
  },
  FoodCategory.fruits: {
    StorageLocation.refrigerator: 7,
    StorageLocation.pantry: 5,
  },
  FoodCategory.dairy: {
    StorageLocation.refrigerator: 14,
  },
  FoodCategory.grains: {
    StorageLocation.refrigerator: 7,
    StorageLocation.pantry: 30,
    StorageLocation.freezer: 90,
  },
  FoodCategory.seasonings: {
    StorageLocation.refrigerator: 180,
    StorageLocation.pantry: 90,
  },
  FoodCategory.processed: {
    StorageLocation.refrigerator: 5,
    StorageLocation.freezer: 30,
  },
  FoodCategory.beverages: {
    StorageLocation.refrigerator: 7,
  },
  FoodCategory.other: {
    StorageLocation.refrigerator: 7,
    StorageLocation.pantry: 14,
  },
};
