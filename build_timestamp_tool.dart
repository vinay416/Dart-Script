import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:intl/intl.dart';

bool wroteBuildTimestamp = false;
String outputFilePath = 'lib/common/app_core/build_timestamp.dart';

Builder myTimestampBuilderFactory(BuilderOptions options) {
  // debugPrint('myTimestampBuilderFactory() called...');

  if (!wroteBuildTimestamp) {
    /// Write the current timestamp to the given file.
    // debugPrint('myTimestampBuilderFactory(): Writing timestamp to file "${outputFilePath}" ...');
    final buildDatetime = DateTime.now();
    final DateFormat formatter = DateFormat('MMM h:mm a');
    final String day = MyTimestampBuilder.dayOfMonth(buildDatetime.day);

    String outputContents = """
// ignore_for_file: constant_identifier_names\n
const String BUILD_TIMESTAMP = '$day ${formatter.format(buildDatetime)}';\r\n""";

    File dartFile = File(outputFilePath);
    dartFile.writeAsStringSync(outputContents, flush: true);

    /// truncates the file if it already exists.

    wroteBuildTimestamp = true;
  }

  return MyTimestampBuilder();
}

/// This class isn't really used. We just need it to convince build_runner to call our myTimestampBuilderFactory() method at build-time.
class MyTimestampBuilder extends Builder {
  /// IMPORTANT: build() only gets called for files that been updated (or if the whole build has been cleaned), since build_runner does incremental builds by default. So we can't rely on this method being called for every build.
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      '.dart': ['.dart_whatever']
    };
  }

  static final _dayMap = {1: 'st', 2: 'nd', 3: 'rd'};
  static String dayOfMonth(int day) => "$day${_dayMap[day] ?? 'th'}";
}
