// @author luwenjie on 20/04/2025 12:34:21

extension StringExtension on String {
  bool isMap() {
    final index = indexOf("<");
    if (index == -1) return false;
    final p = substring(0, index);
    return p.endsWith("Map");
  }

  bool isSet() {
    final index = indexOf("<");
    if (index == -1) return false;
    final p = substring(0, index);
    return p.endsWith("Set");
  }

  bool isList() {
    final index = indexOf("<");
    if (index == -1) return false;
    final p = substring(0, index);
    return p.endsWith("List");
  }

  bool isQueue() {
    final index = indexOf("<");
    if (index == -1) return false;
    final p = substring(0, index);
    return p.endsWith("Queue");
  }

  bool isIterable() {
    final index = indexOf("<");
    if (index == -1) return false;
    final p = substring(0, index);
    return p.endsWith("Iterable");
  }

  bool isCollection() {
    return isList() || isSet() || isMap() || isQueue() || isIterable();
  }
}
