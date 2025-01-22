import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

bool wroteSentryScript = false;
String outputFilePath = 'sentryRelease.sh';

const String _highlightText = '''
#### HIGHLIGHT TEXT ####
highlightWIP() {
  TEXT=\$1
  echo -e "\\e[1;33m \$TEXT \\e[0m"
}

highlightSuccess() {
  TEXT=\$1
  echo -e "\\e[1;32m \$TEXT \\e[0m"
}

#########################
# SENTRY SCRIPT\n
''';

Builder mySentryReleaseBuilderFactory(BuilderOptions options) {
  const String org = 'organization';
  const String project = 'my-app';
  const String package = 'com.example.new';

  if (!wroteSentryScript) {
    File file = File("pubspec.yaml");
    file.readAsString().then((value) {
      final String versionPub = loadYaml(value)["version"] as String;
      final String version = versionPub.substring(0, versionPub.indexOf('+'));
      final String buildNo = versionPub.substring(versionPub.indexOf('+'));
      final String releaseVersion = '$package.\$1@$version.\$1$buildNo';
      const String env = '\${1^}-release';

      String outputContents = """$_highlightText
highlightWIP "Creating Sentry $env"
sentry-cli releases new --org $org --project $project $releaseVersion

highlightWIP "Mapping Code commits"
sentry-cli releases --org $org set-commits --auto $releaseVersion

highlightWIP "Finalizing Sentry release"
sentry-cli releases --org $org finalize $releaseVersion

highlightWIP "Deploying Sentry release 🚀"
sentry-cli releases --org $org deploys $releaseVersion new -e $env

highlightSuccess "✅ Sentry $env Deployed 🙌"
""";

      File dartFile = File(outputFilePath);
      dartFile.writeAsStringSync(outputContents, flush: true);

      wroteSentryScript = true;
    });
  }

  return MySentryReleaseBuilder();
}

class MySentryReleaseBuilder extends Builder {
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      '.dart': ['.sh']
    };
  }
}
