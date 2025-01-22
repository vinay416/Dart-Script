//Sentry commands

**Create new release**
sentry-cli releases new --org elredio --project elred-app com.example.new@1.3.1+19

**Set commits auto** (code needs to be already pushed to github)
sentry-cli releases --org elredio set-commits --auto com.example.new@1.3.1+19

**Finalize release** 
sentry-cli releases --org elredio finalize com.example.new@1.3.1+19

**Deploy release**
sentry-cli releases --org elredio deploys com.example.new@1.3.1+19 new -e Test-release



//** TEST
com.example.new.test@1.5.0.test+8 new -e Test-release



**This command takes commit after last release to mentioned commit id (to)**:

// TEST
sentry-cli releases --org elredio set-commits --commit NeelTheDev/elRedM1a@14b4f2dcbc980f6d3df273c0ec0419f7cbf4f41d com.example.new.test@1.5.0.test+8


