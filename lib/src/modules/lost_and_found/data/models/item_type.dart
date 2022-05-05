class ItemType {
  final String type;
  final String id;
  ItemType({
    required this.type,
    required this.id,
  });

  static List<ItemType> get itemTypes => [
        ItemType(type: 'Lost Item', id: 'lost'),
        ItemType(type: 'Found Item', id: 'found'),
      ];
}