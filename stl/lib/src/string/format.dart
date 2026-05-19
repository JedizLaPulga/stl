/// A type-safe, powerful string formatting utility inspired by C++20 `<format>`.
///
/// Implements a Python/`std::format` style template string system.
/// Uses a `List<dynamic>` to pass variadic arguments while safely checking types
/// before injection.
String format(String fmt, [List<dynamic> args = const []]) {
  final buffer = StringBuffer();
  var i = 0;
  var argIndex = 0;

  while (i < fmt.length) {
    if (fmt[i] == '{') {
      if (i + 1 < fmt.length && fmt[i + 1] == '{') {
        // Escaped brace {{
        buffer.write('{');
        i += 2;
        continue;
      }

      final closeIdx = fmt.indexOf('}', i + 1);
      if (closeIdx == -1) {
        throw FormatException("Unmatched '{' in format string.");
      }

      final token = fmt.substring(i + 1, closeIdx);
      i = closeIdx + 1;

      // Extract optional format specifier, e.g., {0:.2f}
      var indexStr = token;
      var specifier = '';
      final colonIdx = token.indexOf(':');
      if (colonIdx != -1) {
        indexStr = token.substring(0, colonIdx);
        specifier = token.substring(colonIdx + 1);
      }

      int currentArgIdx;
      if (indexStr.isEmpty) {
        currentArgIdx = argIndex++;
      } else {
        final parsed = int.tryParse(indexStr);
        if (parsed == null) {
          throw FormatException("Invalid index '$indexStr' in format string.");
        }
        currentArgIdx = parsed;
      }

      if (currentArgIdx < 0 || currentArgIdx >= args.length) {
        throw RangeError.index(currentArgIdx, args, 'args',
            'Format index out of bounds. Passed ${args.length} arguments.');
      }

      final arg = args[currentArgIdx];
      buffer.write(_applySpecifier(arg, specifier));
    } else if (fmt[i] == '}') {
      if (i + 1 < fmt.length && fmt[i + 1] == '}') {
        // Escaped brace }}
        buffer.write('}');
        i += 2;
        continue;
      }
      throw FormatException("Unmatched '}' in format string.");
    } else {
      buffer.write(fmt[i]);
      i++;
    }
  }

  return buffer.toString();
}

String _applySpecifier(dynamic arg, String specifier) {
  if (specifier.isEmpty) return arg.toString();

  // Basic type guarding & specifier handling
  if (arg is num) {
    if (specifier.endsWith('f')) {
      final precisionStr = specifier.substring(1, specifier.length - 1); // e.g. .2
      final precision = int.tryParse(precisionStr) ?? 2;
      return arg.toStringAsFixed(precision);
    } else if (specifier == 'x' && arg is int) {
      return arg.toRadixString(16);
    } else if (specifier == 'X' && arg is int) {
      return arg.toRadixString(16).toUpperCase();
    } else if (specifier.endsWith('d') && arg is int) {
      var padStr = specifier.substring(0, specifier.length - 1);
      var padChar = ' ';
      if (padStr.startsWith('0')) {
        padChar = '0';
        padStr = padStr.substring(1);
      }
      final padCount = int.tryParse(padStr) ?? 0;
      return arg.toString().padLeft(padCount, padChar);
    }
  }

  // Fallback if specifier doesn't match type
  return arg.toString();
}

/// Utility to immediately print a formatted string, mirroring `std::print` (C++23).
void printFormat(String fmt, [List<dynamic> args = const []]) {
  print(format(fmt, args));
}
