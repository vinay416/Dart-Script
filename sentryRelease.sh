#### HIGHLIGHT TEXT ####
highlightWIP() {
  TEXT=$1
  echo -e "\e[1;33m $TEXT \e[0m"
}

highlightSuccess() {
  TEXT=$1
  echo -e "\e[1;32m $TEXT \e[0m"
}

#########################
# SENTRY SCRIPT


highlightWIP "Creating Sentry ${1^}-release"
sentry-cli releases new --org elredio --project myApp com.example.new.$1@1.3.1.$1+19

highlightWIP "Mapping Code commits"
sentry-cli releases --org elredio set-commits --auto com.example.new.$1@1.3.1.$1+19

highlightWIP "Finalizing Sentry release"
sentry-cli releases --org elredio finalize com.example.new.$1@1.3.1.$1+19

highlightWIP "Deploying Sentry release 🚀"
sentry-cli releases --org elredio deploys com.example.new.$1@1.3.1.$1+19 new -e ${1^}-release

highlightSuccess "✅ Sentry ${1^}-release Deployed 🙌"
