// Global test environment detection helper
// Set `runningInTest` to true when asserts are enabled (i.e. during flutter test).
bool runningInTest = false;
void detectTestEnv() {
  assert(() {
    runningInTest = true;
    return true;
  }());
}
