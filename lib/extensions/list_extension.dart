extension ListExtension<T> on List<T> {
  List<T> duplicates(List<T> otherList) {
    return where((element) => otherList
        .where((otherElement) => otherElement == element)
        .isNotEmpty).toList();
  }
}
