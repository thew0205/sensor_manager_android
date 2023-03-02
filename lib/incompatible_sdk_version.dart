class IncompatibleSDKVersionException implements Exception {
  final int minSDKVersion;

  const IncompatibleSDKVersionException(this.minSDKVersion);
  @override
  String toString() {
    return  "Requires SDK version of at least $minSDKVersion.\nCall getSDKVersion to the e SK version.";
  }
}
