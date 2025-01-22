#!/bin/bash

#### HIGHLIGHT TEXT ####
highlightError() {
   TEXT=$1
   echo -e "\e[1;31m $TEXT \e[0m"
}

highlightWIP() {
   TEXT=$1
   echo -e "\e[1;33m $TEXT \e[0m"
}

highlightSuccess() {
   TEXT=$1
   echo -e "\e[1;32m $TEXT \e[0m"
}

highlightBackground() {
   TEXT=$1
   echo -e "\e[1;43m $TEXT \e[0m"
}

#########################
# BUILD SCRIPT

FLAVOR=""
case "$1" in
   "stagging") FLAVOR="qtest"
   ;;
   "dev" | "prod") 
      FLAVOR=$1
   ;;
esac

if [ -z "$FLAVOR" ]; then 
   highlightError "Error! ---> Build Flavor not matched"
   exit -1
fi   

highlightWIP "Building $FLAVOR"

flutter clean
flutter pub get

highlightWIP "Updating release build app.const"
dart run build_runner build

highlightWIP "Generating release APK"
flutter build apk --flavor $FLAVOR --dart-define-from-file secret_keys.json -t lib/main_$1.dart

highlightSuccess "🎉 Release APK Success 😊\n"

####### SENTRY RELEASE PROMPT ########

highlightBackground "Deploy ${1^} Release To Sentry? Enter Y/N"
YES="Y"
read -p " Answer:" SentryDeploy
if [ ${SentryDeploy^} != $YES ]; then 
   exit -1
fi   

sh ./sentryRelease.sh $1

############################################################

# First time build (Permission error)
# chmod +x cleanAndRebuild.sh <Flavor>

# Using bash
# ./cleanAndRebuild.sh <Flavor>

# Using CMD 
# cleanAndRebuild.sh <Flavor>