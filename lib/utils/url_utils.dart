const String kBaseUrl = "https://whisker-cart.onrender.com";

String resolveImageUrl(String? raw) {
  if (raw == null) return "";

  // 1. Trim whitespace
  String path = raw.trim();
  if (path.isEmpty) return "";

  // Keep bundled Flutter assets as local paths for offline fallback data.
  if (path.startsWith("assets/")) {
    return path;
  }

  // 2. If it is already an absolute URL, return it
  if (path.startsWith("http://") || path.startsWith("https://")) {
    return path;
  }

  // 3. Replace any occurrence of "/public/" with "/"
  path = path.replaceAll("/public/", "/");

  // 4. Remove leading "public/" if it exists
  if (path.startsWith("public/")) {
    path = path.substring(7);
  }

  // 5. Ensure path starts with exactly one leading slash
  if (!path.startsWith("/")) {
    path = "/$path";
  }

  // 6. Fix double slashes that might have been introduced
  path = path.replaceAll("//", "/");

  // Build final URL
  final String finalUrl = "$kBaseUrl$path";

  return finalUrl;
}
