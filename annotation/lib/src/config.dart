class GlobalConfig {
  final String fromMapName;
  final String toMapName;
  final bool includeFromMap;
  final bool includeToMap;

  const GlobalConfig({
    this.fromMapName = "fromMap",
    this.toMapName = "toMap",
    this.includeFromMap = false,
    this.includeToMap = false,
  });
}
