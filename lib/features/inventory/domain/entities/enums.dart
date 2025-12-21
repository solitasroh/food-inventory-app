enum StorageLocation {
  refrigerator('냉장고'),
  freezer('냉동고'),
  pantry('팬트리'),
  other('기타');

  final String label;
  const StorageLocation(this.label);
}

enum FoodCategory {
  vegetables('채소'),
  fruits('과일'),
  meat('육류'),
  seafood('해산물'),
  dairy('유제품'),
  grains('곡류'),
  seasonings('조미료'),
  processed('가공식품'),
  beverages('음료'),
  other('기타');

  final String label;
  const FoodCategory(this.label);
}
