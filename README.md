![Testkube Logo](https://raw.githubusercontent.com/kubeshop/testkube/main/assets/logo-dark-text.png)

# Welcome to TestKube K6 Executor

TestKube K6 Executor is a test executor to run K6 load tests with [TestKube](https://testkube.io).  
This repository is based on the [executor template](https://github.com/kubeshop/testkube-executor-template).

## Usage

First, you need to register a Executor CRD in your cluster.
```yaml
apiVersion: executor.testkube.io/v1
kind: Executor
metadata:
  name: k6-executor
  namespace: testkube
spec:
  executor_type: job
  image: lreimer/testkube-executor-k6:0.36.0
  types:
  - k6/script
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.